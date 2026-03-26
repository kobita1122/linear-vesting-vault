const hre = require("hardhat");

async function main() {
  const TOKEN_ADDR = "0x..."; // Project Token
  const BENEFICIARY = "0x..."; // Employee Address
  const START = Math.floor(Date.now() / 1000);
  const CLIFF = 31536000; // 1 Year in seconds
  const DURATION = 126144000; // 4 Years in seconds

  const VestingWallet = await hre.ethers.getContractFactory("VestingWallet");
  const vault = await VestingWallet.deploy(TOKEN_ADDR, BENEFICIARY, START, CLIFF, DURATION);

  await vault.waitForDeployment();
  console.log(`Vesting Vault deployed to: ${await vault.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
