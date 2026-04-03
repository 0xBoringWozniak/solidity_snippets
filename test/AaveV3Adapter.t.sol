// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console2} from "forge-std/Test.sol";
import {AaveV3Adapter} from "../src/AaveV3Adapter.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract AaveV3AdapterTest is Test {
    // Aave V3 Pool on Ethereum mainnet
    address internal constant AAVE_POOL = 0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2;

    // Native USDC on Ethereum mainnet
    address internal constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    AaveV3Adapter internal adapter;
    address internal user = address(0xBEEF);

    function setUp() public {
        adapter = new AaveV3Adapter(AAVE_POOL);
    }

    function test_Supply_USDC_And_Check_Reserve_Update() public {
        (address aTokenBefore, uint128 liquidityIndexBefore, uint40 lastUpdateBefore) = adapter.getReserveInfo(USDC);

        console2.log("aToken before:");
        console2.log(aTokenBefore);
        console2.log("liquidityIndex before:");
        console2.logUint(uint256(liquidityIndexBefore));
        console2.log("lastUpdateTimestamp before:");
        console2.logUint(uint256(lastUpdateBefore));

        assertTrue(aTokenBefore != address(0), "aToken is zero");

        uint256 amount = 1_000e6; // 1000 USDC, 6 decimals

        deal(USDC, user, amount);

        uint256 userUsdcBefore = IERC20(USDC).balanceOf(user);
        uint256 userATokenBefore = IERC20(aTokenBefore).balanceOf(user);

        // Make sure reserve update timestamp can actually move
        vm.warp(block.timestamp + 1);

        vm.startPrank(user);
        IERC20(USDC).approve(address(adapter), amount);
        adapter.supply(USDC, amount);
        vm.stopPrank();

        uint256 userUsdcAfter = IERC20(USDC).balanceOf(user);
        uint256 userATokenAfter = IERC20(aTokenBefore).balanceOf(user);

        (address aTokenAfter, uint128 liquidityIndexAfter, uint40 lastUpdateAfter) = adapter.getReserveInfo(USDC);

        console2.log("aToken after:");
        console2.log(aTokenAfter);
        console2.log("liquidityIndex after:");
        console2.logUint(uint256(liquidityIndexAfter));
        console2.log("lastUpdateTimestamp after:");
        console2.logUint(uint256(lastUpdateAfter));

        console2.log("user USDC before:");
        console2.logUint(userUsdcBefore);
        console2.log("user USDC after:");
        console2.logUint(userUsdcAfter);

        console2.log("user aToken before:");
        console2.logUint(userATokenBefore);
        console2.log("user aToken after:");
        console2.logUint(userATokenAfter);

        assertEq(aTokenBefore, aTokenAfter, "aToken address changed unexpectedly");
        assertEq(userUsdcAfter, 0, "user USDC should be spent");
        assertGt(userATokenAfter, userATokenBefore, "user should receive aTokens");
        assertGt(uint256(lastUpdateAfter), uint256(lastUpdateBefore), "reserve timestamp should update");
        assertGe(uint256(liquidityIndexAfter), uint256(liquidityIndexBefore), "liquidity index should not decrease");
    }
}
