// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {WETH} from "../src/WETH.sol";

contract WETHScript is Script {
    // deploy script with verifying the contract on Etherscan
    // forge script script/WETH.s.sol --rpc-url $SEPLOIA_RPC
    // --broadcast --verify --etherscan-api-key $SCANNER_API_KEY
    function run() external returns (WETH weth) {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(privateKey);
        weth = new WETH();
        vm.stopBroadcast();
    }
}
