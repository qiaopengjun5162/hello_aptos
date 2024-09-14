module MyPackage::m3 {
    use std::debug::{print as P, print};

    #[test]
    fun test() {
        use MyPackage::m1::num;

        let n = num();
        print(&n);
    }

    #[test]
    fun test1() {
        let n = 3;
        print(&n);
        P(&n);
    }

    #[test]
    fun test2() {
        use MyPackage::m1::num3;
        let n = num3();
        print(&n);
    }
}
