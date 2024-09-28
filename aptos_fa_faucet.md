# **Aptos Move 实践指南：构建并部署同质化代币水龙头 (FA Faucet)**

在 Aptos 区块链上，Move 编程语言为开发者提供了强大的工具来创建、部署和管理代币。在本教程中，我们将使用 Aptos Move 创建和部署一个同质化代币（FA）水龙头合约，通过它，用户可以轻松铸造并接收代币。本教程适合对 Aptos 和 Move 有基础了解的开发者，并将通过实际代码示例一步步展示如何完成这一过程。



本文介绍了如何使用 Aptos Move 构建并部署一个同质化代币水龙头（FA Faucet）。文章详细讲解了如何创建不可删除的对象、生成权限引用、铸造代币并将其转移到指定账户。此外，还展示了项目的目录结构、Move.toml 文件配置以及智能合约的编写与测试过程。通过本教程，读者将能够掌握 Aptos Move 在代币创建和管理方面的关键技术，实现一个功能齐全的代币水龙头应用。

## Aptos FA  同质化代币 相关知识

### 创建新的可替代资产（FA）

从高层次来看，这是通过以下方式实现的：

1. 创建一个不可删除的对象来拥有新创建的可替代资产`Metadata`。
2. 生成`Ref`s 以启用任何所需的权限。
3. 铸造可替代资产并将其转移到您想要的任何账户。

At a high level, this is done by:

1. Creating a non-deletable Object to own the newly created Fungible Asset `Metadata`.
2. Generating `Ref`s to enable any desired permissions.
3. Minting Fungible Assets and transferring them to any account you want to.

To create an FA, first you need to create a **non-deletable Object** since destroying the metadata for a Fungible Asset while there are active balances would not make sense. You can do that by either calling `object::create_named_object(caller_address, NAME)` or `object::create_sticky_object(caller_address)` to create the Object on-chain.

当您调用这些函数时，它们将返回一个`ConstructorRef`。`Ref`允许在创建对象后立即对其进行自定义。 您可以使用`ConstructorRef`根据您的用例生成可能需要的其他权限。

请注意，`ConstructorRef`无法存储，并且会在用于创建此对象的事务结束时销毁，因此任何`Ref`s 都必须在对象创建期间生成。

`ConstructorRef`的一个用途是生成 FA`Metadata`对象。

标准库提供了一个方法`primary_fungible_store::create_primary_store_enabled_fungible_asset`，该函数允许将您的可替代资产转移到任何帐户。

创建元数据后，您还可以使用它`ConstructorRef`来生成其他内容

## `faucet`项目实操

### 第一步：创建项目并初始化

```shell
mkdir faucet
cd faucet
aptos init
aptos move init --name faucet
open -a RustRover .
```

### 第二步：项目目录结构

```shell
tree . -L 6 -I 'build'


.
├── Move.toml
├── scripts
├── sources
│   └── faucet.move
└── tests

4 directories, 2 files
```

### 第三步：项目代码

#### `Move.toml` 文件

```toml
[package]
name = "faucet"
version = "1.0.0"
authors = []

[addresses]
contract = "4cb64ff8439e8a7eff1e513413f711b4ce14ff95b35e2717156496375a3b676e"

[dev-addresses]

[dependencies.AptosFramework]
git = "https://github.com/aptos-labs/aptos-core.git"
rev = "mainnet"
subdir = "aptos-move/framework/aptos-framework"

[dev-dependencies]

```

#### `faucet.move` 文件

