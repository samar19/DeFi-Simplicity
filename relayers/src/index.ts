require("dotenv").config();
import "express-async-errors";

import { Request, Response, NextFunction } from "express";
import { faker } from "@faker-js/faker";
import express from "express";
import bodyParser from "body-parser";
import cors from "cors";
import getPCIPublicKey from "./circle/getPCIPublicKey";
import createCard from "./circle/createCard";
import createPayment from "./circle/createPayment";
import { transferUSDC } from "./oz/goerli/usdc";
import {
  recordInvestment,
  onboardAccount as onboardToBase,
  // onboardDetails as onboardDetailsFromBase,
} from "./contracts/sugarcaneManagerPrimaryBase";

import {
  onboardAccount as onboardToGoerli,
  onboardDetails as onboardDetailsFromGoerli,
} from "./oz/goerli/sugarcaneManagerPrimaryGoerli";

const port = process.env.PORT || "8080";

const app = express();

app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json({ limit: "5mb" }));

app.get("/", (_req, res) => {
  res.send("Alive");
});

app.post("/onboard", async (req, res) => {
  const { address } = req.body;

  console.log("onboarding for ", address);

  await Promise.all([
    onboardToBase(address).catch((e) => {
      console.error("onboardToBase error: ", e);
    }),
    onboardToGoerli(address).catch((e) => {
      console.error("onboardToGoerli error: ", e);
    }),
  ]);

  res.send({});
});

app.get("/pci-public-key", async (req, res) => {
  const response = await getPCIPublicKey();
  res.send(response);
});

app.post("/create-card", async (req, res) => {
  const { keyId, encryptedData } = req.body;

  const params = {
    idempotencyKey: faker.datatype.uuid(),
    keyId,
    encryptedData,
    billingDetails: {
      name: faker.name.fullName(),
      city: faker.address.city(),
      country: "US",
      line1: faker.address.streetAddress(),
      district: "NY",
      postalCode: "10037",
    },
    expMonth: 12,
    expYear: 2026,
    metadata: {
      email: `founders+${Math.random()}@meshlink.ai`,
      sessionId: Math.random().toString(),
      ipAddress: "165.235.125.71",
    },
  };

  const card = await createCard(params);

  console.log({ card });

  res.send(card);
});

app.post("/create-payment", async (req, res) => {
  const { amount, cardId, address } = req.body;

  const params = {
    idempotencyKey: faker.datatype.uuid(),
    keyId: "keyId", // sandbox
    metadata: {
      email: `founders+${Math.random()}@meshlink.ai`,
      sessionId: Math.random().toString(),
      ipAddress: "165.235.125.71",
    },
    amount: {
      amount: amount,
      currency: "USD" as const,
    },
    verification: "none" as const,
    source: {
      id: cardId,
      type: "card" as const,
    },
  };

  const payment = await createPayment(params);
  console.log({ payment });

  const onboardingDetails = await onboardDetailsFromGoerli(address);
  console.log({ onboardingDetails });

  await transferUSDC(onboardingDetails.holdingsAddress, amount);

  console.log("USDC transferred. Amount: ", amount);

  res.send(payment);
});

app.post("/execute-transaction", async (req, res) => {
  const { address, transaction, amount } = req.body;

  console.log({ address, transaction });

  await recordInvestment({
    address,
    chainId: 80001,
    protocolId: process.env.PROTOCOL_ID_AAVE || "",
    initialAmountUsd: amount,
  });

  console.log("Recorded badge");

  // TODO send signed txn and address to defender

  console.log("Forwarded signed txn to defender");

  res.send({});
});

app.post("/", (req, res) => {
  res.send({
    res: req.body.blah,
  });
});

app.use(async (err: any, req: Request, res: Response, _next: NextFunction) => {
  console.error(err);
  res.status(500);
  res.send(err);
});

app.listen(port, () => {
  console.log(`[Relayer]: Running on port: ${port}`);
});
