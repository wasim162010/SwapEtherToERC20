# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```

# PREREQUISITES to run the project :
1. Create an .env file at the root level by referring to '.env-example'
2. In 'PRIVATE_KEY','INFURA_API_KEY' and 'ETHERSCAN_API_KEY', put your account private key, infura api key and etherscan API key. For etherscan API key, create an account in etherscan[it's free] and copy api key. It is required to verify the source code of the smart contract so that 'Read as proxy' and 'write as proxy' smart contract option can come in the etherscan.

# To run local hardhat node :
npx hardhat node


# To compile :
npx hardhat compile

# to deploy in localhost[local hardhat env]
npx hardhat run scripts/deploySwapContract.js --network localhost

# to deploy in testnet
npx hardhat run scripts/deploySwapContract.js --network sepolia 


# to upgrade the contract
Suppose you want to upgrade the smart contract to the v2, say 'EthertoERC20Swapv2', please refer the 'deploySwapContractv2.js' and provide necessary inputs in it and execute : npx hardhat run scripts/deploySwapContractv2.js --network sepolia 


