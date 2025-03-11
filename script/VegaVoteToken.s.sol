// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {VegaVoteToken} from "src/VegaVoteToken.sol";

contract CounterScript is Script {
    VegaVoteToken public token;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        token = new VegaVoteToken("VegaVoteToken", "VegaVoteToken");

        vm.stopBroadcast();
    }
}
