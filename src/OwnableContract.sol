// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract OwnableDataContract is Ownable {
    uint256 public importantNumber;

    constructor() Ownable(msg.sender) {}

    function updateImportantNumber(uint256 newImportantNumber) external onlyOwner {
        importantNumber = newImportantNumber;
    }

    function incrementImportantNumber() external {
        importantNumber += 1;
    }
}
