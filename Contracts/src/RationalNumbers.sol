// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { EC, ECPoint } from "../src/EC.sol";

contract RationalNumbers is EC {
    /* returns true if the prover knows two numbers that add up to num/den */
    function rationalAdd(
        ECPoint calldata A,
        ECPoint calldata B,
        uint256 num,
        uint256 den
    ) public view returns (bool verified) {
        require(num <= SCALAR_FIELD_MODULUS && den <= SCALAR_FIELD_MODULUS);

        // [a]G + [b]G = A + B = [a+b]G
        (uint256 x1, uint y1) = ecAdd(A.x, A.y, B.x, B.y);
        // den^-1
        uint256 denInv = modExp(
            den,
            SCALAR_FIELD_MODULUS - 2,
            SCALAR_FIELD_MODULUS
        );
        // [num / den] * G
        uint256 scalar = (num * denInv) % SCALAR_FIELD_MODULUS;
        (uint256 x2, uint y2) = scalarMultiply(G.x, G.y, scalar);

        if (x1 == x2 && y1 == y2) {
            return true;
        }

        return false;
    }
}
