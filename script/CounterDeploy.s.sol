// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {CounterV1} from "src/CounterV1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract CounterDeployScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        CounterV1 counterV1 = new CounterV1();
        ERC1967Proxy proxy = new ERC1967Proxy(address(counterV1), "");
        console.logAddress(address(counterV1));
        console.logAddress(address(proxy));
        vm.stopBroadcast();
    }
}
