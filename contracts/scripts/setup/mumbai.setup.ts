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

export interface IMumbaiContracts extends IContractSet {
  sugarcaneManager: Contract;
  sugarcaneFactory: Contract;
  sugarcaneOnboardExecuteReceiverSecondary: Contract;
}

export const setUp: ISetUpFunction<IMumbaiContracts> = async (
  deployer: SignerWithAddress,
  onboarder: string,
  bridge: IBridgeAddresses
) => {
  // Deploy Sugarcane Manager Secondary
  const mumbaiSugarcaneManager = await deploySugarcaneContract(
    deployer,
    "SugarcaneManagerSecondary",
    [chainIds.mumbai, bridge.gatewayAddress, bridge.gasServiceAddress]
  );

  // Deploy Sugarcane Factory
  const sugarcaneFactory = await deploySugarcaneContract(
    deployer,
    "SugarcaneFactory",
    [mumbaiSugarcaneManager.address]
  );

  // Deploy Sugarcane Onboard Execute Receiver Secondary
  const sugarcaneOnboardExecuteReceiverSecondary =
    await deploySugarcaneContract(
      deployer,
      "SugarcaneOnboardExecuteReceiverSecondary",
      [
        // uint256 chainId_,
        chainIds.mumbai,
        // address gateway_,
        bridge.gatewayAddress,
        // address secondaryManagerAddress_
        mumbaiSugarcaneManager.address,
      ]
    );

  // // // // // // // // // //
  // Update the sugarcane manager

  // Set the onboarder
  // The address that can make it onboard users (on Base this is the Base relayer, on Goerli it is the defender address, and on the other chains it is their Sugarcane_Onboard_Executor)
  await mumbaiSugarcaneManager.setOnboarder(
    sugarcaneOnboardExecuteReceiverSecondary.address
  );
  console.log(`\n\n\--- MumbaiManager.Onboarder updated - ${onboarder}`);

  // Set the Sugarcane factory
  await mumbaiSugarcaneManager.setSugarcaneFactory(sugarcaneFactory.address);
  console.log(
    `--- MumbaiManager.SugarcaneFactory updated - ${sugarcaneFactory.address}`
  );

  // Set the Sugarcane Onboard Execute Receiver Secondary
  await mumbaiSugarcaneManager.setExecuteOnboardReceiver(
    sugarcaneOnboardExecuteReceiverSecondary.address
  );
  console.log(
    `--- MumbaiManager.SugarcaneOnboardExecuteReceiverPrimary updated - ${sugarcaneOnboardExecuteReceiverSecondary.address}`
  );

  return {
    sugarcaneManager: mumbaiSugarcaneManager,
    sugarcaneFactory,
    sugarcaneOnboardExecuteReceiverSecondary,
  };
};
