// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract KeyContract {
    uint256 public value = 42;
    string public contractKey;

    constructor(string memory _value) {
        contractKey = _value;
    }
}

contract Registry {
    mapping(KeyContract => uint256) public balances;

    function setBalance(KeyContract _contract, uint256 _amount) public {
        balances[_contract] = _amount;
    }

    function getBalance(KeyContract _contract) public view returns (uint256) {
        return balances[_contract];
    }
}
