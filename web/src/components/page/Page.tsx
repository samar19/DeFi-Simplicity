import React from "react";
import Box from "@mui/material/Box";
import Container from "@mui/material/Container";

const Page: React.FC<React.PropsWithChildren> = ({ children }) => {
  return (
    <Box
      flex={1}
      overflow="auto"
      pt={12}
      sx={{ background: "#f7faf4", color: "#4b6043" }}
    >
      <Container maxWidth="xl">{children}</Container>
    </Box>
  );
};

export default Page;
