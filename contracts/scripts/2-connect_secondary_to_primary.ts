import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { ethers } from "hardhat";

import { connectToSecondary } from "./setup/goerli.setup";
import { chainIds } from "./utils";

async function main() {
  let deployer: SignerWithAddress;
  let addr1: SignerWithAddress;
  let addr2: SignerWithAddress;
  let addrs: SignerWithAddress[];
  [deployer, addr1, addr2, ...addrs] = await ethers.getSigners();

  const goerliManagerAddress = "0x000000";
  const mumbaiExecuteOnboardAddress = "0x000000";

  // Set up mumbai connected to
  await connectToSecondary(
    // primaryAddress: string,
    goerliManagerAddress,
    // chainId: string,
    chainIds.mumbai,
    // secondaryAddress: string
    mumbaiExecuteOnboardAddress
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
