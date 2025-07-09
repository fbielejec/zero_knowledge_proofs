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
        uint256[9] memory m = [uint256(1), 2, 3, 4, 5, 6, 7, 8, 9];

        ECPoint memory P = ECPoint(
            13453625245081473323808800353457225167565869664644760646910557039566341930214,
            4227682114029646314567541970710863318074729154136213749391007310372880966063
        );
        ECPoint memory Q = ECPoint(
            13431748881895426318069326578769457798764333156409950070530459285171032786037,
            4704746378805358354216631959117307222383707841904620695862391712577937195840
        );
        ECPoint memory R = ECPoint(
            542246685971526926955790925550598566272961373384322457226886801516496135350,
            1616604444639123685329550154354051286838809788250709485957146257190462073332
        );

        (uint256 mPx, uint256 mPy) = matMul.scalarMultiply(P.x, P.y, m[0]);
        (uint256 mQx, uint256 mQy) = matMul.scalarMultiply(Q.x, Q.y, m[1]);
        (uint256 mRx, uint256 mRy) = matMul.scalarMultiply(R.x, R.y, m[2]);

        (uint256 O1x, uint256 O1y) = matMul.ecAdd(mPx, mPy, mQx, mQy);
        (O1x, O1y) = matMul.ecAdd(O1x, O1y, mRx, mRy);

        (mPx, mPy) = matMul.scalarMultiply(P.x, P.y, m[3]);
        (mQx, mQy) = matMul.scalarMultiply(Q.x, Q.y, m[4]);
        (mRx, mRy) = matMul.scalarMultiply(R.x, R.y, m[5]);

        (uint256 O2x, uint256 O2y) = matMul.ecAdd(mPx, mPy, mQx, mQy);
        (O2x, O2y) = matMul.ecAdd(O2x, O2y, mRx, mRy);

        (mPx, mPy) = matMul.scalarMultiply(P.x, P.y, m[6]);
        (mQx, mQy) = matMul.scalarMultiply(Q.x, Q.y, m[7]);
        (mRx, mRy) = matMul.scalarMultiply(R.x, R.y, m[8]);

        (uint256 O3x, uint256 O3y) = matMul.ecAdd(mPx, mPy, mQx, mQy);
        (O3x, O3y) = matMul.ecAdd(O3x, O3y, mRx, mRy);

        ECPoint[3] memory O = [
            ECPoint(O1x, O1y),
            ECPoint(O2x, O2y),
            ECPoint(O3x, O3y)
        ];
        ECPoint[3] memory S = [P, Q, R];
    }
}
