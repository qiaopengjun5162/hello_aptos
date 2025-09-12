import { aptos } from "./aptos_utils";
import { InputViewFunctionData } from "@aptos-labs/ts-sdk";

const ACCOUNT =
  "c327fa8bef56e4a0d1d82d6fdac8ddf4e0d31a907836810081cffa67c21601ee";
const MODULE_NAME = "price_feeds";

const viewModuleFunction = async (symbol: string) => {
  const payload: InputViewFunctionData = {
    function: `${ACCOUNT}::${MODULE_NAME}::get_token_price`,
    typeArguments: [],
    functionArguments: [symbol],
  };

  const result = await aptos.view({ payload });
  console.log(result);
  console.log(result[0]);

  return result;
};

viewModuleFunction("BTC");
