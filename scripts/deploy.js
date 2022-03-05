const hre = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());

  const NFTDescriptor = await ethers.getContractFactory("NFTDescriptor");
  const nftDescriptorLib = await NFTDescriptor.deploy();
  await nftDescriptorLib.deployed();

  console.log("Library address: ", nftDescriptorLib.address);

  const BondNFT = await ethers.getContractFactory("GTONBondNFT", {
    libraries: {
      NFTDescriptor: nftDescriptorLib.address,
    },
  });
  const bondNFT = await BondNFT.deploy();
  await bondNFT.deployed();

  console.log("Token address: ", bondNFT.address);

  await hre.run("verify:verify", {
    address: bondNFT.address,
    network: polygonMumbai,
    constructorArguments: [
    ],
    libraries: {
      NFTDescriptor: nftDescriptorLib.address,
    }
  });
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
