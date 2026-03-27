// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import {CounterV1} from "../src/CounterV1.sol";
import {CounterV2} from "../src/CounterV2.sol";

contract UpdCounterScript is Script {
    function deploy() external returns (address proxyAddress, address implementationAddress) {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address upgrader = vm.addr(privateKey);

        vm.startBroadcast(privateKey);

        CounterV1 implementation = new CounterV1();

        bytes memory initData = abi.encodeCall(CounterV1.initialize, (10, upgrader));

        ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), initData);

        vm.stopBroadcast();

        proxyAddress = address(proxy);
        implementationAddress = address(implementation);
        CounterV1 counter = CounterV1(proxyAddress);

        console2.log("Impl:", implementationAddress);
        console2.log("Proxy:", proxyAddress);
        console2.log("Version:", counter.version());
    }

    function upgrade() external returns (address newImplemenationAddress) {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address proxyAddress = vm.envAddress("PROXY_ADDRESS");

        vm.startBroadcast(privateKey);

        CounterV2 newImpl = new CounterV2();

        bytes memory initData = abi.encodeCall(CounterV2.initializeV2, (2));

        CounterV1(proxyAddress).upgradeToAndCall(address(newImpl), initData);

        vm.stopBroadcast();

        CounterV2 counter = CounterV2(proxyAddress);
        newImplemenationAddress = address(newImpl);
        console2.log("Impl:", newImplemenationAddress);
        console2.log("Proxy:", proxyAddress);
        console2.log("Version:", counter.version());

        return address(newImpl);
    }
}