```shell
module contract::faucet {
    use aptos_framework::fungible_asset::{
        Self,
        TransferRef,
        BurnRef,
        Metadata,
        FungibleAsset,
        MintRef
    };
    use aptos_framework::object::{Self, Object};
    use aptos_framework::primary_fungible_store;
    use std::string::utf8;
    use std::option;
    use std::signer;
    #[test_only]
    use aptos_framework::account;

    const ASSET_SYMBOL: vector<u8> = b"FA";

    struct MyMintRef has key {
        mint_ref: MintRef
    }

    struct MyMintRef2 has key {
        admin: address,
        mint_ref: MintRef
    }

    struct MyTransferRef has key {
        transfer_ref: TransferRef
    }

    struct MyBurnRef has key {
        burn_ref: BurnRef
    }

    fun init_module(contract: &signer) {
        let constructor_ref = object::create_named_object(contract, ASSET_SYMBOL);
        primary_fungible_store::create_primary_store_enabled_fungible_asset(
            &constructor_ref,
            option::none(),
            utf8(b"FA Coin"), /* name */
            utf8(ASSET_SYMBOL), /* symbol */
            8, /* decimals */
            utf8(b"http://example.com/favicon.ico"), /* icon */
            utf8(b"http://example.com") /* project */
        );

        let mint_ref = fungible_asset::generate_mint_ref(&constructor_ref);

        let transfer_ref = fungible_asset::generate_transfer_ref(&constructor_ref);

        let burn_ref = fungible_asset::generate_burn_ref(&constructor_ref);

        move_to(
            contract,
            MyMintRef { mint_ref }
        );

        move_to(
            contract,
            MyBurnRef { burn_ref }
        );

        move_to(
            contract,
            MyTransferRef { transfer_ref }
        );
    }

    entry fun create_fa (
        sender: &signer
    ){
        let constructor_ref = object::create_named_object(sender, ASSET_SYMBOL);
        primary_fungible_store::create_primary_store_enabled_fungible_asset(
            &constructor_ref,
            option::none(),
            utf8(b"FA2 Coin"), /* name */
            utf8(b"FA2"), /* symbol */
            8, /* decimals */
            utf8(b"http://example.com/favicon.ico"), /* icon */
            utf8(b"http://example.com"), /* project */
        );

        let mint_ref = fungible_asset::generate_mint_ref(&constructor_ref);


        let transfer_ref = fungible_asset::generate_transfer_ref(&constructor_ref);


        let burn_ref = fungible_asset::generate_burn_ref(&constructor_ref);

        move_to(
            sender,
            MyMintRef2 {
                admin: signer::address_of(sender),
                mint_ref
            }
        );

        move_to(
            sender,
            MyBurnRef {
                burn_ref
            }
        );

        move_to(
            sender,
            MyTransferRef {
                transfer_ref
            }
        );
    }

    entry fun faucet(sender: &signer, amount: u64) acquires MyMintRef {
        let my_mint_ref = borrow_global<MyMintRef>(@contract);
        let fa = fungible_asset::mint(&my_mint_ref.mint_ref, amount);
        primary_fungible_store::deposit(signer::address_of(sender), fa);
    }

    entry fun mint(
        sender: &signer,
        amount: u64
    ) acquires MyMintRef2 {
        let my_mint_ref2 = borrow_global<MyMintRef2>(signer::address_of(sender));
        assert!(
            my_mint_ref2.admin == signer::address_of(sender),
            123
        );
        let fa  = fungible_asset::mint(&my_mint_ref2.mint_ref, amount);
        primary_fungible_store::deposit( signer::address_of(sender), fa);
    }

    #[view]
    /// Get the balance of `account`'s primary store.
    public fun balance<T: key>(account: address, metadata: Object<T>): u64 {
        primary_fungible_store::balance(account, metadata)
    }

    #[view]
    public fun is_balance_at_least<T: key>(
        account: address, metadata: Object<T>, amount: u64
    ): bool {
        primary_fungible_store::is_balance_at_least(account, metadata, amount)
    }

    #[test]
    fun test() acquires MyMintRef {
        let user_signer = account::create_account_for_test(@contract);
        init_module(&user_signer);

        let user1_signer = account::create_account_for_test(@0x12345);
        faucet(&user1_signer, 1 * 1000 * 1000 * 100);
    }

    #[test]
    fun test_mint() acquires MyMintRef2 {
        let user_signer = account::create_account_for_test(@contract);
        create_fa(&user_signer);
        mint(&user_signer, 1 * 1000 * 1000 * 100);
        mint(&user_signer, 1 * 1000 * 1000 * 100);
    }
}

```

init_module publish 的时候会自动调用

### 第四步：编译构建

![image-20240926214713727](assets/image-20240926214713727.png)

### 第五步：测试

#### 测试 `faucet` 方法

![image-20240926210050537](assets/image-20240926210050537.png)

