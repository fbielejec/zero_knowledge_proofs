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
        (uint x, uint y) = add.add(1, 2, 1, 2);

        console.logUint(x);
        console.logUint(y);
    }
}
