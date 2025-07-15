// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { EC, ECPoint as G1Point } from "../src/EC.sol";

struct G2Point {
    uint256[2] x; // [a,b] -> a + b*i
    uint256[2] y; // [a,b] -> a + b*i
}

contract Verify is EC {
    function verify(
        G1Point calldata A1,
        G2Point calldata B2,
        G1Point calldata Alpha1,
        G2Point calldata Beta2,
        G2Point calldata Gamma2,
        G1Point calldata C1,
        G2Point calldata Delta2,
        uint256 x1,
        uint256 x2,
        uint256 x3
    ) public view returns (bool verified) {
        (uint256 X1x, uint256 X1y) = scalarMultiply(G.x, G.y, x1 + x2 + x3);

        bytes memory payload = abi.encode(
            A1.x,
            A1.y,
            B2.x[0],
            B2.x[1],
            B2.y[0],
            B2.y[1],
            Alpha1.x,
            Alpha1.y,
            Beta2.x[0],
            Beta2.x[1],
            Beta2.y[0],
            Beta2.y[1],
            X1x,
            X1y,
            Gamma2.x[0],
            Gamma2.x[1],
            Gamma2.y[0],
            Gamma2.y[1],
            C1.x,
            C1.y,
            Delta2.x[0],
            Delta2.x[1],
            Delta2.y[0],
            Delta2.y[1]
        );

        (bool ok, bytes memory response) = address(8).staticcall(payload);
        require(ok, "verify failed");
        return abi.decode(response, (bool));
    }
}
