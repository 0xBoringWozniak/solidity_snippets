// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Event {
    uint256 public count;

    // Event declaration
    // Up to 3 parameters can be indexed.
    // Indexed parameters help you filter the logs by the indexed parameter
    event Log(address indexed sender, string message);
    event AnotherLog();

    function emptyTest() public {
        count += 1;
    }

    function test() public {
        emit Log(msg.sender, "Hello World!");
        emit Log(msg.sender, "Hello EVM!");
        emit AnotherLog();
    }
}
