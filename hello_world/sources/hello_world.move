// Define a module named hello_world under the my_addrx address
module my_addrx::hello_world {
    // Import necessary modules and types
    use std::string;
    use aptos_std::table::{Self, Table};
    use std::signer;
    use aptos_framework::account;
    use aptos_framework::event::{Self, EventHandle};

    /// Error codes
    const E_MESSAGE_HOLDER_NOT_INITIALIZED: u64 = 1; // MessageHolder not initialized
    const E_MESSAGE_NOT_FOUND: u64 = 2; // Message not found

    // Define MessageHolder struct to store messages and events
    struct MessageHolder has key {
        message: Table<address, string::String>, // Store mapping from address to message
        set_message_events: EventHandle<MessageSetEvent>, // Handle set message events
    }

    // Define MessageSetEvent struct to record message setting events
    struct MessageSetEvent has drop, store {
        address: address, // Address setting the message
        message: string::String, // Content of the set message
    }

    // Public entry function to initialize MessageHolder
    public entry fun init_message_holder(account: &signer) {
        // Check if MessageHolder exists, if not, create it
        if (!exists<MessageHolder>(signer::address_of(account))) {
            move_to(account, MessageHolder {
                message: table::new(),
                set_message_events: account::new_event_handle<MessageSetEvent>(account),
            })
        }
    }

    // Public entry function to set a message
    public entry fun set_message(account: &signer, message: string::String) acquires MessageHolder {
        let addr = signer::address_of(account);
        // If MessageHolder doesn't exist, initialize it first
        if (!exists<MessageHolder>(addr)) {
            init_message_holder(account);
        };
        let message_holder = borrow_global_mut<MessageHolder>(addr);
        
        // Update or add the message
        if (table::contains(&message_holder.message, addr)) {
            *table::borrow_mut(&mut message_holder.message, addr) = message;
        } else {
            table::add(&mut message_holder.message, addr, message);
        };

        // Emit message set event
        event::emit_event(&mut message_holder.set_message_events, MessageSetEvent {
            address: addr,
            message: message,
        });
    }

    // Public view function to get a message
    #[view]
    public fun get_message(addr: address): string::String acquires MessageHolder {
        // Ensure MessageHolder is initialized
        assert!(exists<MessageHolder>(addr), E_MESSAGE_HOLDER_NOT_INITIALIZED);
        let message_holder = borrow_global<MessageHolder>(addr);
        // Ensure the message exists
        assert!(table::contains(&message_holder.message, addr), E_MESSAGE_NOT_FOUND);
        // Return the message
        *table::borrow(&message_holder.message, addr)
    }
}