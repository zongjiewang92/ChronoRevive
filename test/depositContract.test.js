const { expect } = require("chai");

describe("DepositContract", function () {
    let DepositContract;
    let depositContract;
    let owner;

    beforeEach(async function () {
        [owner] = await ethers.getSigners();
        DepositContract = await ethers.getContractFactory("DepositContract");
        depositContract = await DepositContract.deploy();
    });

    it("should allow users to deposit funds", async function () {
        await depositContract.deposit({ value: ethers.utils.parseEther("1") });
        const balance = await depositContract.getBalance(owner.address);
        expect(balance).to.equal(ethers.utils.parseEther("1"));
    });

    it("should record deposit time", async function () {
        await depositContract.deposit({ value: ethers.utils.parseEther("1") });
        const depositTime = await depositContract.getDepositTime(owner.address);
        expect(depositTime).to.be.a('number');
    });
});
