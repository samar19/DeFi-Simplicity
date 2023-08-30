import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { ethers } from "hardhat";

import { connectToSecondary } from "../setup/goerli.setup";
import { chainIds, connectToSugarcaneContract } from "../utils";
import {
  mumbaiManagerContractAddress,
  randoSignerAddress_,
} from "./_addresses";

async function main() {
  let deployer: SignerWithAddress;
  let addr1: SignerWithAddress;
  let addr2: SignerWithAddress;
  let addrs: SignerWithAddress[];
  [deployer, addr1, addr2, ...addrs] = await ethers.getSigners();

  console.log("--- 1");
  const mumbaiManagerContract = await connectToSugarcaneContract(
    "SugarcaneManagerSecondary",
    mumbaiManagerContractAddress
  );

  console.log("--- 2");
  const onboardedDetailsOnMumbai = await mumbaiManagerContract.onboardDetails(
    randoSignerAddress_
  );
  console.log("\n\n-=-=- Has Onboarded on Mumbai");
  console.log(onboardedDetailsOnMumbai);

  console.log("--- 3");
  const onboardedAddressesOnGoerli =
    await mumbaiManagerContract.onboardedAddresses();
  console.log("\n\n-=-=- Onboarded Addresses on Mumbai");
  console.log(onboardedAddressesOnGoerli);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
