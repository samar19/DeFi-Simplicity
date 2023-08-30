import { createClient } from "wagmi";
import { configureChains } from "wagmi";
import { baseGoerli, hardhat } from "wagmi/chains";
import { publicProvider } from "wagmi/providers/public";
// import { infuraProvider } from "wagmi/providers/infura";
import { WalletConnectConnector } from "wagmi/connectors/walletConnect";
import { CoinbaseWalletConnector } from "wagmi/connectors/coinbaseWallet";

const { chains, provider, webSocketProvider } = configureChains(
  [baseGoerli, hardhat],
  [publicProvider()] // TODO use infura
);

export const coinbaseConnector = new CoinbaseWalletConnector({
  chains,
  options: {
    appName: "Sugarcane",
    jsonRpcUrl: "https://goerli.base.org",
  },
});

export const walletConnectConnector = new WalletConnectConnector({
  chains,
  options: {
    qrcode: true,
  },
});

export const client = createClient({
  autoConnect: true,
  provider,
  webSocketProvider,
  connectors: [coinbaseConnector, walletConnectConnector],
});
