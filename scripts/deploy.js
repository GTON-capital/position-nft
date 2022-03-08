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
  const name = "GTON NFT";
  const symbol = "gtonNFT";
  const bondTokenSymbol = "GTON";
  const bondNFT = await BondNFT.deploy(name, symbol, bondTokenSymbol);
  await bondNFT.deployed();

  console.log("Token address: ", bondNFT.address);

  // The delay is necessary to avoid "the address does not have bytecode" error
  await delay(50000);

  await hre.run("verify:verify", {
    address: bondNFT.address,
    network: "polygonMumbai",
    constructorArguments: [
      name,
      symbol,
      bondTokenSymbol
    ],
    libraries: {
      NFTDescriptor: nftDescriptorLib.address,
    }
  });
}

const delay = ms => new Promise(res => setTimeout(res, ms));

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
