module lesson10::MyObject {
    use std::signer;
    use aptos_framework::object;
    use aptos_framework::object::{Object, ObjectGroup};

    // resource
    #[resource_group_member(group = ObjectGroup)]
    struct MyStruct has key {
        num: u8
    }

    #[resource_group_member(group = ObjectGroup)]
    struct YourStruct has key {
        bools: bool
    }

    // Extensibility
    #[resource_group_member(group = ObjectGroup)]
    struct ExtendRef has key {
        extend_ref: object::ExtendRef
    }

    #[resource_group_member(group = ObjectGroup)]
    struct TransferRef has key {
        transfer_ref: object::TransferRef
    }

    #[resource_group_member(group = ObjectGroup)]
    struct DeleteRef has key {
        delete_ref: object::DeleteRef
    }

    entry fun create(caller: &signer) {
        let caller_address = signer::address_of(caller);
        let obj_ref = object::create_object(caller_address);
        let obj_signer = object::generate_signer(&obj_ref);

        let obj_extend_ref = object::generate_extend_ref(&obj_ref);
        let obj_transfer_ref = object::generate_transfer_ref(&obj_ref);
        let obj_delete_ref = object::generate_delete_ref(&obj_ref);

        move_to(&obj_signer, MyStruct { num: 42 });
        move_to(&obj_signer, ExtendRef { extend_ref: obj_extend_ref });
        move_to(&obj_signer, TransferRef { transfer_ref: obj_transfer_ref });
        move_to(&obj_signer, DeleteRef { delete_ref: obj_delete_ref });
    }

    entry fun add_struct(obj: Object<MyStruct>) acquires ExtendRef {
        let obj_addr = object::object_address(&obj);
        let obj_extend_ref = &borrow_global<ExtendRef>(obj_addr).extend_ref;
        let obj_signer = object::generate_signer_for_extending(obj_extend_ref);

        move_to(&obj_signer, YourStruct { bools: true })
    }

    entry fun transfer(owner: &signer, obj: Object<MyStruct>, to: address) {
        object::transfer(owner, obj, to);
    }

    entry fun switch_transfer(obj: Object<MyStruct>) acquires TransferRef {
        let obj_addr = object::object_address(&obj);
        let obj_transfer_ref = &borrow_global<TransferRef>(obj_addr).transfer_ref;

        if (object::ungated_transfer_allowed(obj)) {
            object::disable_ungated_transfer(obj_transfer_ref);
        } else {
            object::enable_ungated_transfer(obj_transfer_ref);
        }
    }

    entry fun delete(owner: &signer, obj: Object<MyStruct>) acquires DeleteRef {
        let obj_addr = object::object_address(&obj);
        let DeleteRef { delete_ref }  = move_from<DeleteRef>(obj_addr);

        object::delete(delete_ref);
    }

    entry fun update(caller: &signer, obj_addr: address, num: u8) acquires MyStruct {
        let obj_ref = borrow_global_mut<MyStruct>(obj_addr);
        obj_ref.num = num;
    }

    #[view]
    public fun query(obj_addr: address): u8 acquires MyStruct {
        let obj_ref = borrow_global<MyStruct>(obj_addr);
        obj_ref.num
    }

    #[view]
    public fun owner(obj: Object<MyStruct>): address {
        object::owner(obj)
    }
}
