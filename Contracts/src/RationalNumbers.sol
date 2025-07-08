// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

struct ECPoint {
    uint256 x;
    uint256 y;
}

contract RationalNumbers {
    uint256 public constant FIELD_MODULUS =
        21888242871839275222246405745257275088696311157297823662689037894645226208583;

    /* returns true if the prover knows two numbers that add up to num/den */
    function rationalAdd(
        ECPoint calldata A,
        ECPoint calldata B,
        uint256 num,
        uint256 den
    ) public view returns (bool verified) {
        require(num <= FIELD_MODULUS && den <= FIELD_MODULUS);

        // [a]G + [b]G = A + B = [a+b]G
        (uint256 x1, uint y1) = ecAdd(A.x, A.y, B.x, B.y);
        // den^-1
        uint256 denInv = modExp(den, FIELD_MODULUS - 2, FIELD_MODULUS);
        // [num / den] * G
        uint256 scalar = (num * denInv) % FIELD_MODULUS;
        (uint256 x2, uint y2) = scalarMultiply(1, 2, scalar);

        if (x1 == x2 && y1 == y2) {
            return true;
        }

        return false;
    }

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

    function modExp(
        uint256 base,
        uint256 exp,
        uint256 mod
    ) public view returns (uint256) {
        bytes memory precompileData = abi.encode(32, 32, 32, base, exp, mod);
        (bool ok, bytes memory data) = address(5).staticcall(precompileData);
        require(ok, "modExp failed");
        return abi.decode(data, (uint256));
    }
}
