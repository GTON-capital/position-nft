const hre = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());

  const NFTDescriptor = await ethers.getContractFactory("NFTDescriptor");
  const nftDescriptorLib = await NFTDescriptor.deploy();
  await nftDescriptorLib.deployed();

  console.log("Library address:", nftDescriptorLib.address);

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

  console.log("Token address:", bondNFT.address);

  // The delay is necessary to avoid "the address does not have bytecode" error
  await delay(50000);

  await hre.run("verify:verify", {
    address: bondNFT.address,
    network: "ftmTestnet",
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

async function callContract() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());

  const BondNFT = await ethers.getContractFactory("GTONBondNFT", {
    libraries: {
      NFTDescriptor: "0x237fd2F520e07597f344bF29aDD82e13048E3147",
    },
  });
  const contract = await BondNFT.attach(
    "0x9E8bcf8360Da63551Af0341A67538c918ba81007" // The deployed contract address
  );

  // Now you can call functions of the contract
  const result = await contract.isAdmin("0xc7b266aafcea5c1d8e6d90339a73cca34e476492");
  console.log(result);
}

const delay = ms => new Promise(res => setTimeout(res, ms));

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
