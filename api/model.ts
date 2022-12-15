export interface Coin {
    id: string;
    name: string;
    symbol: string;
    rank: number;
}

export function ToCoin(item: {[key: string]: any}): Coin | undefined {
    if(typeof item["id"] === 'string' &&
        typeof item["name"] === 'string' &&
        typeof item["symbol"] === 'string' &&
        typeof item["rank"] === 'number' 
        ) {
        return {
            id: item["id"],
            name: item["name"],
            symbol: item["symbol"],
            rank: item["rank"]
        }
    }
    return undefined;
}