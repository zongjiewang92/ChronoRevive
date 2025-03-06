// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library FundUtils {
    function calculatePercentage(uint256 amount, uint256 percentage) internal pure returns (uint256) {
        return (amount * percentage) / 100;
    }
}
