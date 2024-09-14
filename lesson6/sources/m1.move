module MyPackage::m1 {
    use std::debug::{print as P, print};
    friend MyPackage::m2;
    friend MyPackage::m3;


    public fun num(): u64 {
        66
    }

    public(friend) fun num2(): u64 {
        77
    }

    public(friend) fun num3(): u64 {
        88
    }

    #[test]
    fun test1() {
        let n = 1;
        print(&n);
        P(&n);
    }
}
