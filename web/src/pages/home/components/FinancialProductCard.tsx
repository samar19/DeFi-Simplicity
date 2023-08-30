import { useState, FC } from "react";

import Box from "@mui/material/Box";
import Card from "@mui/material/Card";
import CardContent from "@mui/material/CardContent";
import Typography from "@mui/material/Typography";

import ModalBuyAsset from "./ModalBuyAsset";
import { Product } from "../../../config/products";

interface Props {
  product: Product;
}

const FinancialProductCard: FC<Props> = ({ product }) => {
  const [showModal, setShowModal] = useState(false);
  const { name, yield: yieldPercent, risk, logo } = product;

  return (
    <>
      <Card
        sx={{ width: 300, cursor: "pointer", pt: 2, textAlign: "center" }}
        onClick={() => setShowModal(true)}
      >
        <CardContent>
          <Box sx={{ textAlign: "center" }} mb={2}>
            <img
              src={logo}
              alt={name}
              style={{
                width: 200,
                height: 200,
                objectFit: "contain",
              }}
            />
          </Box>
          <Typography sx={{ fontSize: 18 }} color="text.secondary" gutterBottom>
            {name}
          </Typography>
          <Typography sx={{ fontSize: 18 }} color="text.secondary" gutterBottom>
            {yieldPercent} returns
          </Typography>
          <Typography
            sx={{
              mb: 1.5,
            }}
          >
            Risk:{" "}
            <span
              style={{
                color:
                  risk === "High"
                    ? "red"
                    : risk === "Medium"
                    ? "gray"
                    : "green",
              }}
            >
              {risk}
            </span>
          </Typography>
        </CardContent>
      </Card>
      <ModalBuyAsset
        product={product}
        showModal={showModal}
        setShowModal={setShowModal}
      />
    </>
  );
};

export default FinancialProductCard;
