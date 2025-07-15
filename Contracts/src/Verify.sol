// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { EC, ECPoint as G1Point } from "../src/EC.sol";

struct G2Point {
    uint256[2] x; // [a,b] -> a + b*i
    uint256[2] y; // [a,b] -> a + b*i
}

contract Verify is EC {
    // (11559732032986387107991004021392285783925812861821192530917403151452391805634*i + 10857046999023057135944570762232829481370756359578518086990519993285655852781
    //  4082367875863433681332203403145435568316851327593401208105741076214120093531*i + 8495653923123431417604973247489272438418190587263600148770280649306958101930 : 1)

    G2Point G2 =
        G2Point(
            [
                10857046999023057135944570762232829481370756359578518086990519993285655852781,
                11559732032986387107991004021392285783925812861821192530917403151452391805634
            ],
            [
                8495653923123431417604973247489272438418190587263600148770280649306958101930,
                4082367875863433681332203403145435568316851327593401208105741076214120093531
            ]
        );

    //

    // function pairing(uint256[24] memory input) public view returns (bool) {
    //     assembly {
    //         let success := staticcall(gas(), 0x08, input, 0x0180, input, 0x20)
    //         if success {
    //             return(input, 0x20)
    //         }
    //     }
    //     revert("Wrong pairing");
    // }

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
    }
}