#### 测试 `mint` 方法

![image-20240926214135032](assets/image-20240926214135032.png)

### 第六步：发布

```shell
/opt/homebrew/bin/aptos move publish
Compiling, may take a little while to download git dependencies...
UPDATING GIT DEPENDENCY https://github.com/aptos-labs/aptos-core.git
INCLUDING DEPENDENCY AptosFramework
INCLUDING DEPENDENCY AptosStdlib
INCLUDING DEPENDENCY MoveStdlib
BUILDING faucet
warning[W09001]: unused alias
  ┌─ /Users/qiaopengjun/Code/Aptos/hello_aptos/faucet/sources/faucet.move:6:9
  │
6 │         Metadata,
  │         ^^^^^^^^ Unused 'use' of alias 'Metadata'. Consider removing it

warning[W09001]: unused alias
  ┌─ /Users/qiaopengjun/Code/Aptos/hello_aptos/faucet/sources/faucet.move:7:9
  │
7 │         FungibleAsset,
  │         ^^^^^^^^^^^^^ Unused 'use' of alias 'FungibleAsset'. Consider removing it

warning: unused alias
  ┌─ /Users/qiaopengjun/Code/Aptos/hello_aptos/faucet/sources/faucet.move:6:9
  │
6 │         Metadata,
  │         ^^^^^^^^ Unused 'use' of alias 'Metadata'. Consider removing it

warning: unused alias
  ┌─ /Users/qiaopengjun/Code/Aptos/hello_aptos/faucet/sources/faucet.move:7:9
  │
7 │         FungibleAsset,
  │         ^^^^^^^^^^^^^ Unused 'use' of alias 'FungibleAsset'. Consider removing it

package size 2931 bytes
Do you want to submit a transaction for a range of [404100 - 606100] Octas at a gas unit price of 100 Octas? [yes/no] >
yes
Transaction submitted: https://explorer.aptoslabs.com/txn/0x78f2e8b66560426445fa5b1c490fbdc6264393d500717b19066cecd13279709a?network=testnet
{
  "Result": {
    "transaction_hash": "0x78f2e8b66560426445fa5b1c490fbdc6264393d500717b19066cecd13279709a",
    "gas_used": 4041,
    "gas_unit_price": 100,
    "sender": "4cb64ff8439e8a7eff1e513413f711b4ce14ff95b35e2717156496375a3b676e",
    "sequence_number": 0,
    "success": true,
    "timestamp_us": 1727359014128512,
    "version": 6043585322,
    "vm_status": "Executed successfully"
  }
}

Process finished with exit code 0

```



![image-20240926215720473](assets/image-20240926215720473.png)

#### 查看交易

https://explorer.aptoslabs.com/txn/0x78f2e8b66560426445fa5b1c490fbdc6264393d500717b19066cecd13279709a?network=testnet

![image-20240926215925217](assets/image-20240926215925217.png)

#### 查看合约

https://explorer.aptoslabs.com/account/0x4cb64ff8439e8a7eff1e513413f711b4ce14ff95b35e2717156496375a3b676e?network=testnet

https://explorer.aptoslabs.com/account/0x4cb64ff8439e8a7eff1e513413f711b4ce14ff95b35e2717156496375a3b676e/modules/code/faucet?network=testnet

![image-20240926220113339](assets/image-20240926220113339.png)

### 第七步：执行 `faucet` 方法 点击 Run

https://explorer.aptoslabs.com/account/0x4cb64ff8439e8a7eff1e513413f711b4ce14ff95b35e2717156496375a3b676e/modules/run/faucet/faucet?network=testnet

### ![image-20240926221845550](assets/image-20240926221845550.png)



#### 点击 `Approve`

![image-20240926220437907](assets/image-20240926220437907.png)

#### `faucet` 方法成功执行

![image-20240926220626240](assets/image-20240926220626240.png)

#### 查看 Transaction

https://explorer.aptoslabs.com/txn/0x49865fc5ec375a1ae9efa967d27fd41494af8ac6d86db9d34058348d85399c7c?network=testnet

![image-20240926220820927](assets/image-20240926220820927.png)

#### 查看 Transaction Balance Change

