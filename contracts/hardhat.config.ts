import * as dotenv from "dotenv";

import { task } from "hardhat/config";

import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@openzeppelin/hardhat-upgrades";
import "@typechain/hardhat";

import "hardhat-contract-sizer";
import "hardhat-gas-reporter";
import "solidity-coverage";

dotenv.config();

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

const config = {
  solidity: {
    version: "0.8.4",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  networks: {
    ropsten: {
      url: process.env.ROPSTEN_URL || "",
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    hardhat: {
      chainId: 1337,
      blockGasLimit: 12e6,
      allowUnlimitedContractSize: true,
    },
    maticMumbai: {
      url: `https://polygon-mumbai.g.alchemy.com/v2/${process.env.DEV_ALCHEMY_KEY}`,
      accounts:
        process.env.PRIVATE_KEY_MUMBAI !== undefined
          ? [process.env.PRIVATE_KEY_MUMBAI]
          : [],
    },
    matic: {
      url: `https://polygon-mainnet.g.alchemy.com/v2/${process.env.PROD_ALCHEMY_KEY}`,
      accounts:
        process.env.PRIVATE_KEY_MATIC !== undefined
          ? [process.env.PRIVATE_KEY_MATIC]
          : [],
    },
    localhost: {
      gas: 12e6,
      blockGasLimit: 12e6,
      // gasPrice: 8e8,
      // gasMultiplier: 0.5,
      url: "http://0.0.0.0:8545",
    },
    baseGoerli: {
      url: `https://base-goerli.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts:
        process.env.BASE_GOERLI_RELAYER_PRIVATE_KEY !== undefined
          ? [process.env.BASE_GOERLI_RELAYER_PRIVATE_KEY]
          : [],
    },
    harborGoerli: {
      url: `${process.env.HARBOR_TEST_URL}:4000`,
      accounts:
        process.env.HARBOR_TEST_PRIVATE_KEY_1 !== undefined
          ? [
              process.env.HARBOR_TEST_PRIVATE_KEY_1,
              process.env.HARBOR_TEST_PRIVATE_KEY_2,
              process.env.HARBOR_TEST_PRIVATE_KEY_3,
            ]
          : [],
    },
    harborMumbai: {
      url: `${process.env.HARBOR_TEST_URL}:4004`,
      accounts:
        process.env.HARBOR_TEST_PRIVATE_KEY_1 !== undefined
          ? [
              process.env.HARBOR_TEST_PRIVATE_KEY_1,
              process.env.HARBOR_TEST_PRIVATE_KEY_2,
              process.env.HARBOR_TEST_PRIVATE_KEY_3,
            ]
          : [],
    },
  },
  defaultNetwork: "hardhat",
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
    gasPrice: 70,
    showTimeSpent: true,
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};

export default config;
