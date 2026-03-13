// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WETH is ERC20 {
    error ZeroAmount();
    error ETHTransferFailed();

    event Mint(address indexed account, uint256 amount);
    event Burn(address indexed account, uint256 amount);

    constructor() ERC20("Wrapped ETH", "WETH") {}

    function mint() external payable {
        if (msg.value == 0) revert ZeroAmount();

        _mint(msg.sender, msg.value);
        emit Mint(msg.sender, msg.value);
    }

    function burn(uint256 amount) external {
        if (amount == 0) revert ZeroAmount();

        _burn(msg.sender, amount);
        (bool ok,) = payable(msg.sender).call{value: amount}("");
        if (!ok) revert ETHTransferFailed();

        emit Burn(msg.sender, amount);
    }

    function getReserve(address account) external view returns (uint256) {
        return balanceOf(account);
    }

    receive() external payable {
        if (msg.value == 0) revert ZeroAmount();

        _mint(msg.sender, msg.value);
        emit Mint(msg.sender, msg.value);
    }
}
