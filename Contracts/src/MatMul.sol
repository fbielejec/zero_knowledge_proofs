// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

struct ECPoint {
    uint256 x;
    uint256 y;
}

contract MatMul {
    uint256 public constant FIELD_MODULUS =
        21888242871839275222246405745257275088696311157297823662689037894645226208583;

    function ecAdd(
        uint Ax,
        uint Ay,
        uint Bx,
        uint By
    ) public view returns (uint256 Cx, uint Cy) {
        bytes memory payload = abi.encode(Ax, Ay, Bx, By);
        (bool ok, bytes memory answer) = address(6).staticcall(payload);
        require(ok, "ecAdd Failed");
        (Cx, Cy) = abi.decode(answer, (uint, uint));
    }

    function scalarMultiply(
        uint Ax,
        uint Ay,
        uint scalar
    ) public view returns (uint256 Cx, uint Cy) {
        bytes memory payload = abi.encode(Ax, Ay, scalar);
        (bool ok, bytes memory answer) = address(7).staticcall(payload);
        require(ok, "scalarMultiply failed");
        (Cx, Cy) = abi.decode(answer, (uint, uint));
    }

    function matMul(
        uint256[] calldata matrix,
        uint256 n, // n x n for the matrix
        ECPoint[] calldata s, // n elements
        ECPoint[] calldata o // n elements
    ) public view returns (bool verified) {
        // TODO revert if dimensions don't make sense or the matrices are empty
        // return true if Ms == o element-wise.
        // You need to do n equality checks.

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

            uint256 expectedX = o[row].x;
            uint256 expectedY = o[row].y;

            if (!(Ox == expectedX && Oy == expectedY)) {
                return false;
            }
        }
        return true;
    }
}
