import aaveLogo from "../assets/aave-logo.png";
import ssvLogo from "../assets/ssv-logo.png";
import uniswapLogo from "../assets/uniswap-logo.png";

export interface Product {
  id: number;
  name: string;
  yield: string;
  description: string;
  risk: "High" | "Medium" | "Low";
  logo: string;
  category: "lending" | "lp" | "staking";
  available?: boolean;
}

const products: Product[] = [
  {
    id: 0,
    name: "AAVE",
    yield: "5-10%",
    description: `Aave is a decentralised non-custodial liquidity market protocol where users can participate as suppliers or borrowers. Suppliers provide liquidity to the market to earn a passive income, while borrowers are able to borrow in an overcollateralised (perpetually) or undercollateralised (one-block liquidity) fashion.`,
    risk: "Low",
    logo: aaveLogo,
    category: "lending",
    available: true,
  },
  {
    id: 1,
    name: "SSV",
    yield: "5-10%",
    description: `Secret Shared Validators (SSV) is the first secure and robust way to split an Ethereum validator key between non-trusting nodes run by operators. The nodes do not need to trust each other to carry out their validator duties, and a certain number can be offline without affecting validator performance. No single node can sign data on behalf of a validator, yet not all are needed to create a valid signature, adding fault tolerance to the staking ecosystem. The result is a reliable, decentralized, secure staking solution for Ethereum. Learn more about how SSV works under the hood in the SSV Tech Deep Dive.`,
    risk: "Medium",
    logo: ssvLogo,
    category: "staking",
  },
  {
    id: 2,
    name: "Uniswap",
    yield: "5-10%",
    description: `Uniswap is a decentralized cryptocurrency exchange that uses a set of smart contracts to execute trades on its exchange. It's an open source project and falls into the category of a DeFi product because it uses smart contracts to facilitate trades.`,
    risk: "Low",
    logo: uniswapLogo,
    category: "lp",
  },
];

export default products;
