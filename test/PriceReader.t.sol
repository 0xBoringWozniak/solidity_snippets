// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {PriceReader} from "src/PriceReader.sol";

contract PriceReaderTest is Test {
    PriceReader public priceReader;

    function setUp() public {
        priceReader = new PriceReader();
    }

    function testGetPrice() public {
        int256 price = priceReader.getPrice();
        assert(price > 0);
        console.log(price);
    }
}
