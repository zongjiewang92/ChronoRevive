// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DepositContract {
    // 记录每个用户的存款金额
    mapping(address => uint256) public balances;
    // 记录每个用户的存款时间
    mapping(address => uint256) public depositTimes;

    // 存款事件
    event Deposit(address indexed user, uint256 amount, uint256 time);

    // 存款函数
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");

        // 更新用户存款
        balances[msg.sender] += msg.value;
        // 更新存款时间
        depositTimes[msg.sender] = block.timestamp;

        // 触发存款事件
        emit Deposit(msg.sender, msg.value, block.timestamp);
    }

    // 查询用户的存款金额
    function getBalance(address user) public view returns (uint256) {
        return balances[user];
    }

    // 查询用户的存款时间
    function getDepositTime(address user) public view returns (uint256) {
        return depositTimes[user];
    }
}
