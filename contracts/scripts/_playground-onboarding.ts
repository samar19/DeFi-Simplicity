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

  const managerContract = await connectToSugarcaneContract(
    "SugarcaneManagerPrimaryBase",
    "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512"
  );

  await managerContract.onboardAccount(
    // address signerAddress_,
    signerAddress_
  );

  const hasOnboarded = await managerContract.hasOnboarded(signerAddress_);
  console.log("\n\n-=-=- Has Onboarded");
  console.log(hasOnboarded);

  const onboardedAddresses = await managerContract.onboardedAddresses();
  console.log("\n\n-=-=- Onboarded Addresses");
  console.log(onboardedAddresses);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
