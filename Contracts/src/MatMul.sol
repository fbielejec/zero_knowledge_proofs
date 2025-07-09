// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { EC, ECPoint } from "../src/EC.sol";

contract MatMul is EC {
    // returns true if mS == oG element-wise.
    function matMul(
        uint256[] calldata matrix,
        uint256 n, // n x n for the matrix
        ECPoint[] calldata s, // n elements
        uint256[] calldata o // n elements
    ) public view returns (bool verified) {
        // revert if the matrices are empty
        require(n > 0, "n needs to be at least 1");

        // reverts if dimensions don't make sense
        require(matrix.length == n * n, "m is not an n x n matrix");
        require(s.length == n, "a is not an n x 1 matrix");
        require(o.length == n, "o is not an 1 x n matrix");

        // performs n equality checks
        for (uint256 row = 0; row < n; row++) {
            (uint256 Ox, uint256 Oy) = scalarMultiply(
                s[0].x,
                s[0].y,
                matrix[row * n]
            );

            for (uint256 col = 1; col < n; col++) {
                (uint256 x, uint256 y) = scalarMultiply(
                    s[col].x,
                    s[col].y,
                    matrix[row * n + col]
                );

                (Ox, Oy) = ecAdd(Ox, Oy, x, y);
            }

            (uint256 expectedX, uint256 expectedY) = scalarMultiply(
                G.x,
                G.y,
                o[row]
            );

            if (!(Ox == expectedX && Oy == expectedY)) {
                return false;
            }
        }
        return true;
    }
}
