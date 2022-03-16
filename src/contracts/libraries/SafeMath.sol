// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SafeMath {
    // functions add r = x + y
    function add(uint256 x, uint256 y) pure internal returns (uint256) {
        uint256 r = x + y;
        require( r >= x, "SafeMAth: Addition overflow");
        return r;
    }

    function subtract(uint256 x, uint256 y) pure internal returns (uint256) {
        require(x >= y, "SafeMath: Subtraction overflow");
        return x - y;
    }

    function multipy(uint256 x, uint256 y) pure internal returns (uint256) {
        require(x != 0 && y != 0, "SafeMath: Multplication overflow");
        uint256 r = x * y;
        require(r/x == y, "SafeMath: Multplication overflow");
        return r;
    }

    function divide(uint256 x, uint256 y) pure internal returns (uint256) {
        require(x > 0 && y > 0, "SafeMath: Division error");
        return x / y;
    }

    function mod(uint256 x, uint256 y) pure internal returns (uint256) {
        require(x > 0 && y > 0, "SafeMath: Modulo by zero");
        return x % y;
    }
}