// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Variables {
    // State variables are stored on the blockchain.
    string public text = "Hello";
    uint256 private num = 123;

    // Constants are computed at compile time and included in the bytecode.
    address public OWNER = 0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc;

    // Immutable variables can only be set once.
    address public immutable myAddr;
    uint256 public immutable magicNumber;

    constructor(uint256 _myUint) {
        myAddr = msg.sender;
        magicNumber = _myUint;
    }

    function getTimestamp() public view returns (uint256) {
        return block.timestamp;
    }

    function transferOwnership(address _newOwner) public {
        OWNER = _newOwner;
    }
}
