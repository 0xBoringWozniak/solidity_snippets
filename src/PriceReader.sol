// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract PriceReader {
    AggregatorV3Interface internal dataFeed;

    constructor() {
        dataFeed = AggregatorV3Interface(0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612);
    }

    function getPrice() public view returns (int256) {
        (, int256 answer,,,) = dataFeed.latestRoundData();
        return answer;
    }
}
