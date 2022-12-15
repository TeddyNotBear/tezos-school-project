type user = address
type admin = user
type msg = string

type tier = Platinum | Gold | Silver | Bronze
type status = Waiting | Accepted | Refused

type mapping = (user, (msg * tier) ) map
type admin_mapping = (user, status) map
type participate_mapping = (user, tez) map

type t = {
    admin : address;
    user_map : mapping;
    admin_map : admin_mapping;
    participate_map : participate_mapping
}

type return = operation list * t