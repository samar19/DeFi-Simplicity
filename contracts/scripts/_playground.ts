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
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
