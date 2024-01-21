// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const fs = require('fs/promises');

async function main() {
  const VirtualREContract= await hre.ethers.getContractFactory("VirtualRealEstate");

  console.log(`Awaiting Deployment`);

  const ReContract = await VirtualREContract.deploy({gas:2000});

  console.log(`Contract Deployed`);

  console.log(`${ReContract.address}`);

  writeContractDetails(VirtualREContract, 'VRE.json')

}




const writeContractDetails = async (contract, filename = "") => {
  const data = {
    contract: {
      address: contract.address,
      abi: contract.interface.format()
    },
  };

  const content = JSON.stringify(data, null, 2);

  try {
    await fs.writeFile(filename, content, { encoding: "utf-8" });
    console.log(`Contract details written to ${filename}`);
  } catch (error) {
    console.error(`Error writing contract details: ${error.message}`);
  }
};

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});


