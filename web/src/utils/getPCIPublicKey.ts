import config from "../config";

interface PCIPublicKeyResponse {
  data: {
    keyId: string;
    publicKey: string;
  };
}
const getPCIPublicKey = async (): Promise<PCIPublicKeyResponse> => {
  const data: PCIPublicKeyResponse = await fetch(
    config.apiUrl("/pci-public-key")
  ).then((response) => response.json());
  return data;
};

export default getPCIPublicKey;
