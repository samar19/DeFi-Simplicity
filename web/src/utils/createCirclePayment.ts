import config from "../config";

interface Card {
  data: {
    keyId: string;
    publicKey: string;
  };
}

interface CreateCirclePaymentParams {
  amount: string;
  cardId: string;
  address: string;
}
const createCirclePayment = async (
  params: CreateCirclePaymentParams
): Promise<Card> => {
  const data: Card = await fetch(config.apiUrl("/create-payment"), {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(params),
  }).then((response) => response.json());
  return data;
};

export default createCirclePayment;
