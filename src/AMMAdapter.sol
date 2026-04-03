// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IAMMRouter {
    function factory() external pure returns (address);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
}

interface IAMMFactory {
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}

interface IAMMPair {
    function token0() external view returns (address);
    function token1() external view returns (address);

    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}

contract AMMAdapter {
    IAMMRouter public immutable router;
    IAMMFactory public immutable factory;

    constructor(address routerAddress) {
        router = IAMMRouter(routerAddress);
        factory = IAMMFactory(IAMMRouter(routerAddress).factory());
    }

    function getPair(address tokenIn, address tokenOut) public view returns (address) {
        return factory.getPair(tokenIn, tokenOut);
    }

    function getPairReserves(address tokenA, address tokenB)
        external
        view
        returns (
            address pair,
            address token0,
            address token1,
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        )
    {
        pair = factory.getPair(tokenA, tokenB);
        require(pair != address(0), "pair not found");

        IAMMPair p = IAMMPair(pair);
        token0 = p.token0();
        token1 = p.token1();
        (reserve0, reserve1, blockTimestampLast) = p.getReserves();
    }

    function swapExactInput(address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOutMin)
        external
        returns (uint256 amountOut)
    {
        require(amountIn > 0, "amountIn = 0");

        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        IERC20(tokenIn).approve(address(router), amountIn);

        address[] memory path = new address[](2);
        path[0] = tokenIn;
        path[1] = tokenOut;

        uint256[] memory amounts =
            router.swapExactTokensForTokens(amountIn, amountOutMin, path, msg.sender, block.timestamp + 1 hours);

        amountOut = amounts[amounts.length - 1];
    }
}
