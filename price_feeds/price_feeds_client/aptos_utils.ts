import {
  Ed25519PrivateKey,
  Aptos,
  AptosConfig,
  Network,
  NetworkToNetworkName,
} from "@aptos-labs/ts-sdk";
import dotenv from "dotenv";

dotenv.config();
// console.log(process.env)

const APTOS_NETWORK: Network = NetworkToNetworkName[Network.TESTNET];
const config = new AptosConfig({ network: APTOS_NETWORK });
const aptos = new Aptos(config);
console.log("Aptos client initialized:", aptos.account.config.network);

const OWNER_PRIVATE_KEY = process.env.PRIVATE_KEY!;
// console.log(OWNER_PRIVATE_KEY);

const getSigner = async () => {
  const privateKey = new Ed25519PrivateKey(OWNER_PRIVATE_KEY);
  const signer = await aptos.deriveAccountFromPrivateKey({ privateKey });
  return signer;
};

export { aptos, getSigner };
