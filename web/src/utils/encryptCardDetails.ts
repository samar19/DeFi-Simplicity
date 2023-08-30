import { createMessage, encrypt, readKey } from "openpgp";
import getPCIPublicKey from "./getPCIPublicKey";

// Object to be encrypted
interface CardDetails {
  number?: string;
  cvv?: string;
}

// Encrypted result
interface EncryptedValue {
  encryptedData: string;
  keyId: string;
}

const encryptCardDetails = async () => {
  const pciEncryptionKey = await getPCIPublicKey();

  /**
   * Encrypt card data function
   */
  return async function (dataToEncrypt: CardDetails): Promise<EncryptedValue> {
    const decodedPublicKey = await readKey({
      armoredKey: atob(pciEncryptionKey.data.publicKey),
    });
    const message = await createMessage({
      text: JSON.stringify(dataToEncrypt),
    });
    //@ts-ignore
    return encrypt({
      message,
      encryptionKeys: decodedPublicKey,
    }).then((ciphertext) => {
      return {
        //@ts-ignore
        encryptedData: btoa(ciphertext),
        keyId: pciEncryptionKey.data.keyId,
      };
    });
  };
};

export default encryptCardDetails;
