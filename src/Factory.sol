// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract ObjectContract {
    address public signer1;
    address public signer2;

    constructor(address _signer1, address _signer2) {
        signer1 = _signer1;
        signer2 = _signer2;
    }
}

contract ObjectFactory {
    ObjectContract[] public deployedContractsRegistry;

    function create(address signer1, address signer2) external returns (address) {
        ObjectContract newContract = new ObjectContract(signer1, signer2);
        deployedContractsRegistry.push(newContract);
        return address(newContract);
    }
}
