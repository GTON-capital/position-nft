const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PositionNFT", function () {
  it("Should return the new greeting once it's changed", async function () {
    const NFTDescriptor = await ethers.getContractFactory("NFTDescriptor");
    const nftDescriptorLib = await NFTDescriptor.deploy();
    await nftDescriptorLib.deployed();

    const Greeter = await ethers.getContractFactory("PositionNFT", {
      libraries: {
        NFTDescriptor: nftDescriptorLib.address,
      },
    });
  });
});
