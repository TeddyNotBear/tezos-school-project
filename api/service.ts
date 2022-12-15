import axios, {CancelToken} from "axios";
import { Coin, ToCoin } from "./model";

export class CoinpaprikaService {

    static async getCryptocurrencyById(coin_id: string, cancelToken?: CancelToken): Promise<Coin | undefined> {
        const response = await axios.get(`https://api.coinpaprika.com/v1/coins/${coin_id}`, {
            cancelToken
        });
        if(response.data) {
            return ToCoin(response.data);
        } else {
            return undefined;
        }
    }
}