const amountIsValid = (amount: string) => {
  if (amount.trim() === "") {
    return false;
  } else if (isNaN(Number(amount))) {
    return false;
  } else if (Number(amount) <= 0) {
    return false;
  }
  return true;
};

export default amountIsValid;
