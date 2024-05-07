const { ethers, upgrades } = require("hardhat");


async function main() {
 
 let chainLinkAggregator ='0x694AA1769357215DE4FAC081bf1f309aDC325306'

 console.log("******** Deploying AtomicSwapEtherToERC20... ")

 const atomicSwap = await ethers.getContractFactory("EthertoERC20Swap");
 const atomicSwapContract = await upgrades.deployProxy(atomicSwap, ['0x694AA1769357215DE4FAC081bf1f309aDC325306'], {
   initializer: "initialize",
 });
 await atomicSwapContract.deployed();

 console.log("Swap contract proxy deployed to:", atomicSwapContract.address);
 console.log("Swap contract implementation " ,await upgrades.erc1967.getImplementationAddress(atomicSwapContract.address));
}

main();

// const { ethers, upgrades } = require("hardhat");


// async function main() {
 
//  console.log("******** Deploying Forwarder... ")

//  const minford= '0x694AA1769357215DE4FAC081bf1f309aDC325306'
//  console.log("******** Deploying Certifi... minford ", minford)
//  const Certifi = await ethers.getContractFactory("Certifi");
//  const certifi = await upgrades.deployProxy(Certifi, [minford], {
//    initializer: "initialize",
//  });
//  await certifi.deployed();

//  console.log("Certifi proxy deployed to:", certifi.address);
//  console.log("Certifi Implementation Address" ,await upgrades.erc1967.getImplementationAddress(certifi.address));
//  console.log("inbox Admin Address" ,await upgrades.erc1967.getAdminAddress(certifi.address)) 

// }

// main();