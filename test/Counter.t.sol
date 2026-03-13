// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;
    address public owner = address(0x123);
    uint256 public initialNumber = 100;

    function setUp() public {
        vm.prank(owner);
        counter = new Counter(initialNumber);
    }

    function test_OwnerIsSet() public view {
        console2.log("Owner:", counter.owner());
        assertEq(counter.owner(), owner);
    }

    function test_Increment() public {
        vm.prank(address(0x321));
        counter.increment();
        assertEq(counter.getNumber(), initialNumber + 1);
    }

    function test_Decrement() public {
        vm.prank(owner);
        counter.decrement();
        assertEq(counter.getNumber(), initialNumber - 1);
    }

    function test_nonOwnerCannotDecrement() public {
        vm.prank(address(0x321));
        vm.expectRevert();
        counter.decrement();
    }

    function testFuzz_IncrementIncreasesByOne(uint256 x) public {
        vm.assume(x < type(uint256).max);

        // Deploy a fresh counter with fuzzed initial value.
        vm.prank(owner);
        Counter c = new Counter(x);

        c.increment();
        assertEq(c.getNumber(), x + 1);
    }

    function test_transferOwnership() public {
        address newOwner = address(0x456);
        vm.prank(owner);
        counter.transferOwnership(newOwner);
        assertEq(counter.owner(), newOwner);

        // check that the new owner can decrement
        vm.prank(newOwner);
        counter.decrement();
        assertEq(counter.getNumber(), initialNumber - 1);

        // check that the old owner can no longer decrement
        vm.prank(owner);
        vm.expectRevert();
        counter.decrement();
    }
}
