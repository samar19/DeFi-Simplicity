const isLocal = window.location.host.includes("localhost");

const config = {
  sugarcaneBadgeAddress: isLocal
    ? "0x610178dA211FEF7D417bC0e6FeD39F05609AD788"
    : "0xf21F2de046724Db9a40b2EBD56Fd965c110b91df",
  sugarcaneManagerPrimaryAddress: isLocal
    ? "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512"
    : "0x91a312F3f16063dAedA2D73e5D414a79072E5a66",
  sugarcaneInvestmentRegistryAddress: isLocal
    ? "0xa513E6E4b8f2a923D98304ec87F64353C4D5C853"
    : "0x9EeA40360023F949f7192F65304FEC6D3F42Ae04",

  apiUrl: (path: string) => {
    const baseUrl = isLocal
      ? "http://localhost:8080"
      : "https://sugarcane.herokuapp.com";
    return `${baseUrl}${path}`;
  },
};

export default config;
