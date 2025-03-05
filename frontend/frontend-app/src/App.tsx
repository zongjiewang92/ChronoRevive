import React, { useState } from 'react';
import { depositFunds, getBalance } from './contracts/DepositContract';

function App() {
    const [amount, setAmount] = useState<string>("");
    const [balance, setBalance] = useState<string>("");

    const handleDeposit = async () => {
        await depositFunds(amount);
        const userBalance = await getBalance(window.ethereum.selectedAddress);
        setBalance(userBalance || "0");
    };

    return (
        <div className="App">
            <h1>Deposit Funds</h1>
            <input
                type="text"
                placeholder="Amount in ETH"
                value={amount}
                onChange={(e) => setAmount(e.target.value)}
            />
            <button onClick={handleDeposit}>Deposit</button>

            <h2>Your Balance: {balance} ETH</h2>
        </div>
    );
}

export default App;