![image-20240926221213489](assets/image-20240926221213489.png)

#### 查看 Transaction Changes

https://explorer.aptoslabs.com/txn/0x49865fc5ec375a1ae9efa967d27fd41494af8ac6d86db9d34058348d85399c7c/changes?network=testnet

![image-20240926221316237](assets/image-20240926221316237.png)

https://explorer.aptoslabs.com/txn/0x49865fc5ec375a1ae9efa967d27fd41494af8ac6d86db9d34058348d85399c7c/events?network=testnet

#### 查看 Transaction Object

https://explorer.aptoslabs.com/object/0x74e3fe9df13b7d277a410b4b5dff48ad59ab7dd2fbd26e4c19a8dbd86c16ad4e/resources?network=testnet

![image-20240926221611541](assets/image-20240926221611541.png)

#### 查看钱包确认

![image-20240926221133546](assets/image-20240926221133546.png)



### 第八步：调用`balance` 方法

https://explorer.aptoslabs.com/account/0x4cb64ff8439e8a7eff1e513413f711b4ce14ff95b35e2717156496375a3b676e/modules/view/faucet/balance?network=testnet

第一种方式：

![image-20240927132352122](assets/image-20240927132352122.png)

第二种方式：

![image-20240927110108432](assets/image-20240927110108432.png)

第三种方式：

https://explorer.aptoslabs.com/account/0x0000000000000000000000000000000000000000000000000000000000000001/modules/view/primary_fungible_store/balance?network=testnet

![image-20240927132943052](assets/image-20240927132943052.png)

### 第九步：调用`is_balance_at_least`方法

查看余额至少 100000000，应该返回 true

![image-20240927110439377](assets/image-20240927110439377.png)

查看余额至少 200000000，应该返回 false

![image-20240927110521856](assets/image-20240927110521856.png)



### 第十步：调用 `create_fa` 方法

https://explorer.aptoslabs.com/account/0x4cb64ff8439e8a7eff1e513413f711b4ce14ff95b35e2717156496375a3b676e/modules/run/faucet/create_fa?network=testnet

![image-20240927142413326](assets/image-20240927142413326.png)





####  查看 Transaction

https://explorer.aptoslabs.com/txn/0xa71583c0d34d58923f5910be655373dfbc61c8d022652c40e7316f605918a78a?network=testnet

https://explorer.aptoslabs.com/txn/0xa71583c0d34d58923f5910be655373dfbc61c8d022652c40e7316f605918a78a/changes?network=testnet

![image-20240927143431742](assets/image-20240927143431742.png)



#### 查看 Object

https://explorer.aptoslabs.com/object/0xceb7964c47a5c3488c01f9e202ff4fee4d8de19e1b25a6db0254e38272598ade/resources?network=testnet

![image-20240927143553992](assets/image-20240927143553992.png)



### 第十一步：调用 `mint` 方法

https://explorer.aptoslabs.com/account/0x4cb64ff8439e8a7eff1e513413f711b4ce14ff95b35e2717156496375a3b676e/modules/run/faucet/mint?network=testnet

![image-20240927152931390](assets/image-20240927152931390.png)

#### 查看 Transaction

https://explorer.aptoslabs.com/txn/0x414d6601671539323582363364a9b297d34f8a04910818761a8e6b37b13c4b2b?network=testnet

https://explorer.aptoslabs.com/txn/0x414d6601671539323582363364a9b297d34f8a04910818761a8e6b37b13c4b2b/changes?network=testnet

![image-20240927153200219](assets/image-20240927153200219.png)

https://explorer.aptoslabs.com/object/0xceb7964c47a5c3488c01f9e202ff4fee4d8de19e1b25a6db0254e38272598ade/resources?network=testnet

#### 查看钱包余额

![image-20240927153340307](assets/image-20240927153340307.png)

#### 切换账户再次调用 `mint` 方法验证

https://explorer.aptoslabs.com/account/0x4cb64ff8439e8a7eff1e513413f711b4ce14ff95b35e2717156496375a3b676e/modules/run/faucet/mint?network=testnet

![image-20240927153750356](assets/image-20240927153750356.png)

