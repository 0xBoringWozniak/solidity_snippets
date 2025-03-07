// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {Product, ProductFactory} from "src/Factory.sol";

contract ProductFactoryTest is Test {
    ProductFactory pfactory;

    function setUp() public {
        pfactory = new ProductFactory();
    }

    function test_CreateOne() public {
        pfactory.createProduct(100, 1, "apple");
    }

    function test_CreateMultiple() public {
        pfactory.createProduct(200, 200, "banana");
        pfactory.createProduct(100, 100, "strawberry");
    }
}
