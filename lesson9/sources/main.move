module 0x42::myObject {
    use std::debug::print;
    use std::signer;
    use aptos_framework::object;
    use aptos_framework::object::{Object, ConstructorRef, ObjectCore};

    const NAME: vector<u8> = b"myObject";

    // deleteable object
    public fun createDeleteableObject(caller: &signer): ConstructorRef {
        let caller_address = signer::address_of(caller);
        let obj = object::create_object(caller_address);
        obj
    }

    // undeleteable object
    public fun createNamedObject(caller: &signer): ConstructorRef {
        let obj = object::create_named_object(caller, NAME);
        obj
    }

    // sticky object
    public fun createStickyObject(caller: &signer): ConstructorRef {
        let caller_address = signer::address_of(caller);
        let obj = object::create_sticky_object(caller_address);
        obj
    }

    #[test(caller = @0x42)]
    fun testCreateDeleteableObject(caller: &signer) {
        let obj = createDeleteableObject(caller);
        print(&obj);
    }

    #[test(caller = @0x42)]
    fun testCreateNamedObject(caller: &signer) {
        let obj = createNamedObject(caller);
        // let obj2 = createNamedObject(caller);
        print(&obj);
        // print(&obj2);
    }

    #[test(caller = @0x42)]
    fun testCreateStickyObject(caller: &signer) {
        let obj = createStickyObject(caller);
        let obj2 = createStickyObject(caller);
        print(&obj);
        print(&obj2);
    }
}
