import React from "react";

import Box from "@mui/material/Box";
import Typography from "@mui/material/Typography";

const Header: React.FC<{}> = () => {
  return (
    <Box mt={6} mb={12}>
      <Typography
        variant="h2"
        sx={{
          textAlign: "center",
          fontWeight: 600,
        }}
      >
        The simplest way to BASE your assets.
      </Typography>
      <Typography
        variant="h2"
        sx={{
          textAlign: "center",
          fontWeight: 600,
        }}
      >
        Any chain. Your custody.
      </Typography>
    </Box>
  );
};

export default Header;
