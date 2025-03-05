
import React, { useState } from "react";
import { CssBaseline, Box, Container, Button, TextField, Typography, AppBar, Toolbar, ThemeProvider, createTheme } from "@mui/material";
import { ethers } from "ethers";

const theme = createTheme({
  palette: {
    mode: "dark", // 设置为暗黑模式
  },
});
const App: React.FC = () => {
  const [balance, setBalance] = useState(0);
  const [depositAmount, setDepositAmount] = useState(0);
  const [userAccount, setUserAccount] = useState("");

  const handleDeposit = async () => {
    if (!depositAmount) {
      alert("请输入存款金额");
      return;
    }

    // 存款操作逻辑，假设你已经连接到 MetaMask 钱包
    // 此处为简化版代码，实际需要通过合约调用存入金额
    const provider = new ethers.BrowserProvider(window.ethereum as any);
    const signer = await provider.getSigner();
    const address = await signer.getAddress();
    setUserAccount(address);

    // 更新余额（这部分你可以通过调用智能合约来获取）
    setBalance(balance + depositAmount);
  };

  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <AppBar position="sticky">
        <Toolbar>
          <Typography variant="h6">ChronoRevive Fund</Typography>
        </Toolbar>
      </AppBar>

      <Container maxWidth="sm">
        <Box
          sx={{
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
            justifyContent: "center",
            height: "100vh",
            padding: 3,
          }}
        >
          <Typography variant="h4" gutterBottom>
            Welcome to the ChronoRevive Fund
          </Typography>
          <Typography variant="h6" gutterBottom>
            Your Account: {userAccount ? userAccount : "Not connected"}
          </Typography>

          <TextField
            label="Deposit Amount (in ETH)"
            variant="outlined"
            value={depositAmount}
            onChange={(e) => setDepositAmount(parseFloat(e.target.value))}
            sx={{ marginBottom: 2 }}
            type="number"
          />

          <Button
            variant="contained"
            color="primary"
            onClick={handleDeposit}
            sx={{ marginBottom: 2 }}
          >
            Deposit
          </Button>

          <Typography variant="h6" gutterBottom>
            Your Balance: {balance} ETH
          </Typography>
        </Box>
      </Container>
    </ThemeProvider>
  );
};

export default App;
