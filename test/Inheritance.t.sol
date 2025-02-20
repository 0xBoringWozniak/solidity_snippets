// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import {D} from "src/Inheritance.sol";

// Try:
// - Call D.foo and check the transaction logs.
//   Although D inherits A, B and C, it only called C and then A.
// - Call D.bar and check the transaction logs
//   D called C, then B, and finally A.
//   Although super was called twice (by B and C) it only called A once.
contract InheritanceTest is Test {
    D public d;

    function setUp() public {
        d = new D();
    }

    function testFoo() public {
        d.foo();
    }

    function testBar() public {
        d.bar();
    }
}
