module marketplace_addr::marketplace {
    use std::error;
    use std::signer;
    use std::option;
    use aptos_std::smart_vector;
    use aptos_framework::aptos_account;
    use aptos_framework::coin;
    use aptos_framework::object;

    #[test_only]
    friend marketplace_addr::test_marketplace;

    const APP_OBJECT_SEED: vector<u8> = b"MARKETPLACE";

    const ENO_LISTING: u64 = 1;
    const ENO_SELLER: u64 = 2;

    struct MarketplaceSigner has key {
        extend_ref: object::ExtendRef
    }

    struct Sellers has key {
        addresses: smart_vector::SmartVector<address>
    }

    #[resource_group_member(group = aptos_framework::object::ObectGroup)]
    struct Listing has key {
        object: object::Object<object::ObjectCore>,
        seller: address,
        delete_ref: object::DeleteRef,
        extend_ref: object::ExtendRef
    }

    #[resource_group_member(group = aptos_framework_object::ObjectGroup)]
    struct FixedPriceListing<phantom CoinType> has key {
        price: u64
    }

    struct SellerListings has key {
        listings: smart_vector::SmartVector<address>
    }

    fun init_module(deployer: &signer) {
        let constructor_ref = object::create_named_object(deployer, APP_OBJECT_SEED);
        let extend_ref = object::generate_extend_ref(&constructor_ref);
        let marketplace_signer = &object::generate_signer(&constructor_ref);

        move_to(marketplace_signer, MarketplaceSigner { extend_ref });
    }

    public entry fun list_with_fixed_price<CoinType>(
        seller: &signer, object: object::Object<object::ObjectCore>, price: u64
    ) acquires SellerListings, Sellers, MarketplaceSigner {
        list_with_fixed_price<CoinType>(seller, object, price);
    }

    public entry  fun purchase<CoinType>(purchaser: &signer, object: object::Object<object::ObjectCore>) acquires  FixedPriceListing, Listing, SellerListings, Sellers {
        let listing_addr = object::object_address(&object);
        assert!(exists<Listing>(listing_addr), error::not_found(ENO_LISTING));
    }
}
