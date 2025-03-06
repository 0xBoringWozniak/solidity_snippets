// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import "src/OwnableContract.sol";

contract OwnableDataContractTest is Test {
    address initial;
    OwnableDataContract public owContract;

    function setUp() public {
        address randomAddress = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        initial = randomAddress;
        vm.prank(initial);
        owContract = new OwnableDataContract();
    }

    function testOwner() public view {
        address currentOwner = owContract.owner();
        console.logAddress(currentOwner);
        assertEq(currentOwner, initial);
    }

    function test_updateImportantNumber() public {
        address randomAddress = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
        vm.prank(randomAddress);
        vm.expectRevert();
        owContract.updateImportantNumber(1);
    }
}
