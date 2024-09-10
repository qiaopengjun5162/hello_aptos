module 0x42::Types {
    use std::debug::print;
    use std::string;
    use std::string::{String, utf8};

    #[test]
    fun test_num() {
        let num_u8: u8 = 42; // 0~2**8-1
        let num_u8_2 = 43u8;
        let num_u8_3 = 0x2A; // hash

        let num_u256: u256 = 100_000;

        let num_sum = (num_u8 as u256) + num_u256;
        print(&num_u8);
        print(&num_u8_2);
        print(&num_u8_3);
        print(&num_u256);
        print(&num_sum);
    }

    #[test]
    fun test_bool() {
        let bool_true: bool = true;
        let bool_false: bool = false;
        print(&bool_true);
        print(&bool_false);
        print(&(bool_true == bool_false));
    }

    #[test]
    fun test_string() {
        let str: String = utf8(b"Hello, Move!");
        print(&str);
    }

    #[test]
    fun test_addr() {
        let addr: address = @0x42;
        let addr_2: address = @0x00000000000000000000000000000000000000000A;

        print(&addr);
        print(&addr_2);
    }
}
