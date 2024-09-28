module contract::nft {
    use aptos_token_objects::collection;
    use std::option::Self;
    use std::string;
    use aptos_token_objects::token;
    use aptos_framework::object::{Self, Object};

    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    /// The ambassador token
    struct NFTToken has key {
        /// Used to mutate the token uri
        mutator_ref: token::MutatorRef,
        /// Used to burn.
        burn_ref: token::BurnRef
    }

    public entry fun create_collection(creator: &signer) {
        let max_supply = 1000;
        let royalty = option::none();

        // Maximum supply cannot be changed after collection creation
        collection::create_fixed_collection(
            creator,
            string::utf8(b"My Collection Description"),
            max_supply,
            string::utf8(b"Qiao Collection"),
            royalty,
            string::utf8(
                b"https://learnblockchain.cn/image/avatar/18602_middle.jpg?GjIyGZqa"
            )
        );
    }

    public entry fun mint_token(creator: &signer) {
        let royalty = option::none();
        let token_constructor_ref =
            token::create(
                creator,
                string::utf8(b"Qiao Collection"),
                string::utf8(b"My NFT Description"),
                string::utf8(b"QiaoToken"),
                royalty,
                string::utf8(
                    b"https://img.learnblockchain.cn/space/banner/18602/h7ljMtGq668b998356db8.jpg"
                )
            );

        let object_signer = object::generate_signer(&token_constructor_ref);

        let burn_ref = token::generate_burn_ref(&token_constructor_ref);

        let mutator_ref = token::generate_mutator_ref(&token_constructor_ref);

        let nft_token = NFTToken { mutator_ref, burn_ref };
        move_to(&object_signer, nft_token);
    }

    public entry fun burn(token: Object<NFTToken>) acquires NFTToken {
        let ambassador_token = move_from<NFTToken>(object::object_address(&token));
        let NFTToken { mutator_ref: _, burn_ref } = ambassador_token;

        token::burn(burn_ref);
    }
}
