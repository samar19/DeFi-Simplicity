import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { ethers } from "hardhat";

import { IMumbaiContracts, setUp as setUpMumbai } from "../setup/mumbai.setup";
import { badgeIds, IBridgeAddresses, protocolIds } from "../utils";
import { mumbaiBridge } from "./_addresses";

async function main() {
  let deployer: SignerWithAddress;
  let addr1: SignerWithAddress;
  let addr2: SignerWithAddress;
  let addrs: SignerWithAddress[];
  [deployer, addr1, addr2, ...addrs] = await ethers.getSigners();

  console.log("\n\n[ID] Badge Ids");
  console.log(badgeIds);

  console.log("\n\n[ID] Protocol Ids");
  console.log(protocolIds);

  // Set up Mumbai
  const mumbaiContracts: IMumbaiContracts = await setUpMumbai(
    // deployer: SignerWithAddress,
    deployer,
    // onboarder: string, -- DOES NOT MATTER
    "",
    // bridge: IBridgeAddresses
    mumbaiBridge
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
