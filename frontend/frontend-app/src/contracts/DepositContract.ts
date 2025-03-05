import { ethers } from 'ethers';

// 这里填入你的合约地址和 ABI
const contractAddress = 'YOUR_CONTRACT_ADDRESS';
const contractABI = [
    // 仅列出你需要的函数 ABI（这里是存款函数）
    "function deposit() public payable",
    "function getBalance(address user) public view returns (uint256)"
];

export const depositFunds = async (amount: string) => {
    if (window.ethereum) {
        const provider = new ethers.BrowserProvider(window.ethereum);
        await provider.send("eth_requestAccounts", []);
        const signer = await provider.getSigner();
        const contract = new ethers.Contract(contractAddress, contractABI, signer);

        const tx = await contract.deposit({ value: ethers.parseEther(amount) });
        await tx.wait();
        console.log("Deposit successful");
    } else {
        alert("Please install MetaMask!");
    }
};

export const getBalance = async (userAddress: string) => {
    if (window.ethereum) {
        const provider = new ethers.BrowserProvider(window.ethereum);
        const signer = await provider.getSigner();
        const contract = new ethers.Contract(contractAddress, contractABI, signer);

        const balance = await contract.getBalance(userAddress);
        console.log("User balance: ", ethers.formatEther(balance));
        return ethers.formatEther(balance);
    } else {
        alert("Please install MetaMask!");
        return null;
    }
};
