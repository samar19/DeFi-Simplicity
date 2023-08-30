import fetch from "node-fetch";

const url = (cardId: string) =>
  `https://api-sandbox.circle.com/v1/cards/${cardId}`;

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

const getCard = async (cardId: string): Promise<Card> => {
  const response = await fetch(url(cardId), {
    method: "GET",
    headers: {
      accept: "application/json",
      Authorization: `Bearer ${process.env.CIRCLE_TOKEN}`,
    },
  }).then((res) => res.json());

  return response.data as Card;
};

export default getCard;
