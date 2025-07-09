// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test, console } from "forge-std/Test.sol";
import { ECPoint, MatMul } from "../src/MatMul.sol";

contract TestMatMul is Test {
    MatMul public matMul;

    function setUp() public {
        matMul = new MatMul();
    }

    function test_matMul() public view {
        uint256[] memory m = new uint256[](9);
        m[0] = uint256(1);
        m[1] = 2;
        m[2] = 3;
        m[3] = 4;
        m[4] = 5;
        m[5] = 6;
        m[6] = 7;
        m[7] = 8;
        m[8] = 9;

        (uint256 Gx, uint256 Gy) = matMul.G();
        ECPoint memory P = ECPoint(Gx, Gy);
        (uint256 x, uint256 y) = matMul.scalarMultiply(Gx, Gy, 2);
        ECPoint memory Q = ECPoint(x, y);
        (x, y) = matMul.scalarMultiply(Gx, Gy, 3);
        ECPoint memory R = ECPoint(x, y);

        uint256[] memory o = new uint256[](3);
        o[0] = 1 + 2 * 2 + 3 * 3;
        o[1] = 4 + 5 * 2 + 6 * 3;
        o[2] = 7 + 8 * 2 + 9 * 3;

        ECPoint[] memory S = new ECPoint[](3);
        S[0] = P;
        S[1] = Q;
        S[2] = R;

        bool result = matMul.matMul(m, 3, S, o);
        assert(result);

        o[0] = 0;
        result = matMul.matMul(m, 3, S, o);
        assert(!result);
    }
}
