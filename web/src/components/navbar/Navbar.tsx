import React from "react";
import { useNetwork, useAccount, useConnect, useDisconnect } from "wagmi";

import AppBar from "@mui/material/AppBar";
import Box from "@mui/material/Box";
import Toolbar from "@mui/material/Toolbar";
import Typography from "@mui/material/Typography";
import Menu from "@mui/material/Menu";
import Container from "@mui/material/Container";
import MenuItem from "@mui/material/MenuItem";
import GrassIcon from "@mui/icons-material/Grass";
import AccountBalanceWalletIcon from "@mui/icons-material/AccountBalanceWallet";

import { coinbaseConnector as connector } from "../../config/web3";
import * as blockies from "../../utils/blockies";

const Navbar: React.FC<{}> = () => {
  const { chain } = useNetwork();

  const { address, isConnected } = useAccount();
  const { connect } = useConnect({
    connector,
  });
  const { disconnect } = useDisconnect();
  const [anchorElUser, setAnchorElUser] = React.useState<null | HTMLElement>(
    null
  );
  const handleOpenUserMenu = (event: React.MouseEvent<HTMLElement>) => {
    setAnchorElUser(event.currentTarget);
  };
  const handleCloseUserMenu = () => {
    setAnchorElUser(null);
  };

  return (
    <AppBar position="fixed" sx={{ background: "#ddead1", color: "#4b6043" }}>
      <Container maxWidth="xl">
        <Toolbar disableGutters>
          <GrassIcon sx={{ display: { xs: "none", md: "flex" }, mr: 1 }} />
          <Typography
            variant="h6"
            noWrap
            component="a"
            href="/"
            sx={{
              mr: 2,
              display: { xs: "none", md: "flex" },
              flexGrow: 1,
              fontFamily: "monospace",
              fontWeight: 700,
              letterSpacing: ".3rem",
              color: "inherit",
              textDecoration: "none",
            }}
          >
            Sugarcane
          </Typography>
          <GrassIcon sx={{ display: { xs: "flex", md: "none" }, mr: 1 }} />
          <Typography
            variant="h5"
            noWrap
            component="a"
            sx={{
              mr: 2,
              display: { xs: "flex", md: "none" },
              flexGrow: 1,
              fontFamily: "monospace",
              fontWeight: 700,
              letterSpacing: ".3rem",
              color: "inherit",
              textDecoration: "none",
            }}
          >
            Sugarcane
          </Typography>
          <Box
            sx={{ display: "flex", cursor: "pointer", flexGrow: 0 }}
            onClick={(e) => {
              isConnected ? handleOpenUserMenu(e) : connect();
            }}
          >
            <AccountBalanceWalletIcon sx={{ display: "flex", mr: 1 }} />
            <Typography
              variant="body1"
              noWrap
              sx={{
                mr: 2,
                display: { xs: "none", md: "flex" },

                flexGrow: 1,
                fontWeight: 500,
                color: "inherit",
              }}
            >
              {isConnected
                ? `...${address?.substring(address?.length - 8)}`
                : "Connect Wallet"}
            </Typography>
            {address ? (
              <img
                alt="profile"
                style={{ width: "25px", height: "25px", borderRadius: "50px" }}
                src={blockies
                  .create({
                    seed: address,
                  })
                  .toDataURL()}
              />
            ) : null}
          </Box>
          <Menu
            sx={{ mt: "45px" }}
            id="menu-appbar"
            anchorEl={anchorElUser}
            anchorOrigin={{
              vertical: "top",
              horizontal: "right",
            }}
            keepMounted
            transformOrigin={{
              vertical: "top",
              horizontal: "right",
            }}
            open={Boolean(anchorElUser)}
            onClose={handleCloseUserMenu}
          >
            <MenuItem onClick={handleCloseUserMenu}>
              <Typography textAlign="center">{`Chain: ${chain?.name}`}</Typography>
            </MenuItem>
            <MenuItem
              onClick={() => {
                disconnect();
                handleCloseUserMenu();
              }}
            >
              <Typography textAlign="center">Disconnect Wallet</Typography>
            </MenuItem>
          </Menu>
        </Toolbar>
      </Container>
    </AppBar>
  );
};

export default Navbar;
