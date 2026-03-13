// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Counter is Ownable {
    uint256 private number;

    constructor(uint256 _number) Ownable(msg.sender) {
        number = _number;
    }

    function getNumber() public view returns (uint256) {
        return number;
    }

    function increment() public {
        number++;
    }

    function decrement() public onlyOwner {
        number--;
    }
}
