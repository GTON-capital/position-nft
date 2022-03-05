const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("BondNFT", function () {
  it("Should return the new greeting once it's changed", async function () {
    const NFTDescriptor = await ethers.getContractFactory("NFTDescriptor");
    const nftDescriptorLib = await NFTDescriptor.deploy();
    await nftDescriptorLib.deployed();

    const BondNFT = await ethers.getContractFactory("GTONBondNFT", {
      libraries: {
        NFTDescriptor: nftDescriptorLib.address,
      },
    });
    const bondNFT = await BondNFT.deploy("gtonNFT", "gtonNFT");
    await bondNFT.deployed();
  });
});
