module MyPackage::m2 {
    use std::debug::{print as P, print};

    #[test]
    fun test() {
        use MyPackage::m1::num;

        let n = num();
        print(&n);
    }

    #[test]
    fun test1() {
        let n = 2;
        print(&n);
        P(&n);
    }

    #[test]
    fun test2() {
        use MyPackage::m1::num2;
        let n = num2();
        print(&n);
    }
}
