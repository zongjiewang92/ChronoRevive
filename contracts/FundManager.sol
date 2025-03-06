// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FundManager {
    address public owner;
    address public teamManagementAddress;
    address public userInvestmentAddress;

    mapping(address => uint256) public userBalances;
    uint256 public autoInvestBalance;
    uint256 public teamManagementBalance;
    uint256 public reserveFundBalance;
    mapping(string => uint256) public investmentStrategies;

    event Deposited(address indexed user, uint256 amount);
    event Invested(string strategy, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event BalanceUpdated(address indexed user, uint256 newBalance);
    event TeamInvested(uint256 amount);
    event UserInvested(address indexed user, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier onlyTeam() {
        require(msg.sender == teamManagementAddress, "Only team can perform this action");
        _;
    }

    modifier updateBalance() {
        _;
        emit BalanceUpdated(msg.sender, userBalances[msg.sender]);
    }

    constructor(address _teamManagementAddress, address _userInvestmentAddress) {
        require(_teamManagementAddress != address(0), "Invalid team management address");
        require(_userInvestmentAddress != address(0), "Invalid user investment address");
        owner = msg.sender;
        teamManagementAddress = _teamManagementAddress;
        userInvestmentAddress = _userInvestmentAddress;

        // Set initial investment strategies (example values)
        investmentStrategies["autoInvest"] = 70;
        investmentStrategies["teamManagement"] = 20;
        investmentStrategies["reserveFund"] = 10;
    }

    function deposit() external payable updateBalance {
        require(msg.value > 0, "Deposit amount must be greater than zero");

        uint256 autoInvestAmount = (msg.value * investmentStrategies["autoInvest"]) / 100;
        uint256 teamManagementAmount = (msg.value * investmentStrategies["teamManagement"]) / 100;
        uint256 reserveFundAmount = (msg.value * investmentStrategies["reserveFund"]) / 100;

        userBalances[msg.sender] += msg.value;
        autoInvestBalance += autoInvestAmount;
        teamManagementBalance += teamManagementAmount;
        reserveFundBalance += reserveFundAmount;

        emit Deposited(msg.sender, msg.value);
    }

    function setInvestmentStrategies(
        uint256 autoInvestPercentage,
        uint256 teamManagementPercentage,
        uint256 reserveFundPercentage
    ) external onlyOwner {
        require(
            autoInvestPercentage + teamManagementPercentage + reserveFundPercentage == 100,
            "Total percentage must equal 100"
        );
        investmentStrategies["autoInvest"] = autoInvestPercentage;
        investmentStrategies["teamManagement"] = teamManagementPercentage;
        investmentStrategies["reserveFund"] = reserveFundPercentage;
    }

    function teamInvest(uint256 amount) external onlyTeam {
        require(amount > 0, "Investment amount must be greater than zero");
        require(teamManagementBalance >= amount, "Insufficient team management balance");

        teamManagementBalance -= amount;

        // 此处添加团队投资的具体逻辑，例如与其他合约交互
        // ...

        emit TeamInvested(amount);
    }

    function userInvest() external payable {
        require(msg.value > 0, "Investment amount must be greater than zero");

        // 将用户的投资金额转移到用户投资管理地址
        (bool success, ) = userInvestmentAddress.call{value: msg.value}("");
        require(success, "Transfer to user investment address failed");

        emit UserInvested(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external updateBalance {
        require(amount > 0, "Withdrawal amount must be greater than zero");
        require(userBalances[msg.sender] >= amount, "Insufficient balance");

        userBalances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);

        emit Withdrawn(msg.sender, amount);
    }

    function getBalance() external view returns (uint256) {
        return userBalances[msg.sender];
    }

    // 回调函数示例，根据需要实现
    function uniswapV3MintCallback(uint256 amount0, uint256 amount1, bytes calldata data) external {
        // 解析回调数据
        (address token0, address token1, address payer) = abi.decode(data, (address, address, address));
        // 执行必要的操作，例如从payer转移token到msg.sender
        // IERC20(token0).transferFrom(payer, msg.sender, amount0);
        // IERC20(token1).transferFrom(payer, msg.sender, amount1);
    }

    function uniswapV3SwapCallback(int256 amount0Delta, int256 amount1Delta, bytes calldata data) external {
        // 解析回调数据
        (address token0, address token1, address payer) = abi.decode(data, (address, address, address));
        // 执行必要的操作，例如从payer转移token到msg.sender
        // if (amount0Delta > 0) {
        //     IERC20(token0).transferFrom(payer, msg.sender, uint256(amount0Delta));
        // }
        // if (amount1Delta > 0) {
        //     IERC20(token1).transferFrom(payer, msg.sender, uint256(amount1Delta));
        // }
    }
}
