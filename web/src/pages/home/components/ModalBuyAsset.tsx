import { useState, FC } from "react";
import { useAccount, useConnect, useSignMessage } from "wagmi";
import Confetti from "react-confetti";

import Box from "@mui/material/Box";
import Button from "@mui/material/Button";
import Typography from "@mui/material/Typography";
import CircularProgress from "@mui/material/CircularProgress";
import Grid from "@mui/material/Grid";
import {
  Divider,
  FormControl,
  InputAdornment,
  InputLabel,
  OutlinedInput,
} from "@mui/material";
import CreditCardIcon from "@mui/icons-material/CreditCard";
import CheckCircleIcon from "@mui/icons-material/CheckCircle";
import AccountBalanceWalletIcon from "@mui/icons-material/AccountBalanceWallet";

import Modal from "../../../components/modal/Modal";
import { walletConnectConnector as connector } from "../../../config/web3";
import { Product } from "../../../config/products";
import amountIsValid from "../../../utils/amountIsValid";
import encryptCardDetails from "../../../utils/encryptCardDetails";
import saveCardToCircle from "../../../utils/saveCardToCircle";
import createCirclePayment from "../../../utils/createCirclePayment";
import executeTransaction from "../../../utils/executeTransaction";

interface Props {
  product: Product;
  showModal: boolean;
  setShowModal: (o: boolean) => void;
}

