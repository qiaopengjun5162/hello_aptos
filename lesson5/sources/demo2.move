module 0x42::Demo2 {
    use std::debug;
    use std::signer;

    // drop
    struct Foo has drop {
        u: u64,
        b: bool
    }

    #[test]
    fun test() {
        let f = Foo { u: 42, b: true };
        // let Foo { u, b } = f;
        // debug::print(&u);
        // debug::print(&b);

        debug::print(&f.u);
        debug::print(&f.b);
    }

    #[test]
    fun test2() {
        let f = Foo { u: 42, b: true };
        let Foo { u, b } = f;
        debug::print(&u);
        debug::print(&b);
    }

    #[test]
    fun test3() {
        let f = Foo { u: 42, b: true };
        let Foo { u, b } = &mut f;
        *u = 43;
        debug::print(&f.u);
        debug::print(&f.b);
    }

    // copy
    struct CanCopy has copy, drop {
        u: u64,
        b: bool
    }

    #[test]
    fun test4() {
        let b1 = CanCopy { u: 42, b: true };
        let b2 = copy b1;
        let CanCopy { u, b } = &mut b2;
        *u = 43;
        debug::print(&b1.u);
        debug::print(&b2.u);

    }

    // store
    struct Key has key, drop {
        s: Struct
    }

    struct Struct has store, drop {
        x: u64
    }

    #[test]
    fun test5() {
        let k = Key { s: Struct { x: 42 } };
        debug::print(&k.s.x);
        let Struct { x } = &mut k.s;
        *x = 43;
        debug::print(&k.s.x);
    }
}
