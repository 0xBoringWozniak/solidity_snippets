// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {ObjectFactory, ObjectContract} from "../src/Factory.sol";

contract FactoryTest is Test {
    ObjectFactory internal factory;
    address internal signer1 = address(0x123);
    address internal signer2 = address(0x1234);

    function setUp() external {
        factory = new ObjectFactory();
    }

    function test_CreateContract() external {
        address deployedAddress = factory.create(signer1, signer2);

        ObjectContract deployed = factory.deployedContractsRegistry(0);

        assertEq(deployed.signer1(), signer1);
        assertEq(deployed.signer2(), signer2);
        assertEq(address(deployed), deployedAddress);
    }
}
