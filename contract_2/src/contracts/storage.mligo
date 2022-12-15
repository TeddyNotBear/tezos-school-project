type coin = {
    id : string;
    name: string;
    symbol: string;
    rank: nat
}

type coins_mapping = (nat, coin) map

type t = {
    last_index : nat;
    coins_map : coins_mapping
}

type return = operation list * t