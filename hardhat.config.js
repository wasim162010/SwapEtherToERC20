require("@nomicfoundation/hardhat-toolbox");
require("@openzeppelin/hardhat-upgrades");
require("@nomiclabs/hardhat-etherscan");
require("dotenv").config();

console.log("process.env.INFURA_API_KEY ", process.env.INFURA_API_KEY)
console.log("process.env.PRIVATE_KEY ", process.env.PRIVATE_KEY)
console.log("process.env.ETHERSCAN_API_KEY ", process.env.ETHERSCAN_API_KEY)
const privateKey = process.env.PRIVATE_KEY
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
 // solidity: "0.8.18",
 solidity : {
  version: "0.8.18",
  settings: {
    optimizer: {
      enabled: true,
      runs: 1000,
    }
  }
 },
 
  networks: {
    local: {
      url: 'http://localhost:8545'
    },
    sepolia: {
      url: `https://sepolia.infura.io/v3/${process.env.INFURA_API_KEY}`, 
      accounts: [privateKey],
    },
    mainnet : {
      url : `https://mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts: [privateKey]
    },
    hardhat: {
      allowUnlimitedContractSize: true
      }
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY, 
  },
};


