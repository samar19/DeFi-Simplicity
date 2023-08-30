import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { Contract, ContractFactory } from "ethers";
import { keccak256, toUtf8Bytes } from "ethers/lib/utils";
import { ethers, upgrades } from "hardhat";

export interface IContractSet {
  [contractName: string]: Contract;
}

export interface IBridgeAddresses {
  gatewayAddress: string;
  gasServiceAddress: string;
}

export const chainIds = {
  arbitrumGoerli: 421613,
  baseGoerli: 84531,
  goerli: 5,
  mumbai: 80001,
};

// Badge Ids

export enum BadgeNames {
  FRIEND_REFER = "FRIEND_REFER",
  LIQUIDITY_PROVIDER = "LIQUIDITY_PROVIDER",
  STAKER = "STAKER",
  LENDER = "LENDER",
  INVEST_ONE = "INVEST_ONE",
  INVEST_FIVE = "INVEST_FIVE",
  INVEST_TEN = "INVEST_TEN",
}

export const badgeListing: BadgeNames[] = [
  BadgeNames.FRIEND_REFER,
  BadgeNames.LIQUIDITY_PROVIDER,
  BadgeNames.STAKER,
  BadgeNames.LENDER,
  BadgeNames.INVEST_ONE,
  BadgeNames.INVEST_FIVE,
  BadgeNames.INVEST_TEN,
];

const constructBadgeId = (badgeId: string) =>
  keccak256(toUtf8Bytes(`badge.${badgeId}`)).toLowerCase();

let _badgeIds: Record<BadgeNames | string, string> = {};

badgeListing.forEach((badgeId: BadgeNames) => {
  _badgeIds[badgeId] = constructBadgeId(badgeId);
});

export const badgeIds = _badgeIds;

export const badgeImageCIDs = {
  LIQUIDITY_PROVIDER: "QmQU19gBFVZcwEUmg3AXYPkcX6YXu3goq1KuuWSiAaGMgD",
  STAKER: "QmYHisJxv83NjZi4f6uSYF6zakydVKJq65jhTmkWSihFKF",
  LENDER: "QmabrikTiCD3JeoQyMAS9xASC7fpAQkBnC26QXws6GdJWD",
  FRIEND_REFER: "QmZw42ok2N1n8fAycjCbXQMGfqwkNQEp9htUU89pj4BtTk",
  INVEST_ONE: "Qmc7fU4nV6PVuctqQdmmEja8DFmszkP5VibXfG4Bg8QNeV",
  INVEST_FIVE: "QmVaLm7aWKZW1dxfoUoYqPEMPkEmaKVqCC83zi5XHzeg7b",
  INVEST_TEN: "QmX3oJ24G3SctAR4TgVi7YkmBwWcWsa2aHhRsBg3uAVM9q",
};

// Protocol Ids
export const protocolIds = {
  AAVE: keccak256(toUtf8Bytes("protocol.AAVE")).toLowerCase(),
  UNISWAP: keccak256(toUtf8Bytes("protocol.UNISWAP")).toLowerCase(),
  SSV_LIQUID_STAKING: keccak256(
    toUtf8Bytes("protocol.SSV_LIQUID_STAKING")
  ).toLowerCase(),
};

export type ISetUpFunction<IContractSet> = (
  deployer: SignerWithAddress,
  onboarder: string,
  bridge: IBridgeAddresses
) => Promise<IContractSet>;

export const deploySugarcaneContract = async (
  deployer: SignerWithAddress,
  contractName: string,
  args: unknown[]
): Promise<Contract> => {
  // Set up the factory contract
  const SugarcaneContractFactory: ContractFactory =
    await ethers.getContractFactory(contractName);
  const sugarcaneContract: Contract = await upgrades.deployProxy(
    SugarcaneContractFactory,
    args,
    {
      kind: "uups",
    }
  );
  console.log(`\n[DEPLOYED] ${contractName} - `, sugarcaneContract.address);

  await unpauseContract(deployer, contractName, sugarcaneContract.address);

  return sugarcaneContract;
};

export const connectToSugarcaneContract = async (
  contractName: string,
  sugarcaneContractAddr: string
): Promise<Contract> => {
  // Connecting to an existing contract
  let SugarcaneContractFactory: ContractFactory =
    await ethers.getContractFactory(contractName);
  const sugarcaneContract: Contract = await SugarcaneContractFactory.attach(
    sugarcaneContractAddr
  );

  return sugarcaneContract;
};

export const connectToContractAt = async (
  contractName: string,
  contractAtAddr: string
): Promise<Contract> => {
  const contractAt: Contract = await ethers.getContractAt(
    contractName,
    contractAtAddr
  );

  return contractAt;
};

export const unpauseContract = async (
  deployer: SignerWithAddress,
  contractName: string,
  sugarcaneContractAddr: string
) => {
  const sugarcaneContract = await connectToSugarcaneContract(
    contractName,
    sugarcaneContractAddr
  );
  await sugarcaneContract.connect(deployer).unpause();
  console.log(`--- ${contractName}: unpaused`);
};
