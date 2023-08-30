import { useAccount, useContractRead } from "wagmi";
import React from "react";

import Stack from "@mui/material/Stack";
import Box from "@mui/material/Box";
import Typography from "@mui/material/Typography";
import Divider from "@mui/material/Divider";

import Badge from "./Badge";

import sugarcaneBadgeAbi from "../../../contracts/sugarcaneBadgeAbi";
import config from "../../../config";

const badgeIds: any = {
  FRIEND_REFER:
    "0x64c31d2dd115712ca7e46f4dcedbc17e51fe2e85dc910ec96b10b02b3688aea0",
  LIQUIDITY_PROVIDER:
    "0xefb6a2729b4a597e0ef28a8470ce63d4a66c6a12ddc531858c554a1f94d562a5",
  STAKER: "0x54088d811ac657461732d1713f22fca7b3e427be2faf203cc1ec8bdddd828326",
  LENDER: "0x90421265d383fabf3b103977d9b8f5119480c029957c1e5daba36a0a6e69aa36",
  INVEST_ONE:
    "0xe78c29d58a44084a7f6fac9c5a0db14e86084e060b0348c609f1a1b8fba605be",
  INVEST_FIVE:
    "0x1f0a9d23bac0dd6ae01ed701ff3f1bbdc7c452a89ad54860e456fb5fcda02931",
  INVEST_TEN:
    "0xab849959e3484e4477fa4cff6fd2a28e9dd3a8c01e0c5788cc74afdab8f58422",
};

const BadgeSection: React.FC<{}> = () => {
  const { address } = useAccount();

  const badgeNames = Object.keys(badgeIds);

  const {
    data: badgeBalances,
    // isError,
    // isLoading,
    // error,
  } = useContractRead({
    //@ts-ignore
    address: config.sugarcaneBadgeAddress,
    abi: sugarcaneBadgeAbi,
    functionName: "balanceOfBatch",
    args: [
      Array(badgeNames.length).fill(address),
      badgeNames.map((n) => (badgeIds as any)[n]),
    ],
    watch: true,
  });

  return (
    <Box mb={8}>
      <Box
        mb={1}
        display="flex"
        justifyContent="space-between"
        alignItems="baseline"
      >
        <Typography
          variant="h4"
          sx={{
            fontWeight: 600,
          }}
        >
          My Badges
        </Typography>
      </Box>

      <Divider />
      <Box pt={4}>
        <Stack direction={"row"} flexWrap="wrap">
          {[...badgeNames]
            .sort((a, b) => {
              const aIndex = badgeNames.indexOf(a);
              const aBalance =
                badgeBalances && (badgeBalances as any[])[aIndex];
              const aOwns = aBalance && aBalance?._hex !== "0x00";

              const bIndex = badgeNames.indexOf(b);
              const bBalance =
                badgeBalances && (badgeBalances as any[])[bIndex];
              const bOwns = bBalance && bBalance?._hex !== "0x00";

              if (aOwns && !bOwns) {
                return -1;
              } else if (bOwns && !aOwns) {
                return 1;
              } else {
                return bIndex > aIndex ? -1 : 1;
              }
            })
            .map((badgeName) => {
              const balance =
                badgeBalances &&
                (badgeBalances as any[])[badgeNames.indexOf(badgeName)];
              const owns = balance && balance?._hex !== "0x00";

              return (
                <Badge
                  key={badgeName}
                  badgeId={badgeIds[badgeName]}
                  owned={owns}
                />
              );
            })}
        </Stack>
      </Box>
    </Box>
  );
};

export default BadgeSection;
