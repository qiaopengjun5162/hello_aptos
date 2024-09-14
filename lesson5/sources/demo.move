module 0x42::Demo {
    use std::debug;
    use std::signer;

    struct Coin has key {
        value: u64
    }

    public entry fun mint(amount: &signer, value: u64) {
        move_to(amount, Coin { value });
    }

    #[test(account = @0x42)]
    public fun mint_test(account: &signer) acquires Coin {
        let addr = signer::address_of(account);
        mint(account, 100);
        let coin = borrow_global<Coin>(addr).value;

        debug::print(&coin);
        assert!(borrow_global<Coin>(addr).value == 100, 1);
    }
}
