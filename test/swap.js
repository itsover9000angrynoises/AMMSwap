const { expect } = require("chai");
const hre = require("hardhat");

describe("swap contract", function () {
  it("Deployment & Swap eth to DAI via uniswap", async function () {
    const [owner] = await ethers.getSigners();
    const Contract = await hre.ethers.getContractFactory("swap");
    const uniswapV2RouterAddress = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";
    const daiTokenAddress = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
    const swapContract = await Contract.deploy(uniswapV2RouterAddress, daiTokenAddress);
    await swapContract.deployed();
    expect(await swapContract.swapWithETH({ value: ethers.utils.parseEther("1.0") })).to.exist;
  });
});