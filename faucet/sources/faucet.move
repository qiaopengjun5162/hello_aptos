module contract::faucet {
    use aptos_framework::fungible_asset::{Self, TransferRef, BurnRef, Metadata, FungibleAsset, MintRef};
    use aptos_framework::object::{Self, Object};
    use aptos_framework::primary_fungible_store;
    use std::string::utf8;
    use std::option;
    use std::signer;
    #[test_only]
    use aptos_framework::account;

    const ASSET_SYMBOL: vector<u8> = b"FA";

    struct MyMintRef has key {
        mint_ref: MintRef
    }

    struct MyTransferRef has key {
        transfer_ref: TransferRef
    }

    struct MyBurnRef has key {
        burn_ref: BurnRef
    }

    fun init_module(contract: &signer) {
        let constructor_ref = object::create_named_object(contract, ASSET_SYMBOL);
        primary_fungible_store::create_primary_store_enabled_fungible_asset(
            &constructor_ref,
            option::none(),
            utf8(b"FA Coin"), /* name */
            utf8(ASSET_SYMBOL), /* symbol */
            8, /* decimals */
            utf8(b"http://example.com/favicon.ico"), /* icon */
            utf8(b"http://example.com"), /* project */
        );

        let mint_ref = fungible_asset::generate_mint_ref(&constructor_ref);


        let transfer_ref = fungible_asset::generate_transfer_ref(&constructor_ref);


        let burn_ref = fungible_asset::generate_burn_ref(&constructor_ref);

        move_to(
            contract,
            MyMintRef {
                mint_ref
            }
        );

        move_to(
            contract,
            MyBurnRef {
                burn_ref
            }
        );

        move_to(
            contract,
            MyTransferRef {
                transfer_ref
            }
        );
    }

    entry fun faucet(
        sender: &signer,
        amount: u64
    ) acquires MyMintRef {
        let my_mint_ref = borrow_global<MyMintRef>(@contract);
        let fa  = fungible_asset::mint(&my_mint_ref.mint_ref, amount);
        primary_fungible_store::deposit( signer::address_of(sender), fa);
    }

    #[test]
    fun test() acquires MyMintRef {
        let user_signer = account::create_account_for_test(@contract);
        init_module(&user_signer);

        let user1_signer = account::create_account_for_test(@0x12345);
        faucet(
            &user1_signer,
            1 * 1000 * 1000 * 100
        );
    }
}
