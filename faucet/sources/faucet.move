module contract::faucet {
    use aptos_framework::fungible_asset::{
        Self,
        TransferRef,
        BurnRef,
        Metadata,
        FungibleAsset,
        MintRef
    };
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

    struct MyMintRef2 has key {
        admin: address,
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
            utf8(b"http://example.com") /* project */
        );

        let mint_ref = fungible_asset::generate_mint_ref(&constructor_ref);

        let transfer_ref = fungible_asset::generate_transfer_ref(&constructor_ref);

        let burn_ref = fungible_asset::generate_burn_ref(&constructor_ref);

        move_to(
            contract,
            MyMintRef { mint_ref }
        );

        move_to(
            contract,
            MyBurnRef { burn_ref }
        );

        move_to(
            contract,
            MyTransferRef { transfer_ref }
        );
    }

    entry fun create_fa (
        sender: &signer
    ){
        let constructor_ref = object::create_named_object(sender, ASSET_SYMBOL);
        primary_fungible_store::create_primary_store_enabled_fungible_asset(
            &constructor_ref,
            option::none(),
            utf8(b"FA2 Coin"), /* name */
            utf8(b"FA2"), /* symbol */
            8, /* decimals */
            utf8(b"http://example.com/favicon.ico"), /* icon */
            utf8(b"http://example.com"), /* project */
        );

        let mint_ref = fungible_asset::generate_mint_ref(&constructor_ref);


        let transfer_ref = fungible_asset::generate_transfer_ref(&constructor_ref);


        let burn_ref = fungible_asset::generate_burn_ref(&constructor_ref);

        move_to(
            sender,
            MyMintRef2 {
                admin: signer::address_of(sender),
                mint_ref
            }
        );

        move_to(
            sender,
            MyBurnRef {
                burn_ref
            }
        );

        move_to(
            sender,
            MyTransferRef {
                transfer_ref
            }
        );
    }

    entry fun faucet(sender: &signer, amount: u64) acquires MyMintRef {
        let my_mint_ref = borrow_global<MyMintRef>(@contract);
        let fa = fungible_asset::mint(&my_mint_ref.mint_ref, amount);
        primary_fungible_store::deposit(signer::address_of(sender), fa);
    }

    entry fun mint(
        sender: &signer,
        amount: u64
    ) acquires MyMintRef2 {
        let my_mint_ref2 = borrow_global<MyMintRef2>(signer::address_of(sender));
        assert!(
            my_mint_ref2.admin == signer::address_of(sender),
            123
        );
        let fa  = fungible_asset::mint(&my_mint_ref2.mint_ref, amount);
        primary_fungible_store::deposit( signer::address_of(sender), fa);
    }

    #[view]
    /// Get the balance of `account`'s primary store.
    public fun balance<T: key>(account: address, metadata: Object<T>): u64 {
        primary_fungible_store::balance(account, metadata)
    }

    #[view]
    public fun is_balance_at_least<T: key>(
        account: address, metadata: Object<T>, amount: u64
    ): bool {
        primary_fungible_store::is_balance_at_least(account, metadata, amount)
    }

    #[test]
    fun test() acquires MyMintRef {
        let user_signer = account::create_account_for_test(@contract);
        init_module(&user_signer);

        let user1_signer = account::create_account_for_test(@0x12345);
        faucet(&user1_signer, 1 * 1000 * 1000 * 100);
    }

    #[test]
    fun test_mint() acquires MyMintRef2 {
        let user_signer = account::create_account_for_test(@contract);
        create_fa(&user_signer);
        mint(&user_signer, 1 * 1000 * 1000 * 100);
        mint(&user_signer, 1 * 1000 * 1000 * 100);
    }
}
