import fetch from "node-fetch";

const url = "https://api-sandbox.circle.com/v1/encryption/public";
const options = {
  method: "GET",
  headers: {
    accept: "application/json",
    Authorization: `Bearer ${process.env.CIRCLE_TOKEN}`,
  },
};

interface PCIPublicKeyResponse {
  data: {
    keyId: string;
    publicKey: string;
  };
}
const getPCIPublicKey = async (): Promise<PCIPublicKeyResponse> => {
  const response: PCIPublicKeyResponse = await fetch(url, options).then(
    (res: any) => res.json()
  );
  return response;
};

export default getPCIPublicKey;
