#import "../../src/contracts/main.mligo" "Main"
#import "../../src/contracts/parameter.mligo" "Parameter"
#import "assert.mligo" "Assert"

type taddr = (Main.parameter, Main.storage) typed_address
type contr = Main.parameter contract

let get_storage(taddr : taddr) =
    Test.get_storage taddr

let call (p, contr : Main.parameter * contr) =
    Test.transfer_to_contract contr (p) 0mutez

//AddAdmin functions
let call_add_admin(p, contr : Parameter.add_admin_param * contr) =
    call(AddAdmin(p), contr)

let call_add_admin_success (p, contr : Parameter.add_admin_param * contr) =
    Assert.tx_success (call_add_admin(p, contr))
