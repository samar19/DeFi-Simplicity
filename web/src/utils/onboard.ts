import config from "../config";

const onboard = async (address: string): Promise<void> => {
  await fetch(config.apiUrl("/onboard"), {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      address,
    }),
  }).then((response) => response.json());
};

export default onboard;
