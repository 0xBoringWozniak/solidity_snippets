// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract RBACContract is AccessControl {
    error FeeDeltaTooMuch();

    bytes32 public constant OPERATOR = keccak256("OPERATOR_ROLE");

    int8 fee;
    int8 public constant MAX_FEE_DELTA = 100;

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function setFee(int8 newFee) public onlyRole(DEFAULT_ADMIN_ROLE) {
        fee = newFee;
    }

    function changeFee(int8 delta, bool isIncrease) public onlyRole(OPERATOR) {
        if (delta > MAX_FEE_DELTA) {
            revert FeeDeltaTooMuch();
        }
        if (isIncrease) {
            fee += delta;
        } else {
            fee -= delta;
        }
    }
}
