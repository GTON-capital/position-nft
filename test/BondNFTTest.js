const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("BondNFT", function () {
  it("Should return the new greeting once it's changed", async function () {
    const NFTDescriptor = await ethers.getContractFactory("NFTDescriptor");
    const nftDescriptorLib = await NFTDescriptor.deploy();
    await nftDescriptorLib.deployed();

    const DateTimeLibrary = await ethers.getContractFactory("NFTDescriptor");
    const dateTimeLibrary = await DateTimeLibrary.deploy();
    await dateTimeLibrary.deployed();

    const BondNFT = await ethers.getContractFactory("GTONBondNFT", {
      libraries: {
        NFTDescriptor: nftDescriptorLib.address,
      },
    });
    const bondNFT = await BondNFT.deploy(
      "GTON NFT",
      "gtonNFT",
      "GTON",
      dateTimeLibrary.address,
    );
    await bondNFT.deployed();
  });
});
