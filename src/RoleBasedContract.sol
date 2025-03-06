// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract RoleBasedContract is AccessControl {
    uint256 entryFee;
    bytes32 public constant OPERATOR = keccak256("OPERATOR_ROLE");

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function adminFunction(uint256 newEntryFee) public onlyRole(DEFAULT_ADMIN_ROLE) {
        entryFee = newEntryFee;
    }
}
