import { aptos, getSigner } from "./aptos_utils";

const ACCOUNT =
  "c327fa8bef56e4a0d1d82d6fdac8ddf4e0d31a907836810081cffa67c21601ee";
const MODULE_NAME = "price_feeds";

const writeModuleFunction = async (price: string, symbol: string) => {
  const signer = await getSigner();
  const txn = await aptos.transaction.build.simple({
    sender: signer.accountAddress,
    data: {
      function: `${ACCOUNT}::${MODULE_NAME}::update_feed`,
      typeArguments: [],
      functionArguments: [price, symbol],
    },
  });

  const committedTxn = await aptos.signAndSubmitTransaction({
    signer: signer,
    transaction: txn,
  });

  await aptos.waitForTransaction({ transactionHash: committedTxn.hash });
  console.log(`Committed transaction: ${committedTxn.hash}\n`);
};

writeModuleFunction("66000", "BTC");
