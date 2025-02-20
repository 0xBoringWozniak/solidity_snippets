// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {KeyContract, Registry} from "src/ContractMapping.sol";

contract CounterTest is Test {
    Registry public registry;
    KeyContract public keyContract;

    function setUp() public {
        registry = new Registry();
        keyContract = new KeyContract("key1");
    }

    function testIncrement() public {
        registry.setBalance(keyContract, 100);
        uint256 balance = registry.getBalance(keyContract);
        console.log("Balance: %d", balance);
        console.logAddress(address(keyContract));
        assertEq(balance, 100);
    }
}
