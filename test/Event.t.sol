// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "src/Event.sol";

contract EventTest is Test {
    Event public eventContract;

    function setUp() public {
        eventContract = new Event();
    }

    function testEventLogs() public {
        // Expect the first Log event with "Hello World!".
        // The first parameter is indexed, so we set the first boolean to true.
        // The fourth parameter (data) is also checked, hence true.
        vm.expectEmit(true, false, false, true);
        emit Event.Log(address(this), "Hello World!");

        vm.expectEmit(true, false, false, true);
        emit Event.Log(address(this), "Hello EVM!");

        vm.expectEmit(false, false, false, false);
        emit Event.AnotherLog();

        // Call the test function, which should emit the events.
        eventContract.test();
    }
}
