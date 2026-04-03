// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {IPool} from "@aave-v3-core/contracts/interfaces/IPool.sol";
import {DataTypes} from "@aave-v3-core/contracts/protocol/libraries/types/DataTypes.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract AaveV3Adapter {
    IPool public immutable pool;

    constructor(address poolAddress) {
        pool = IPool(poolAddress);
    }

    function getReserveInfo(address asset)
        external
        view
        returns (address aToken, uint128 liquidityIndex, uint40 lastUpdateTimestamp)
    {
        DataTypes.ReserveData memory reserve = pool.getReserveData(asset);
        return (reserve.aTokenAddress, reserve.liquidityIndex, reserve.lastUpdateTimestamp);
    }

    function supply(address asset, uint256 amount) external {
        require(amount > 0, "amount = 0");

        IERC20(asset).transferFrom(msg.sender, address(this), amount);
        IERC20(asset).approve(address(pool), amount);

        pool.supply(asset, amount, msg.sender, 0);
    }
}
