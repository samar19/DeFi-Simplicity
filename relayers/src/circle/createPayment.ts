//https://developers.circle.com/developer/reference/createpayment

import fetch from "node-fetch";

const url = "https://api-sandbox.circle.com/v1/payments";

interface Payment {}

interface CreatePaymentParams {
  idempotencyKey: string;
  keyId?: string;
  metadata: {
    email: string;
    phoneNumber?: string;
    sessionId: string;
    ipAddress: string;
  };
  amount: {
    amount: string;
    currency: "USD";
  };
  autoCapture?: boolean;
  verification: "none" | "cvv" | "three_d_secure";
  verificationSuccessUrl?: string;
  verificationFailureUrl?: string;
  source: {
    id: string;
    type: "card" | "ach";
  };
  description?: string;
  encryptedData?: string;
  channel?: string;
}
const createPayment = async (params: CreatePaymentParams): Promise<Payment> => {
  const response = await fetch(url, {
    method: "POST",
    headers: {
      accept: "application/json",
      "content-type": "application/json",
      Authorization: `Bearer ${process.env.CIRCLE_TOKEN}`,
    },
    body: JSON.stringify(params),
  }).then((res) => res.json());

  return response.data as Payment;
};

export default createPayment;
