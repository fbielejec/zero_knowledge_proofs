// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test, console } from "forge-std/Test.sol";
import { Add } from "../src/Add.sol";

contract AddTest is Test {
    Add public add;

    function setUp() public {
        add = new Add();
    }

    function test_add() public view {
        (uint x1, uint y1) = add.add(1, 2, 1, 2);

        console.logUint(x1);
        console.logUint(y1);

        (uint x2, uint y2) = add.multiply(1, 2, 2);

        console.logUint(x2);
        console.logUint(y2);

        assertEq(x1, x2);
        assertEq(y1, y2);
    }
}
