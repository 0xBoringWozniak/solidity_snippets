// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import {CounterV1} from "../src/CounterV1.sol";
import {CounterV2} from "../src/CounterV2.sol";

contract CounterUUPSTest is Test {
    CounterV1 internal implementationV1;
    CounterV2 internal implementationV2;

    address internal proxyAddress;
    address internal upgrader = address(0x1234);
    address internal notUpgrader = address(0x12345);

    function setUp() external {
        implementationV1 = new CounterV1();

        bytes memory initData = abi.encodeCall(CounterV1.initialize, (10, upgrader));

        ERC1967Proxy proxy = new ERC1967Proxy(address(implementationV1), initData);
        proxyAddress = address(proxy);
    }

    function test_DeployV1State() external view {
        CounterV1 counter = CounterV1(proxyAddress);
        assertEq(counter.version(), "V1");
        assertEq(counter.upgrader(), upgrader);
    }

    function test_UpgradeToV2_V2State() external {
        CounterV1 counterV1 = CounterV1(proxyAddress);
        implementationV2 = new CounterV2();

        bytes memory initData = abi.encodeCall(CounterV2.initializeV2, (2));

        vm.prank(upgrader);
        counterV1.upgradeToAndCall(address(implementationV2), initData);

        CounterV2 counter = CounterV2(proxyAddress);
        assertEq(counter.version(), "V2");
        assertEq(counter.upgrader(), upgrader);
        assertEq(counter.step(), 2);
    }

    function test_CheckWhenReinitilizeTwice() external {
        CounterV1 counterV1 = CounterV1(proxyAddress);
        implementationV2 = new CounterV2();

        bytes memory initData = abi.encodeCall(CounterV2.initializeV2, (2));

        vm.prank(upgrader);
        counterV1.upgradeToAndCall(address(implementationV2), initData);

        CounterV2 counter = CounterV2(proxyAddress);

        vm.expectRevert();
        counter.initializeV2(10000);
    }
}
