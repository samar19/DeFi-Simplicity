import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { ethers } from "hardhat";

import { connectToSecondary } from "../setup/goerli.setup";
import {
  chainIds,
  connectToContractAt,
  connectToSugarcaneContract,
} from "../utils";
import {
  goerliBridge,
  goerliManagerAddress,
  mumbaiExecuteOnboardAddress,
  randoSignerAddress_,
  refunderAddress,
} from "./_addresses";

async function main() {
  let deployer: SignerWithAddress;
  let addr1: SignerWithAddress;
  let addr2: SignerWithAddress;
  let addrs: SignerWithAddress[];
  [deployer, addr1, addr2, ...addrs] = await ethers.getSigners();

  // Pay Gas
  const axelarGasStation = await connectToContractAt(
    "IAxelarGasService",
    goerliBridge.gasServiceAddress
  );
  const abiCoder = new ethers.utils.AbiCoder();
  axelarGasStation.payNativeGasForContractCall(
    // address sender,
    goerliManagerAddress,
    // string calldata destinationChain,
    "Polygon",
    // string calldata destinationAddress,
    mumbaiExecuteOnboardAddress,
    // bytes calldata payload,
    abiCoder.encode(
      ["uint256", "address"],
      [
        // nonce_,
        0,
        // signerAddress_
        randoSignerAddress_,
      ]
    ),
    // address refundAddress
    refunderAddress,
    // Options
    { value: ethers.utils.parseEther("1.0") }
  );

  console.log("--- 1");
  const goerliManagerContract = await connectToSugarcaneContract(
    "SugarcaneManagerPrimary",
    goerliManagerAddress
  );
  const mumbaiManagerContract = await connectToSugarcaneContract(
    "SugarcaneManagerSecondary",
    mumbaiExecuteOnboardAddress
  );

  console.log("\n\n-=-=- Onboarder");
  console.log(await goerliManagerContract.onboarder());

  const onboarder = addr2;
  console.log("\n\n-=-=- Input Onboarder");
  console.log(await onboarder.address);

  console.log("--- 2");

  await goerliManagerContract.connect(onboarder).onboardAccount(
    // address signerAddress_,
    randoSignerAddress_
  );

  console.log("--- 3");
  const hasOnboardedOnGoerli = await goerliManagerContract.hasOnboarded(
    randoSignerAddress_
  );
  console.log("\n\n-=-=- Has Onboarded on Goerli");
  console.log(hasOnboardedOnGoerli);

  console.log("--- 4");
  const onboardedAddressesOnGoerli =
    await goerliManagerContract.onboardedAddresses();
  console.log("\n\n-=-=- Onboarded Addresses on Goerli");
  console.log(onboardedAddressesOnGoerli);

  console.log("--- 5");
  const onboardAddressDetailsOnGoerli =
    await goerliManagerContract.onboardDetails(randoSignerAddress_);
  console.log("\n\n-=-=- Address Details on Goerli");
  console.log(onboardAddressDetailsOnGoerli);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
