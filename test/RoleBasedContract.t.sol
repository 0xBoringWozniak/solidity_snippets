// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {RoleBasedContract} from "src/RoleBasedContract.sol";

contract RoleBasedContractTest is Test {
    RoleBasedContract public rbContract;

    function setUp() public {
        rbContract = new RoleBasedContract();
        bytes32 operator = rbContract.OPERATOR();
        rbContract.grantRole(operator, 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
    }

    function test_adminFunction() public {
        vm.prank(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        vm.expectRevert();
        rbContract.adminFunction(1);
    }
}
