import Web3 from "web3";
import abi from "./sugarcaneManagerPrimaryBaseAbi";

const isLocal = process.env.IS_LOCAL_NETWORK === "true";
const smartContractAddress =
  process.env.BASE_GOERLI_MANAGER_SMART_CONTRACT_ADDRESS;

interface RecordInvestmentParams {
  address: string;
  chainId: number;
  protocolId: string;
  initialAmountUsd: number;
}
export const recordInvestment = async ({
  address,
  chainId,
  protocolId,
  initialAmountUsd,
}: RecordInvestmentParams) => {
  const web3 = new Web3(
    new Web3.providers.HttpProvider(
      isLocal
        ? "http://0.0.0.0:8545"
        : `https://base-goerli.infura.io/v3/${process.env.INFURA_API_KEY}`
    )
  );

  // Creating a signing account from a private key
  const signer = web3.eth.accounts.privateKeyToAccount(
    process.env.BASE_GOERLI_RELAYER_PRIVATE_KEY || ""
  );

  web3.eth.accounts.wallet.add(signer);
  const contract = new web3.eth.Contract(
    //@ts-ignore
    abi,
    smartContractAddress
  );

  console.log({
    address,
    chainId,
    protocolId,
    initialAmountUsd,
  });

  const tx = contract.methods.recordInvestment(
    address,
    chainId,
    protocolId,
    initialAmountUsd
  );

  const receipt = await tx
    .send({
      from: signer.address,
      gas: await tx.estimateGas(),
    })
    .once("transactionHash", (txhash: string) => {
      console.log(`Mining transaction ...`);
      console.log(`https://goerli.basescan.org/tx/${txhash}`);
    });

  console.log(`Mined in block ${receipt.blockNumber}`);
};

export const onboardAccount = async (address: string) => {
  const web3 = new Web3(
    new Web3.providers.HttpProvider(
      isLocal
        ? "http://0.0.0.0:8545"
        : `https://base-goerli.infura.io/v3/${process.env.INFURA_API_KEY}`
    )
  );

  const signer = web3.eth.accounts.privateKeyToAccount(
    process.env.BASE_GOERLI_RELAYER_PRIVATE_KEY || ""
  );

  web3.eth.accounts.wallet.add(signer);
  const contract = new web3.eth.Contract(
    //@ts-ignore
    abi,
    smartContractAddress
  );

  const tx = contract.methods.onboardAccount(address);

  const receipt = await tx
    .send({
      from: signer.address,
      gas: await tx.estimateGas(),
    })
    .once("transactionHash", (txhash: string) => {
      console.log(`Mining transaction ...`);
      console.log(`https://goerli.basescan.org/tx/${txhash}`);
    });

  console.log(`Mined in block ${receipt.blockNumber}`);
  console.log(`Done onboarding ${address} to base`);
};

interface OnboardDetailsParams {
  onboardingIndex: string;
  onboardedBlock: string;
  timestamp: string;
  holdingsAddress: string;
  isOnboarded: boolean;
}
export const onboardDetails = async (
  address: string
): Promise<OnboardDetailsParams> => {
  const web3 = new Web3(
    new Web3.providers.HttpProvider(
      isLocal
        ? "http://0.0.0.0:8545"
        : `https://base-goerli.infura.io/v3/${process.env.INFURA_API_KEY}`
    )
  );

  const signer = web3.eth.accounts.privateKeyToAccount(
    process.env.BASE_GOERLI_RELAYER_PRIVATE_KEY || ""
  );

  web3.eth.accounts.wallet.add(signer);
  const contract = new web3.eth.Contract(
    //@ts-ignore
    abi,
    smartContractAddress
  );

  const tx = contract.methods.onboardDetails(address);

  const response = await tx.call({
    from: signer.address,
    gas: await tx.estimateGas(),
  });

  console.log(`Fetched onboarding details ${address} to base`);

  return {
    onboardingIndex: response[0],
    onboardedBlock: response[1],
    timestamp: response[2],
    holdingsAddress: response[3],
    isOnboarded: response[4],
  };
};
