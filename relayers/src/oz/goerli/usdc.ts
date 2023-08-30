import {
  DefenderRelayProvider,
  DefenderRelaySigner,
} from "defender-relay-client/lib/ethers";
import { ethers } from "ethers";
import abi from "./usdcAbi";

const usdcContractAddress = "0x07865c6e87b9f70255377e024ace6630c1eaa37f";

const goerliApiKey = process.env.OZ_DEFENDER_GOERLI_RELAY_API_KEY || "";
const goerliApiSecret = process.env.OZ_DEFENDER_GOERLI_RELAY_API_SECRET || "";
const defenderCredentials = {
  apiKey: goerliApiKey,
  apiSecret: goerliApiSecret,
};

const provider = new DefenderRelayProvider(defenderCredentials);
const signer = new DefenderRelaySigner(defenderCredentials, provider, {
  speed: "fast",
});

export const transferUSDC = async (toAddress: string, amount: string) => {
  //@ts-ignore
  const usdcContract = new ethers.Contract(usdcContractAddress, abi, signer);
  console.log({ toAddress, amount });
  await usdcContract.transfer(toAddress, amount + "000000");
  console.log(`Done mining ${amount}USDC to ${toAddress}`);
};

export const balanceOfUSDC = async (toAddress: string) => {
  //@ts-ignore
  const usdcContract = new ethers.Contract(usdcContractAddress, abi, signer);
  const res = await usdcContract.balanceOf(toAddress);
  console.log(res);
  return res;
};
