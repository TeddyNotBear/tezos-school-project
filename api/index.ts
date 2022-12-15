import { TezosToolkit } from "@taquito/taquito";
import axios, {CancelToken} from "axios";
import { CoinpaprikaService } from "./service";

const Tezos = new TezosToolkit('https://rpc.tzkt.io/limanet');

const cancelTokenSrc = axios.CancelToken.source();

Tezos.contract
  .at('')
  .then((contract) => {
    print("Set BTC data in the Smart-Contract");
    return contract.methods.set_data(CoinpaprikaService.getCryptocurrencyById('btc-bitcoin', cancelTokenSrc.token)).send();
  })
  .then((op) => {
    print("Waiting for ${op.hash} to be confirmed...");
    return op.confirmation(3).then(() => op.hash);
  })
  .then((hash) => print("Operation injected: https://rpc.tzkt.io/limanet"))
  .catch((error) => print("Error"));