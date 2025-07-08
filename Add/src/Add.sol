// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Add {
    function add(
        uint Ax,
        uint Ay,
        uint Bx,
        uint By
    ) public view returns (uint256 Cx, uint Cy) {
        bytes memory payload = abi.encode(Ax, Ay, Bx, By);

        (bool ok, bytes memory answer) = address(6).staticcall(payload);
        require(ok, "Failed");

        (Cx, Cy) = abi.decode(answer, (uint, uint));
    }
}