可以看到报错了，该账户没有权限Mint，成功验证只有 create fa2 的人才可以 Mint

![image-20240927153733544](assets/image-20240927153733544.png)



**注意：关于 IDE 的设置，请参考我之前的文章：**

[Aptos 开发指南：在 JetBrains 编辑器中配置运行、编译、测试与发布部署，实现更高效开发](https://learnblockchain.cn/article/9258)

## 源码参考

```rust
  /// Create a new named object and return the ConstructorRef. Named objects can be queried globally
    /// by knowing the user generated seed used to create them. Named objects cannot be deleted.
    public fun create_named_object(creator: &signer, seed: vector<u8>): ConstructorRef {
        let creator_address = signer::address_of(creator);
        let obj_addr = create_object_address(&creator_address, seed);
        create_object_internal(creator_address, obj_addr, false)
    }


 /// Create a new object by generating a random unique address based on transaction hash.
    /// The unique address is computed sha3_256([transaction hash | auid counter | 0xFB]).
    /// The created object is deletable as we can guarantee the same unique address can
    /// never be regenerated with future txs.
    public fun create_object(owner_address: address): ConstructorRef {
        let unique_address = transaction_context::generate_auid_address();
        create_object_internal(owner_address, unique_address, true)
    }

    /// Same as `create_object` except the object to be created will be undeletable.
    public fun create_sticky_object(owner_address: address): ConstructorRef {
        let unique_address = transaction_context::generate_auid_address();
        create_object_internal(owner_address, unique_address, false)
    }




  public fun create_primary_store_enabled_fungible_asset(
        constructor_ref: &ConstructorRef,
        maximum_supply: Option<u128>,
        name: String,
        symbol: String,
        decimals: u8,
        icon_uri: String,
        project_uri: String,
    ) {
        fungible_asset::add_fungibility(
            constructor_ref,
            maximum_supply,
            name,
            symbol,
            decimals,
            icon_uri,
            project_uri,
        );
        let metadata_obj = &object::generate_signer(constructor_ref);
        move_to(metadata_obj, DeriveRefPod {
            metadata_derive_ref: object::generate_derive_ref(constructor_ref),
        });
    }



  public fun generate_mint_ref(constructor_ref: &ConstructorRef): MintRef {
        let metadata = object::object_from_constructor_ref<Metadata>(constructor_ref);
        MintRef { metadata }
    }


  struct MintRef has drop, store {
        metadata: Object<Metadata>
    }


  /// Mint the specified `amount` of the fungible asset.
    public fun mint(ref: &MintRef, amount: u64): FungibleAsset acquires Supply, ConcurrentSupply {
        let metadata = ref.metadata;
        mint_internal(metadata, amount)
    }


 /// Deposit fungible asset `fa` to the given account's primary store.
    public fun deposit(owner: address, fa: FungibleAsset) acquires DeriveRefPod {
        let metadata = fungible_asset::asset_metadata(&fa);
        let store = ensure_primary_store_exists(owner, metadata);
        dispatchable_fungible_asset::deposit(store, fa);
    }


  #[test_only]
    public fun create_account_for_test(new_address: address): signer {
        // Make this easier by just allowing the account to be created again in a test
        if (!exists_at(new_address)) {
            create_account_unchecked(new_address)
        } else {
            create_signer_for_test(new_address)
        }
    }
```

## 总结

通过本篇文章的学习，我们成功在 Aptos 区块链上使用 Move 构建了一个同质化代币水龙头。我们从代币的创建、权限管理到代币的铸造与分发，全面覆盖了相关步骤和代码实现。Aptos Move 提供了强大的灵活性和功能，使得构建代币系统变得高效简洁。通过这些实践经验，读者可以进一步探索 Aptos 生态系统的其他应用，并将代币水龙头功能扩展到更多的场景中。

## 参考

- https://aptos.dev/en/build/smart-contracts/fungible-asset
- https://www.youtube.com/watch?v=vnl8zXiN4SQ
- https://explorer.aptoslabs.com/account/0x9441c7b026a4029d7971ed4d7d9ed08ceaa09a17f3e004d6462a04eac9af457b/modules/code/faucet?network=testnet
- https://github.com/qiaopengjun5162/hello_aptos