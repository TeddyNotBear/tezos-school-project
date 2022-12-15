#import "storage.mligo" "Storage"
#import "parameter.mligo" "Parameter"
#import "errors.mligo" "Errors"

type action = 
    AddAdmin of Parameter.add_admin_param
    | RemoveAdmin of Parameter.remove_admin_param
    | WriteMsg of Parameter.write_msg_param
    | AcceptInvitation of Parameter.accept_invitation_param
    | Participate of unit

let assert_admin (_assert_admin_param, s : Parameter.assert_admin_param * Storage.t) : unit = 
    if (Tezos.get_sender() <> s.admin)
    then (failwith Errors.not_admin)
    else () 

let assert_participating(s : Storage.t) : unit =
    let (sender : address) = Tezos.get_sender() in
    let res = match Map.find_opt sender s.participate_map with
            Some _ -> ()
            | None -> (failwith Errors.validation_uncompleted)
        in
    (res)

let add_admin (add_admin_parameter, s : Parameter.add_admin_param * Storage.t) : Storage.t =
    let admin_map : Storage.admin_mapping =
        match Map.find_opt add_admin_parameter s.admin_map with
            Some _ -> Map.update add_admin_parameter (Some (Waiting : Storage.status)) s.admin_map
            | None -> Map.add add_admin_parameter (Waiting : Storage.status) s.admin_map
        in
    { s with admin_map }

let accept_invitation (accept_invitation_parameter, s : Parameter.accept_invitation_param * Storage.t) : Storage.t =
    let (sender : address) = Tezos.get_sender() in
    let admin_map : Storage.admin_mapping =
        match Map.find_opt sender s.admin_map with
            Some _ -> (
                    match accept_invitation_parameter with 
                        | Waiting -> Map.update sender (Some (accept_invitation_parameter)) s.admin_map
                        | Accepted -> failwith Errors.already_accepted
                        | Refused -> failwith Errors.already_refused
                )
            | None -> (failwith Errors.empty_invitation)
        in
    { s with admin_map }

let remove_admin (remove_admin_parameter, s : Parameter.remove_admin_param * Storage.t ) : Storage.t =
    let admin_map : Storage.admin_mapping =
        match Map.find_opt remove_admin_parameter s.admin_map with
            Some _ -> Map.remove remove_admin_parameter s.admin_map
            | None -> failwith Errors.admin_not_exist
        in
    { s with admin_map }

let participate_contract (s : Storage.t) : Storage.t =
    let sender = (Tezos.get_sender()) in
    let amount = (Tezos.get_amount()) in
    let participate_map : Storage.participate_mapping =
        match Map.find_opt sender s.participate_map with
            | Some _ -> s.participate_map
            | None -> if (Tezos.get_amount () > 1tez)
                then (Map.add sender amount s.participate_map)
                else (failwith Errors.not_enough_money)
        in
    { s with participate_map }

let write_msg (write_msg_parameter, s : Parameter.write_msg_param * Storage.t) : Storage.t =
    let sender = (Tezos.get_sender()) in
    let user_map : Storage.mapping = 
        match Map.find_opt sender s.user_map with
            Some _ -> Map.update sender (Some ((write_msg_parameter, (Bronze : Storage.tier)))) s.user_map
            | None -> Map.add sender (write_msg_parameter, (Bronze : Storage.tier)) s.user_map
        in
    { s with user_map }

let main (a, s : action * Storage.t) : Storage.return =
    let new_s : Storage.t = match a with
                            AddAdmin (p) -> 
                                let _ : unit = assert_admin ((), s) in
                                add_admin (p, s)
                            | RemoveAdmin (p) ->
                                let _ : unit = assert_admin ((), s) in
                                remove_admin (p, s)
                            | AcceptInvitation (p) ->
                                accept_invitation (p, s)
                            | WriteMsg (p) ->
                                write_msg (p, s)
                            | Participate ->
                                let _ : unit = assert_participating(s) in
                                participate_contract (s)
                            in
    (([] : operation list), new_s)