// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {Gas} from "src/Gas.sol";

contract GsaTest is Test {
    Gas public gas;

    function setUp() public {
        gas = new Gas();
    }

    function test_loop() public {
        gas.forever();
    }
}
