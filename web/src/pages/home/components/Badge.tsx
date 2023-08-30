import { useContractRead } from "wagmi";
import React, { useState } from "react";

import Tooltip from "@mui/material/Tooltip";
import Box from "@mui/material/Box";
import Typography from "@mui/material/Typography";

import sugarcaneBadgeAbi from "../../../contracts/sugarcaneBadgeAbi";
import config from "../../../config";

interface BadgeData {
  name: string;
  description: string;
  image: string;
}

interface Props {
  badgeId: string;
  owned: boolean;
}

const Badge: React.FC<Props> = ({ badgeId, owned }) => {
  const [badgeData, setBadgeData] = useState<BadgeData>();

  const {
    data: _badge,
    // isError,
    // isLoading,
    // error,
  } = useContractRead({
    //@ts-ignore
    address: config.sugarcaneBadgeAddress,
    abi: sugarcaneBadgeAbi,
    functionName: "uri",
    args: [badgeId],
  });

  React.useEffect(() => {
    if (_badge) {
      fetch(_badge as string)
        .then((r) => r.json())
        .then((data) => {
          setBadgeData(data);
        });
    }
  }, [_badge]);

  return (
    <Tooltip
      key={badgeId}
      title={badgeData?.description}
      PopperProps={{
        sx: {
          "> div": {
            fontSize: "18px",
            textAlign: "center",
            padding: 2,
            letterSpacing: "1px",
          },
        },
      }}
    >
      <Box
        sx={{
          maxWidth: {
            xs: "80px",
            sm: "80px",
            md: "100px",
            lg: "100px",
          },
          cursor: "default",
        }}
      >
        <img
          src={badgeData?.image}
          style={{
            width: "100%",
            ...(owned ? {} : { opacity: 0.2 }),
          }}
          alt={badgeData?.name}
        />
        <Typography
          sx={{
            textAlign: "center",
            fontSize: "14px",
            ...(owned ? {} : { opacity: 0.2 }),
          }}
        >
          {badgeData?.name}
        </Typography>
      </Box>
    </Tooltip>
  );
};

export default Badge;
