require("@nomiclabs/hardhat-waffle");
// import('hardhat/config').HardhatUserConfig
// require('dotenv').config({path:__dirname+'/.env'})
const path = require('path')
require('dotenv').config({ path: path.resolve(__dirname, '/.env') })

const { PRIVATEKEY } = process.env;

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  defaultNetwork: "mumbai",
  networks: {
    hardhat: {
    },
    mumbai: {
      networkId: 80001,
      url: "https://rpc-mumbai.matic.today",
      accounts: [PRIVATEKEY]
    }
  },
  solidity: {
    version: "0.8.22",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 80000
  }
};
