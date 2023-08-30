import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { ethers } from "hardhat";

import {
  badgeIds,
  badgeListing,
  BadgeNames,
  chainIds,
  connectToSugarcaneContract,
  protocolIds,
} from "../utils";

async function main() {
  // Addresses
  let deployer: SignerWithAddress;
  let addr1: SignerWithAddress;
  let addr2: SignerWithAddress;
  let addrs: SignerWithAddress[];
  [deployer, addr1, addr2, ...addrs] = await ethers.getSigners();

  console.log("--- 1");
  const managerContract = await connectToSugarcaneContract(
    "SugarcaneManagerPrimaryBase",
    "0x610178dA211FEF7D417bC0e6FeD39F05609AD788"
  );

  console.log("\n\n-=-=- Onboarder");
  console.log(await managerContract.onboarder());

  const onboarder = addr2;

  console.log("--- 2");
  const signerAddress_ = "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199";
  await managerContract.connect(onboarder).onboardAccount(
    // address signerAddress_,
    signerAddress_
  );

  console.log("--- 3");
  const hasOnboarded = await managerContract.hasOnboarded(signerAddress_);
  console.log("\n\n-=-=- Has Onboarded");
  console.log(hasOnboarded);

  console.log("--- 4");
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
