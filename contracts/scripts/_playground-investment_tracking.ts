import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { ethers } from "hardhat";

import {
  badgeIds,
  badgeListing,
  BadgeNames,
  chainIds,
  connectToSugarcaneContract,
  protocolIds,
} from "./utils";

async function main() {
  // Addresses
  let deployer: SignerWithAddress;
  let addr1: SignerWithAddress;
  let addr2: SignerWithAddress;
  let addrs: SignerWithAddress[];
  [deployer, addr1, addr2, ...addrs] = await ethers.getSigners();

  const signerAddress_ = addr1.address;

  // // // // // // // // // //
  // Record an investment
  // // // // // // // // // //

  const baseManagerContract = await connectToSugarcaneContract(
    "SugarcaneManagerPrimaryBase",
    "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512"
  );

  await baseManagerContract.recordInvestment(
    // address signerAddress_,
    signerAddress_,
    // uint256 chainId_,
    chainIds.baseGoerli,
    // uint256 protocolId_,
    protocolIds.AAVE,
    // uint256 initialAmountUsd_
    250
  );

  // // // // // // // // // //
  // Read all the investments
  // // // // // // // // // //
  const investmentRegistryContract = await connectToSugarcaneContract(
    "SugarcaneInvestmentRegistry",
    "0xa513E6E4b8f2a923D98304ec87F64353C4D5C853"
  );

  const accountInvestments = await investmentRegistryContract.investments(
    // address signerAddress_
    signerAddress_
  );

  console.log("\n\n-=-=- Account Investment Ids:");
  console.log(accountInvestments);

  // // // // // // // // // //
  // Read the investment details
  // // // // // // // // // //
  const investmentDetails = await investmentRegistryContract.investmentDetails(
    // uint256 investmentId_
    accountInvestments[0]
  );

  console.log("\n\n-=-=- Investment Details:");
  console.log(investmentDetails);

  // // // // // // // // // //
  // Read the badges
  // // // // // // // // // //
  const badgeContract = await connectToSugarcaneContract(
    "SugarcaneBadge",
    "0x610178dA211FEF7D417bC0e6FeD39F05609AD788"
  );

  // Ask for the balance of all the badges
  const badges = await badgeContract.balanceOfBatch(
    // address[] memory accounts,
    badgeListing.map(() => signerAddress_),
    // uint256[] memory ids
    badgeListing.map((badge) => badgeIds[badge])
  );

  // Map the badge amount to their names
  const badgeBalanceMap: Record<string, string> = {};

  badgeListing.forEach((badge, index) => {
    badgeBalanceMap[badge] = badges[index].toNumber();
  });

  console.log("\n\n-=-=- Badges:");
  console.log(badgeBalanceMap);

  // // // // // // // // // //
  // Bage details
  // // // // // // // // // //
  const badgeDetails = await badgeContract.uri(
    badgeIds[BadgeNames.FRIEND_REFER]
  );

  console.log("\n\n-=-=- Badge Details - badgeIds[BadgeNames.FRIEND_REFER] ");
  console.log(badgeDetails);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
