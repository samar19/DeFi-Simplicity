import {
  Circle,
  CircleEnvironments,
  SubscriptionRequest,
} from "@circle-fin/circle-sdk";

const circle = new Circle(
  process.env.CIRCLE_TOKEN || "",
  CircleEnvironments.sandbox
);

async function createCheckoutSession(amount: string) {
  const createCheckoutSessionRes =
    await circle.checkoutSessions.createCheckoutSession({
      successUrl: "https://www.example.com/success",
      amount: {
        amount: amount || "1000",
        currency: "USD",
      },
    });
  console.log(createCheckoutSessionRes.data);
}

export default createCheckoutSession;
