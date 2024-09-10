module 0x42::Lesson2 {
    use std::debug::print;

    struct Wallet has drop {
        balance: u64
    }

    #[test]
    fun test_wallet() {
        let wallet = Wallet { balance: 1000 };
        let wallet2 = wallet; // move ownership

        // print(&wallet.balance);  // move ownership
        print(&wallet2.balance);

    }
}