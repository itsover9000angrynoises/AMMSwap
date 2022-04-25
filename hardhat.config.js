require("@nomiclabs/hardhat-waffle");

const CHAIN_IDS = {
  hardhat: 31337, // chain ID for hardhat testing
};
module.exports = {
  solidity: "0.6.12",
  networks: {
    hardhat: {
      chainId: CHAIN_IDS.hardhat,
      forking: {
        url: "ADD_INFURA_URL_HERE", 
        blockNumber: 14652840,
      },
    },
  },
}

