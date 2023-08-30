import fetch from "node-fetch";

const url = "https://api-sandbox.circle.com/v1/cards";

interface Card {
  id: string;
  status: string; // TODO use enum "pending";
  last4: string;
  billingDetails: {
    name: string;
    line1: string;
    city: string;
    postalCode: string;
    district: string;
    country: string;
  };
  expMonth: number;
  expYear: number;
  network: string;
  bin: string;
  issuerCountry: string;
  fundingType: string;
  fingerprint: string;
  verification: { cvv: string; avs: string };
  createDate: string;
  metadata: { email: string };
  updateDate: string;
}

interface CreateCardParams {
  idempotencyKey: string;
  keyId: string;
  encryptedData: string;
  billingDetails: {
    name: string;
    city: string;
    country: string;
    line1: string;
    line2?: string;
    //State / County / Province / Region portion of the address. If the country is US or Canada, then district is required and should use the two-letter code for the subdivision.
    district?: string;
    postalCode: string;
  };
  expMonth: number;
  expYear: number;
  metadata: {
    email: string;
    phoneNumber?: string;
    sessionId: string;
    ipAddress: string;
  };
}
const createCard = async (params: CreateCardParams): Promise<Card> => {
  const response = await fetch(url, {
    method: "POST",
    headers: {
      accept: "application/json",
      "content-type": "application/json",
      Authorization: `Bearer ${process.env.CIRCLE_TOKEN}`,
    },
    body: JSON.stringify(params),
  }).then((res) => res.json());

  return response.data as Card;
};

export default createCard;
