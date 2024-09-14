module 0x42::Demo3 {
    use std::debug;

    #[test]
    fun test_if() {
        let x = 5;
        let x2 = 10;
        if (x == 5) {
            debug::print(&x);
        } else {
            debug::print(&x2);
        }
    }

    #[test]
    fun test_while() {
        let x = 0;
        while (x < 10) {
            debug::print(&x);
            x = x + 1;
        }
    }

    #[test]
    fun test_while2() {
        let x = 5;
        while (x < 10) {
            debug::print(&x);
            x = x + 1;

            if (x == 7) {
                break;
            }
        }
    }

    #[test]
    fun test_while3() {
        let x = 5;
        while (x < 10) {
            x = x + 1;
            if (x == 7) {
                continue;
            };
            debug::print(&x);
        }
    }

    #[test]
    fun test_loop() {
        let x = 5;
        loop {
            x = x + 1;
            if (x == 7) {
                break;
            };
            debug::print(&x);
        }
    }

    #[test]
    fun test_loop2() {
        let x = 5;
        loop {
            x = x + 1;
            if (x == 7) {
                continue;
            };
            if (x == 10) {
                break;
            };
            debug::print(&x);
        }
    }
}
