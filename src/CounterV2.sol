// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {CounterV1} from "../src/CounterV1.sol";

contract CounterV2 is CounterV1 {
    uint256 public step; // slot 2

    function initializeV2(uint256 inititalStep) external reinitializer(2) {
        step = inititalStep;
    }

    function incrementByStep() external {
        value += step;
    }

    function decrementByStep() external {
        value -= step;
    }

    function version() external pure override returns (string memory) {
        return "V2";
    }
}
