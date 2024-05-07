const { ethers, upgrades } = require("hardhat");

const PROXY = ""

async function main() {
 
 //Suppose you want to upgrade the smart contract to the v2,
  console.log("******** Upgrading EthertoERC20Swap v2... ")
  // const swapContractv2 = await ethers.getContractFactory("EthertoERC20Swapv2");
  // const v2cont =  await upgrades.upgradeProxy(PROXY, swapContractv2);
  // console.log("Swap contract upgraded to:", v2cont.address);

}

main();