#import "../src/contracts/main.mligo" "Main"
#import "./helpers/bootstrap.mligo" "Bootstrap"
#import "./helpers/helper.mligo" "Helper"





let test_successful_originate =
    let accounts = Bootstrap.boot_accounts(Tezos.get_now()) in
    let (_, taddr, _) = Bootstrap.originate_contract(Bootstrap.base_storage) in
    let () = Test.set_source(accounts.0) in
    let init_store = Helper.get_storage(taddr) in
    let () = Test.println(Test.to_string(init_store)) in
    assert(init_store = Bootstrap.base_storage)

let test_successful_increment =
    let accounts = Bootstrap.boot_accounts(Tezos.get_now()) in
    let (_, taddr, contr) = Bootstrap.originate_contract(Bootstrap.base_storage) in
    let () = Test.set_source(accounts.0) in
    let () = assert(Bootstrap.base_storage = Helper.get_storage(taddr)) in
    let result = Helper.call_increment(3, contr) in
    let () = Test.println(Test.to_string(result)) in
    let modified_store = Helper.get_storage(taddr) in
    let () = Test.println(Test.to_string(modified_store)) in
    assert(modified_store = Bootstrap.base_storage + 3)
