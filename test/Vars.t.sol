// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {Variables} from "src/Vars.sol";

contract VarsTest is Test {
    Variables public vars;

    function setUp() public {
        vm.warp(1700000000);
        vars = new Variables(42);
    }

    function test_getTimestamp() public view {
        uint256 timestamp = vars.getTimestamp();
        console.log("Timestamp: %d", timestamp);
        assert(timestamp > 0);
    }

    // function test_getNum() public {
    //     uint256 num = vars.num;
    //     console.log("Num: %d", num);
    // }

    function testGetOwner() public view {
        address owner = vars.OWNER();
        console.log("Owner: %s", owner);
        assert(owner != address(0));
    }

    function testTransferOwnership() public {
        address newOwner = 0x1234567890123456789012345678901234567890;
        vars.transferOwnership(newOwner);
        address owner = vars.OWNER();
        console.log("Owner: %s", owner);
        assertEq(owner, newOwner);
    }

    function testImmutable() public view {
        address myAddr = vars.myAddr();
        console.log("myAddr: %s", myAddr);
        assert(myAddr != address(0));

        uint256 magicNumber = vars.magicNumber();
        console.log("magicNumber: %d", magicNumber);
        assertEq(magicNumber, 42);
    }
}
