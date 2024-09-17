module tester::random {
    use std::signer;
    use aptos_std::table::{Self, Table};
    use aptos_framework::event;
    use aptos_framework::randomness;

    const E_RANDOM_DATA_NOT_INITIALIZED: u64 = 1;
    const E_MESSAGE_NOT_FOUND: u64 = 2; // random_data not found


    #[event]
    struct Event<T> has drop, store {
        value: T
    }

    struct Random_data has key {
        message: Table<address, u64>
    }

    #[randomness]
    entry fun random_u8() {
        event::emit(Event {
            value: randomness::u8_integer()
        })
    }

    public entry fun init_random_data(account: &signer) {
        if (!exists<Random_data>(signer::address_of(account))) {
            move_to(account, Random_data {
                message: table::new()
            })
        }
    }

    #[randomness]
    entry fun set_random_u64(account: &signer, n: u64) acquires Random_data{
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

        event::emit(Event {
            value: r
        })
    }

    #[view]
    public fun get_random_data(addr: address): u64 acquires Random_data {
        assert!(exists<Random_data>(addr), E_RANDOM_DATA_NOT_INITIALIZED);
        let random_data_info = borrow_global<Random_data>(addr);

        assert!(table::contains(&random_data_info.message, addr), E_MESSAGE_NOT_FOUND);

        *table::borrow(&random_data_info.message, addr)
    }
}