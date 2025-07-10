// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test, console } from "forge-std/Test.sol";
import { ECPoint, RationalNumbers } from "../src/RationalNumbers.sol";

contract TestRationalNumbers is Test {
    RationalNumbers public rationalNumbers;

    function setUp() public {
        rationalNumbers = new RationalNumbers();
    }

    function test_rationalAdd() public view {
        uint256 a = 2;
        uint256 b = 3;
        uint256 den = 2;
        uint256 num = (a + b) * den;

        // this should be done in the base field but the numbers are so small it doesn't matter
        assertEq(a + b, (num / den));

        // bn128 curve generator
        (uint256 xG, uint256 yG) = rationalNumbers.G();

        (uint256 xA, uint256 yA) = rationalNumbers.scalarMultiply(xG, yG, a);
        (uint256 xB, uint256 yB) = rationalNumbers.scalarMultiply(xG, yG, b);

        bool verifies = rationalNumbers.rationalAdd(
            ECPoint(xA, yA),
            ECPoint(xB, yB),
            num,
            den
        );

        assert(verifies);

        (uint256 xA_prime, uint256 yA_prime) = rationalNumbers.scalarMultiply(
            xG,
            yG,
            3
        );
        (uint256 xB_prime, uint256 yB_prime) = rationalNumbers.scalarMultiply(
            xG,
            yG,
            4
        );

        verifies = rationalNumbers.rationalAdd(
            ECPoint(xA_prime, yA_prime),
            ECPoint(xB_prime, yB_prime),
            num,
            den
        );

        assert(!verifies);
    }
}
