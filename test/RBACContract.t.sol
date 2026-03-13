// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {RBACContract} from "../src/RBAC.sol";
import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";

contract RBACContractTest is Test {
    RBACContract internal rbac;

    address internal admin = address(this);
    address internal operator = address(0xB0B);
    address internal outsider = address(0xCAFE);

    function setUp() public {
        rbac = new RBACContract();
    }

    function test_DeployerHasAdminRole() public view {
        assertTrue(rbac.hasRole(rbac.DEFAULT_ADMIN_ROLE(), admin));
    }

    function test_NonAdminCannotCallAdminFunction() public {
        vm.expectRevert(
            abi.encodeWithSelector(
                IAccessControl.AccessControlUnauthorizedAccount.selector, outsider, rbac.DEFAULT_ADMIN_ROLE()
            )
        );
        vm.prank(outsider);
        rbac.setFee(1);
    }

    function test_AdminCanGrantOperatorRole() public {
        rbac.grantRole(rbac.OPERATOR(), operator);

        assertTrue(rbac.hasRole(rbac.OPERATOR(), operator));

        vm.prank(operator);
        rbac.changeFee(5, true);

        vm.prank(operator);
        vm.expectRevert();
        rbac.changeFee(105, false);
    }
}
