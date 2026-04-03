// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console2} from "forge-std/Test.sol";
import {AMMAdapter} from "../src/AMMAdapter.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract AMMAdapterTest is Test {
    address internal constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    address internal constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    AMMAdapter internal adapter;
    address internal user = address(0xBEEF);

    function setUp() public {
        adapter = new AMMAdapter(UNISWAP_V2_ROUTER);
    }

    function test_Swap_USDC_To_WETH_And_Check_Reserves() public {
        (
            address pairBefore,
            address token0Before,
            address token1Before,
            uint112 reserve0Before,
            uint112 reserve1Before,
        ) = adapter.getPairReserves(USDC, WETH);

        console2.log("Pair:");
        console2.log(pairBefore);
        console2.log("token0:");
        console2.log(token0Before);
        console2.log("token1:");
        console2.log(token1Before);
        console2.log("reserve0 before:");
        console2.logUint(uint256(reserve0Before));
        console2.log("reserve1 before:");
        console2.logUint(uint256(reserve1Before));

        assertTrue(pairBefore != address(0), "pair not found");

        uint256 amountIn = 1_000e6; // 1000 USDC

        deal(USDC, user, amountIn);

        uint256 userUsdcBefore = IERC20(USDC).balanceOf(user);
        uint256 userWethBefore = IERC20(WETH).balanceOf(user);

        vm.startPrank(user);
        IERC20(USDC).approve(address(adapter), amountIn);
        uint256 amountOut = adapter.swapExactInput(USDC, WETH, amountIn, 0);
        vm.stopPrank();

        uint256 userUsdcAfter = IERC20(USDC).balanceOf(user);
        uint256 userWethAfter = IERC20(WETH).balanceOf(user);

        (address pairAfter,,, uint112 reserve0After, uint112 reserve1After,) = adapter.getPairReserves(USDC, WETH);

        console2.log("amountOut:");
        console2.logUint(amountOut);
        console2.log("user USDC before:");
        console2.logUint(userUsdcBefore);
        console2.log("user USDC after:");
        console2.logUint(userUsdcAfter);
        console2.log("user WETH before:");
        console2.logUint(userWethBefore);
        console2.log("user WETH after:");
        console2.logUint(userWethAfter);
        console2.log("reserve0 after:");
        console2.logUint(uint256(reserve0After));
        console2.log("reserve1 after:");
        console2.logUint(uint256(reserve1After));

        assertEq(pairBefore, pairAfter, "pair changed unexpectedly");
        assertEq(userUsdcAfter, 0, "user USDC should be spent");
        assertGt(userWethAfter, userWethBefore, "user should receive WETH");
        assertGt(amountOut, 0, "amountOut should be positive");

        bool reservesChanged = reserve0After != reserve0Before || reserve1After != reserve1Before;
        assertTrue(reservesChanged, "pair reserves should change");
    }
}
