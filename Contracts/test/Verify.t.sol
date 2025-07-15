// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test, console } from "forge-std/Test.sol";
import { Verify, G1Point, G2Point } from "../src/Verify.sol";

contract TestVerify is Test {
    Verify public verify;

    function setUp() public {
        verify = new Verify();
    }

    function test_verify() public view {
        G1Point memory A1 = G1Point(
            4444740815889402603535294170722302758225367627362056425101568584910268024244,
            11350979775309792057627585728092606167309854128733159954336302813744955667163
        );

        G2Point memory B2 = G2Point(
            // (a0 + a1*i)
            [
                15624790064206502667756020446826209080711344272800176518784649088946231692936, // a1
                8472151341754925747860535367990505955708751825377817860727104273184244800723 // a0
            ],
            // (a0 + a1*i)
            [
                19488077321171448217727198730828487286865984357780136663388739985720647978898,
                1196137947243150610106053819405501111182787323156221967342356892090037828244
            ]
        );

        G1Point memory C1 = G1Point(
            10415861484417082502655338383609494480414113902179649885744799961447382638712,
            10196215078179488638353184030336251401353352596818396260819493263908881608606
        );

        bool verifies = verify.verify(A1, B2, C1, 1, 2, 3);

        assert(verifies);
    }
}
