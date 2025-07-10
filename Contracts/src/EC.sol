// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

struct ECPoint {
    uint256 x;
    uint256 y;
}

contract EC {
    uint256 public constant BASE_FIELD_MODULUS =
        21888242871839275222246405745257275088696311157297823662689037894645226208583;

    uint256 public constant SCALAR_FIELD_MODULUS =
        21888242871839275222246405745257275088548364400416034343698204186575808495617;

    ECPoint public G = ECPoint(1, 2);

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

    // computes multiplicative inverse x^-1 % mod
    // uses FLT
    function modInverse(uint256 x, uint256 mod) public view returns (uint256) {
        return modExp(x, mod - 2, mod);
    }

    // computes base^exp % mod
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
