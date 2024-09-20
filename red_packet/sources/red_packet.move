module red_packet::red_packet {
    use aptos_framework::event;
    use aptos_framework::fungible_asset::{
        Self,
        MintRef,
        TransferRef,
        BurnRef,
        FungibleAsset
    };
    use aptos_framework::object::{Self, Object};
    use aptos_framework::primary_fungible_store;
    use std::signer;
    use std::string::utf8;
    use std::option;
    use aptos_framework::randomness;
    use aptos_std::table::{Self, Table};

    #[test_only]
    use aptos_framework::account;

    const SEED: vector<u8> = b"RedPacketFA";
    const E_RANDOM_DATA_NOT_INITIALIZED: u64 = 1;
    const E_MESSAGE_NOT_FOUND: u64 = 2; // random_data not found

    #[event]
    struct Event<T> has drop, store {
        value: T
    }

    struct Random_data has key {
        message: Table<address, u64>
    }

    struct MyMintRef has key {
        admin: address,
        mint_ref: MintRef
    }

    struct MyTransferRef has key {
        transfer_ref: TransferRef
    }

    struct MyBurnRef has key {
        burn_ref: BurnRef
    }

    fun init_module(admin: &signer) {
        let constructor_ref = object::create_named_object(admin, SEED);

        primary_fungible_store::create_primary_store_enabled_fungible_asset(
            &constructor_ref,
            option::none(),
            utf8(b"RedPacketFA Coin"),
            utf8(b"RPFA"),
            8,
            utf8(b"https://aptos.dev/docs/aptos-black.svg"),
            utf8(b"https://github.com/qiaopengjun5162")
        );

        let mint_ref = fungible_asset::generate_mint_ref(&constructor_ref);

        let transfer_ref = fungible_asset::generate_transfer_ref(&constructor_ref);

        let burn_ref = fungible_asset::generate_burn_ref(&constructor_ref);

        move_to(
            admin,
            MyMintRef { admin: signer::address_of(admin), mint_ref }
        );

        move_to(admin, MyBurnRef { burn_ref });

        move_to(admin, MyTransferRef { transfer_ref });
    }

    entry fun mint(sender: &signer, amount: u64) acquires MyMintRef {
        let my_mint_ref = borrow_global<MyMintRef>(@red_packet);
        let fa = fungible_asset::mint(&my_mint_ref.mint_ref, amount);
        primary_fungible_store::deposit(signer::address_of(sender), fa);
    }

    /// Check if the given signer is the admin.
    public fun is_owner(owner: &signer): bool acquires MyMintRef {
        let my_mint_ref = borrow_global<MyMintRef>(@red_packet);
        return my_mint_ref.admin == signer::address_of(owner)
    }

    public entry fun init_random_data(account: &signer) {
        if (!exists<Random_data>(signer::address_of(account))) {
            move_to(account, Random_data { message: table::new() })
        }
    }

    #[randomness]
    entry fun set_random_u64(account: &signer, n: u64) acquires Random_data {
        let addr = signer::address_of(account);
        if (!exists<Random_data>(addr)) {
            init_random_data(account);
        };
        let r = randomness::u64_range(0, n);
        let random_info = borrow_global_mut<Random_data>(addr);

        if (table::contains(&random_info.message, addr)) {
            *table::borrow_mut(&mut random_info.message, addr) = r;
        } else {
            table::add(&mut random_info.message, addr, r);
        };

        event::emit(Event { value: r })
    }

    public fun createRedPacket(
        numPackets: u64, fa: FungibleAsset, amount: u64
    ): u64 {
        //    1. transferFrom msg.serder address(this) amount
        //    2. Record create
        //    3. return redPacketId
        //    4 event
        let redPacketId: u64 = 1;
        redPacketId
    }

    public fun claimRedPacket(redPacketId: u64) acquires MyTransferRef {
        //    1. request random word
        //    2. Calculate the amount of the red envelope to be received   getRandomAmount
        //    3. record the claimer
        //    4. transferFrom this address(this) msg.sender amount
        //    5. event
    }

    fun getRandomAmount(
        remainingAmount: u64, remainingPackets: u64, randomness: u64
    ): u64 {
        if (remainingPackets == 1) {
            return remainingAmount;
        };

        let maxAmount = (remainingAmount / remainingPackets) * 2;
        return (randomness % maxAmount) + 1
    }

    #[view]
    public fun get_random_data(addr: address): u64 acquires Random_data {
        assert!(exists<Random_data>(addr), E_RANDOM_DATA_NOT_INITIALIZED);
        let random_data_info = borrow_global<Random_data>(addr);

        assert!(table::contains(&random_data_info.message, addr), E_MESSAGE_NOT_FOUND);

        *table::borrow(&random_data_info.message, addr)
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
        let user_signer = account::create_account_for_test(@red_packet);
        init_module(&user_signer);

        let user1_signer = account::create_account_for_test(@0x12345);
        mint(&user1_signer, 1 * 1000 * 1000 * 100);
    }
}
