// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract CounterV1 is Initializable, UUPSUpgradeable {
    uint256 public value;
    address public upgrader;

    constructor() {
        _disableInitializers();
    }

    function initialize(uint256 initialValue, address initialUpgrader) public initializer {
        value = initialValue;
        upgrader = initialUpgrader;
    }

    function increment() external {
        value += 1;
    }

    function decrement() external {
        value -= 1;
    }

    function version() external pure virtual returns (string memory) {
        return "V1";
    }

    function _authorizeUpgrade(address) internal view override {
        require(msg.sender == upgrader, "Not authorized");
    }
}
