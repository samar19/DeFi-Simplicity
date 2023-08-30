import React from "react";
import products from "../../../config/products";

import AssetClassSection from "./AssetClassSection";

const FinancialProducts: React.FC<{}> = () => {
  return (
    <>
      <AssetClassSection
        title="Lending"
        youtubeVideoId="aTp9er6S73M"
        products={products.filter((p) => p.category === "lending")}
      />
      <AssetClassSection
        title="Liquidity Providing"
        youtubeVideoId="cizLhxSKrAc"
        products={products.filter((p) => p.category === "lp")}
      />
      <AssetClassSection
        title="Staking"
        youtubeVideoId="ALEMhA82UoU"
        products={products.filter((p) => p.category === "staking")}
      />
    </>
  );
};

export default FinancialProducts;
