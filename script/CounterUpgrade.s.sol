// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {CounterV1} from "src/CounterV1.sol";
import {CounterV2} from "src/CounterV2.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract CounterUpgradeScript is Script {
    address proxy = 0xf7Cd8fa9b94DB2Aa972023b379c7f72c65E4De9D;
    address counterV2 = 0x196dBCBb54b8ec4958c959D8949EBFE87aC2Aaaf;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        CounterV2 newImlp = new CounterV2();
        CounterV2 oldImpl = CounterV2(proxy);
        oldImpl.upgradeToAndCall(address(newImlp), "");
        vm.stopBroadcast();
    }
}
