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
          color: "blue",
        }}
      >
        Empowering DeFi for Everyone
      </Typography>
      <Typography
        variant="h2"
        sx={{
          textAlign: "center",
          fontWeight: 600,
          color: "blue",
        }}
      >
        Simplified Access, Comprehensive Understanding      </Typography>
    </Box>
  );
};

export default Header;
