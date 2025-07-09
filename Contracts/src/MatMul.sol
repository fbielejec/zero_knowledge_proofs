// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

struct ECPoint {
    uint256 x;
    uint256 y;
}

contract RationalNumbers {
    uint256 public constant FIELD_MODULUS =
        21888242871839275222246405745257275088696311157297823662689037894645226208583;

    function matmul(
        uint256[] calldata matrix,
        uint256 n, // n x n for the matrix
        ECPoint[] calldata s, // n elements
        uint256[] calldata o // n elements
    ) public returns (bool verified) {
        // revert if dimensions don't make sense or the matrices are empty
        // return true if Ms == o elementwise. You need to do n equality checks. If you're lazy, you can hardcode n to 3, but it is suggested that you do this with a for loop
    }
}
