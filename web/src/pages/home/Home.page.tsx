import React, { useEffect, useState } from "react";
import { useAccount, useContractRead } from "wagmi";

import Page from "../../components/page/Page";

import Header from "./components/Header";
import UserProfile from "./components/UserProfile";
import FinancialProducts from "./components/FinancialProducts";

import config from "../../config";
import sugarcaneManagerPrimaryBaseAbi from "../../contracts/sugarcaneManagerPrimaryBaseAbi";
import onboard from "../../utils/onboard";

const HomePage: React.FC<{}> = () => {
  const [isOnboarding, setIsOnboarding] = useState(false);
  const { address, isConnected } = useAccount();
  const {
    data: hasOnboarded,
    // isError,
    // isLoading,
    // error,
  } = useContractRead({
    //@ts-ignore
    address: address ? config.sugarcaneManagerPrimaryAddress : undefined,
    abi: sugarcaneManagerPrimaryBaseAbi,
    functionName: "hasOnboarded",
    args: [address],
  });

  useEffect(() => {
    if (address && hasOnboarded === false && !isOnboarding) {
      setIsOnboarding(true);
      console.log("doing it");
      onboard(address);
    }
  }, [hasOnboarded, address, isOnboarding]);

  console.log({ hasOnboarded });

  return (
    <Page>
      <Header />
      {isConnected && <UserProfile />}
      <FinancialProducts />
    </Page>
  );
};

export default HomePage;