const FinancialProductCard: FC<Props> = ({
  product,
  showModal,
  setShowModal,
}) => {
  const { address, isConnected } = useAccount();
  const { connect, isLoading: isConnectingWallet } = useConnect({
    connector,
  });
  const [successfullyInvested, setSuccessfullyInvested] = useState(false);
  const [amount, setAmount] = useState("");
  const [ccNumber, setCcNumber] = useState("4007400000000007");
  const [cvv, setCvv] = useState("123");
  const [date, setDate] = useState("12/2026");
  const [isSubmittingAmount, setIsSubmittingAmount] = useState(false);
  const { name, description, logo } = product;
  const { signMessage } = useSignMessage({
    async onSuccess(data, _variables) {
      try {
        await executeTransaction({
          address: address || "",
          transaction: data,
          amount,
        });
        setSuccessfullyInvested(true);
        setIsSubmittingAmount(false);
      } catch (e: any) {
        window.alert(e?.message || e);
        setIsSubmittingAmount(false);
      }
    },
    onError(error) {
      window.alert(error?.message || error);
      setIsSubmittingAmount(false);
    },
  });

  const handleSubmit = async () => {
    if (!amountIsValid(amount)) {
      return;
    }
    setIsSubmittingAmount(true);
    try {
      const encryptor = await encryptCardDetails();
      const encryptRes = await encryptor({
        number: ccNumber,
        cvv,
      });

      const cardRes = await saveCardToCircle({
        keyId: encryptRes.keyId,
        encryptedData: encryptRes.encryptedData,
      });

      await createCirclePayment({
        amount,
        cardId: cardRes.id,
        address: address || "",
      });

      signMessage({ message: `Purchase: AAVE; Amount: $${amount}` });
    } catch (e: any) {
      window.alert(e?.message || e);
      setIsSubmittingAmount(false);
    }
  };

  return (
    <Modal
      open={showModal}
      setOpen={(o: boolean) => {
        if (isSubmittingAmount) return;
        setShowModal(o);
        if (o === false) {
          setTimeout(() => {
            setAmount("");
            setSuccessfullyInvested(false);
          }, 2000);
        }
      }}
    >
      {successfullyInvested && <Confetti />}
      <Box>
        <Box sx={{ textAlign: "center" }} mb={2}>
          <img
            src={logo}
            alt={name}
            style={{
              width: 50,
              height: 50,
              objectFit: "contain",
            }}
          />
        </Box>
        <Typography textAlign={"center"} variant="h3" mb={2}>
          {name}
        </Typography>
        <Divider />
        <Typography textAlign={"center"} variant="body1" mt={2} mb={10}>
          {description}
        </Typography>

        {successfullyInvested ? (
          <Box textAlign="center" mt={-5}>
            <CheckCircleIcon sx={{ color: "green", fontSize: "135px" }} />
            <Typography sx={{ fontSize: "24px", mb: 2 }}>
              Congratulations!
            </Typography>
            <Typography sx={{ fontSize: "18px" }}>
              Your order has been placed and will be available soon.
            </Typography>
          </Box>
        ) : (
          <Box sx={{ textAlign: "center" }} mb={2}>
            <FormControl fullWidth sx={{ maxWidth: "300px", mb: 2 }}>
              <InputLabel htmlFor="outlined-adornment-amount">
                Amount
              </InputLabel>
              <OutlinedInput
                id="outlined-adornment-amount"
                startAdornment={
                  <InputAdornment position="start">$</InputAdornment>
                }
                label="Amount"
                value={amount}
                disabled={isSubmittingAmount}
                onChange={(e) => {
                  setAmount(e.target.value);
                }}
              />
            </FormControl>

            <Divider sx={{ mt: 2, mb: 4 }} />

            {!product.available ? (
              <>
                <Box sx={{ maxWidth: "300px", margin: "auto" }}>
                  <Button
                    variant="contained"
                    fullWidth
                    size="large"
                    sx={{ maxWidth: "300px", height: "56px" }}
                    disabled
                  >
                    Coming Soon!
                  </Button>
                </Box>
                {isConnectingWallet ? (
                  <CircularProgress sx={{ mt: 2 }} />
                ) : null}
              </>
            ) : isConnected ? (
              <>
                <FormControl fullWidth sx={{ maxWidth: "300px", mb: 2 }}>
                  <InputLabel htmlFor="outlined-adornment-amount">
                    Card Number (Sandbox)
                  </InputLabel>
                  <OutlinedInput
                    id="outlined-adornment-amount"
                    startAdornment={
                      <InputAdornment position="start">
                        <CreditCardIcon />
                      </InputAdornment>
                    }
                    label="Card Number (Sandbox)"
                    value={ccNumber}
                    disabled={isSubmittingAmount}
                    onChange={(e) => {
                      setCcNumber(e.target.value);
                    }}
                  />
                </FormControl>
                <Box sx={{ maxWidth: "300px", margin: "auto" }}>
                  <Grid container spacing={2}>
                    <Grid item xs={6}>
                      <FormControl fullWidth sx={{ mb: 2 }}>
                        <InputLabel htmlFor="outlined-adornment-amount">
                          Expiry Date
                        </InputLabel>
                        <OutlinedInput
                          label="Expiry Date"
                          value={date}
                          disabled={isSubmittingAmount}
                          onChange={(e) => {
                            setDate(e.target.value);
                          }}
                        />
                      </FormControl>
                    </Grid>
                    <Grid item xs={6}>
                      <FormControl fullWidth sx={{ mb: 2 }}>
                        <InputLabel htmlFor="outlined-adornment-amount">
                          CVV
                        </InputLabel>
                        <OutlinedInput
                          label="CVV"
                          value={cvv}
                          disabled={isSubmittingAmount}
                          onChange={(e) => {
                            setCvv(e.target.value);
                          }}
                        />
                      </FormControl>
                    </Grid>
                  </Grid>
                </Box>
                <Box>
                  <Button
                    variant="contained"
                    fullWidth
                    size="large"
                    sx={{ maxWidth: "300px", height: "56px" }}
                    disabled={!amountIsValid(amount) || isSubmittingAmount}
                    onClick={handleSubmit}
                  >
                    Buy
                  </Button>
                </Box>
                {isSubmittingAmount ? (
                  <CircularProgress sx={{ mt: 2 }} />
                ) : null}
              </>
            ) : (
              <>
                <Box sx={{ maxWidth: "300px", margin: "auto" }}>
                  <Button
                    variant="contained"
                    fullWidth
                    size="large"
                    sx={{ maxWidth: "300px", height: "56px" }}
                    onClick={() => {
                      connect();
                    }}
                  >
                    <AccountBalanceWalletIcon sx={{ display: "flex", mr: 1 }} />
                    Connect Wallet
                  </Button>
                </Box>
                {isConnectingWallet ? (
                  <CircularProgress sx={{ mt: 2 }} />
                ) : null}
              </>
            )}
          </Box>
        )}
      </Box>
    </Modal>
  );
};

export default FinancialProductCard;
