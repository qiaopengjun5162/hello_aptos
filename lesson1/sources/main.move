module Lesson1::HelloWorld {
    #[test_only]
    use std::debug::print;
    #[test_only]
    use std::string::utf8;

    #[test]
    fun test_hello_world() {
        print(&utf8(b"hello world"));
    }
}
