import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { Contract } from "ethers";

import {
  chainIds,
  connectToSugarcaneContract,
  deploySugarcaneContract,
  IBridgeAddresses,
  IContractSet,
  ISetUpFunction,
} from "../utils";

export interface IGoerliContracts extends IContractSet {
  // sugarcaneManager: Contract;
  // sugarcaneFactory: Contract;
  // sugarcaneOnboardExecuteReceiverSecondary: Contract;
}

export const setUp: ISetUpFunction<IGoerliContracts> = async (
  deployer: SignerWithAddress,
  onboarder: string,
  bridge: IBridgeAddresses
) => {
  // Deploy Sugarcane Manager Primary
  const goerliSugarcaneManager = await deploySugarcaneContract(
    deployer,
    "SugarcaneManagerPrimary",
    [chainIds.goerli, bridge.gatewayAddress, bridge.gasServiceAddress]
  );

  // Deploy Sugarcane Factory
  const sugarcaneFactory = await deploySugarcaneContract(
    deployer,
    "SugarcaneFactory",
    [goerliSugarcaneManager.address]
  );

  // Deploy Sugarcane Onboard Execute Receiver Primary
  const sugarcaneOnboardExecuteReceiverPrimary = await deploySugarcaneContract(
    deployer,
    "SugarcaneOnboardExecuteReceiverPrimary",
    [
      // uint256 chainId_,
      chainIds.goerli,
      // address gateway_,
      bridge.gatewayAddress,
      // address primaryManagerAddress_
      goerliSugarcaneManager.address,
    ]
  );

  // // // // // // // // // //
  // Update the sugarcane manager

  // Set the onboarder
  // The address that can make it onboard users (on Base this is the Base relayer, on Goerli it is the defender address, and on the other chains it is their Sugarcane_Onboard_Executor)
  await goerliSugarcaneManager.setOnboarder(onboarder);
  console.log(`\n\n\--- GoerliManager.Onboarder updated - ${onboarder}`);

  // Set the Sugarcane factory
  await goerliSugarcaneManager.setSugarcaneFactory(sugarcaneFactory.address);
  console.log(
    `--- GoerliManager.SugarcaneFactory updated - ${sugarcaneFactory.address}`
  );

  // Set the Sugarcane Onboard Execute Receiver Primary
  await goerliSugarcaneManager.setExecuteOnboardReceiver(
    sugarcaneOnboardExecuteReceiverPrimary.address
  );
  console.log(
    `--- GoerliManager.SugarcaneOnboardExecuteReceiverPrimary updated - ${sugarcaneOnboardExecuteReceiverPrimary.address}`
  );

  return {};
};

export const connectToSecondary = async (
  primaryAddress: string,
  chainId: number,
  secondaryAddress: string
) => {
  const goerliSugarcaneManager = await connectToSugarcaneContract(
    "SugarcaneManagerPrimary",
    primaryAddress
  );

  // // // // // // // // // //
  // Setting up the chain specific contracts

  // Set the Sugarcane onboard executor for mumbai
  await goerliSugarcaneManager.setSecondaryManager(
    // uint256 chainId_,
    chainId,
    // address secondaryManager_
    secondaryAddress
  );
  console.log(
    `\n\n--- GoerliManager.SugarcaneOnboardExecuteReceiver updated - ${secondaryAddress}`
  );
};
