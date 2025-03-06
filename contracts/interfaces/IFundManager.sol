// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IFundManager {
    function deposit() external payable;
    function withdraw(uint256 amount) external;
    function invest(uint256 amount) external;
    function calculateRevivalFund() external view returns (uint256);
    function withdrawRevivalFund() external;
}
