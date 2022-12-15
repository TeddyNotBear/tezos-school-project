#import "storage.mligo" "Storage"
#import "parameter.mligo" "Parameter"
#import "errors.mligo" "Errors"

type action = 
    | SetData of Parameter.set_data_param
    | GetData of Parameter.get_data_param

let set_data (set_data_parameter, s : Parameter.set_data_param * Storage.t) : Storage.t =
    let returned_data_map : (nat, Storage.coin) map = Map.add s.last_index set_data_parameter s.coins_map in
    let new_index : nat = (s.last_index + 1n) in
    { s with last_index = new_index; coins_map = returned_data_map }

[@view] 
let get_data (get_data_paramater, s : Parameter.get_data_param * Storage.t) : Storage.t =
    let coins_map : Storage.coins_mapping = match Map.find_opt get_data_paramater s.coins_map with
        Some _ -> s.coins_map
        | None -> failwith Errors.bad_id
    in
    {s with coins_map}

let main (a, s : action * Storage.t) : Storage.return =
    let new_s : Storage.t = match a with
                            SetData (p) -> 
                                set_data (p, s)
                            | GetData (p) ->
                                get_data (p, s)
                            in
    (([] : operation list), new_s)