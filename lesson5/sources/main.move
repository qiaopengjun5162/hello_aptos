address 0x42 {
module m {
    friend 0x42::m2;

    fun f1(): u64 {
        1
    }

    public fun f2(): u64 {
        2
    }

    public(friend) fun f3(): u64 {
        3
    }
}

module n {
    fun f1(): u64 {
        // 0x42::m::f1()
        0x42::m::f2()
    }
}

module m2 {
    use 0x42::m::f2;
    use 0x42::m::f3;
    fun f1(): u64 {
        f2() + f3()
    }
}
}
