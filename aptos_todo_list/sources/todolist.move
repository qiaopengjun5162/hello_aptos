module todolist_addr::todolist {
    use std::bcs;
    use std::signer;
    use std::string::String;
    use std::vector;
    use aptos_std::string_utils;
    use aptos_std::table::Table;
    use aptos_framework::event;
    use aptos_framework::object;

    // <address>::<module_name>

    /// Todo list does not exist
    const E_TODO_LIST_DOSE_NOT_EXIST: u64 = 1;
    /// Todo does not exist
    const E_TODO_DOSE_NOT_EXIST: u64 = 2;
    /// Todo is already completed
    const E_TODO_ALREADY_COMPLETED: u64 = 3;

    struct UserTodoListCounter has key {
        counter: u64,
    }

    struct TodoList has key {
        owner: address,
        todos: vector<Todo>,
    }

    struct Todo has store, drop, copy {
        content: String,
        completed: bool,
    }

    public entry fun create_todo_list(sender: &signer) acquires UserTodoListCounter {
        let sender_address = signer::address_of(sender);
        let counter = if (exists<UserTodoListCounter>(sender_address)) {
            let counter = borrow_global<UserTodoListCounter>(sender_address);
            counter.counter
        } else {
            let counter = UserTodoListCounter { counter: 0 };
            // store the UserTodoListCounter resource directly under the sender
            move_to(sender, counter);
            0
        };

        let obj_holds_todo_list = object::create_named_object(
            sender,
            construct_todo_list_object_seed(counter),
        );
        let obj_signer = object::generate_signer(&obj_holds_todo_list);
        let todo_list = TodoList {
            owner: sender_address,
            todos: vector::empty(),
        };
        move_to(&obj_signer, todo_list);
        let counter = borrow_global_mut<UserTodoListCounter>(sender_address);
        counter.counter = counter.counter + 1;
    }

    public entry fun create_todo(sender: &signer, todo_list_idx: u64, content: String) acquires TodoList {
        let sender_address = signer::address_of(sender);
    }

    fun construct_todo_list_object_seed(counter: u64): vector<u8> {
        bcs::to_bytes(&string_utils::format2(&b"{}_{}", @todolist_addr, counter))
    }

}
