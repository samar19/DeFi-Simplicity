import React from "react";
import Box from "@mui/material/Box";
import Grid from "@mui/material/Grid";
import InvestmentsSections from "./InvestmentsSections";
import BadgeSection from "./BadgeSection";

const UserProfile: React.FC<{}> = () => {
  return (
    <>
      <Box mb={6}>
        <Grid container spacing={2}>
          <Grid item xs={12} sm={8} md={8} lg={9}>
            <InvestmentsSections />
          </Grid>
          <Grid item xs={12} sm={4} md={4} lg={3}>
            <BadgeSection />
          </Grid>
        </Grid>
      </Box>
    </>
  );
};

export default UserProfile;
