// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console2} from "forge-std/Test.sol";
import {PriceReader} from "../src/PriceReader.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract PriceReaderTest is Test {
    PriceReader internal priceReader;
    AggregatorV3Interface internal dataFeed;

    function setUp() public {
        priceReader = new PriceReader();

        // Same feed address as in PriceReader constructor
        dataFeed = AggregatorV3Interface(0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c);
    }

    function test_GetPrice() public {
        int256 price = priceReader.getPrice();
        string memory feedName = dataFeed.description();

        console2.log("Feed name:");
        console2.log(feedName);

        console2.log("Price:");
        console2.logInt(price);

        assertGt(price, 0);
    }
}
