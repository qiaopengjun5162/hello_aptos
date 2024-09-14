

Aptos Move

认识 OBJECT

什么是 Aptos object？

1. 对象是单个地址的资源容器，用于储存资源
2. 对象提供了一种集中式资源控制与所有权管理的方法

创建并转移对象实例

我们可以通过 aptos_framework 库下的 object 来实现对象的功能。

```rust
module my_addr::object_playground {
  use std::signer;
  use aptos_framework::object::{self, ObjectCore};

  entry fun create_and_transfer(caller: &signer, destination: address) {
    // Create object
    let caller_address = signer::address_of(caller);
    let constructor_ref = object::create_object(caller_address);

    // Set up the object

    // Transfer to destination
    let object = object::object_from_constructor_ref<ObjectCore>(&constructor_ref);
    object::transfer(caller, object, destination);
  }
}
```

两类对象

- 可删除普通对象
- 不可删除对象
  - 命名对象，通过固定的 signer 和特定的 seed 生成唯一地址的对象，1个地址只能生成1个
  - 粘性对象，通过 signer 生成的对象，1个地址可以生成多个



## 实操

### 创建项目并初始化

```shell
hello_aptos on  main [?] via 🅒 base
➜
mcd lesson9
hello_aptos/lesson9 via 🅒 base …
➜


hello_aptos/lesson9 on  main [?] via 🅒 base
➜
aptos init
Configuring for profile default
Choose network from [devnet, testnet, mainnet, local, custom | defaults to devnet]

No network given, using devnet...
Enter your private key as a hex literal (0x...) [Current: None | No input: Generate new key (or keep one if present)]

No key given, generating key...
Account 0x4ff0520288d97315b68d0bc740a5eadf835f4ac61b2c815d8855d77d8f26f808 doesn't exist, creating it and funding it with 100000000 Octas
Account 0x4ff0520288d97315b68d0bc740a5eadf835f4ac61b2c815d8855d77d8f26f808 funded successfully

---
Aptos CLI is now set up for account 0x4ff0520288d97315b68d0bc740a5eadf835f4ac61b2c815d8855d77d8f26f808 as profile default!
 See the account here: https://explorer.aptoslabs.com/account/0x4ff0520288d97315b68d0bc740a5eadf835f4ac61b2c815d8855d77d8f26f808?network=devnet
 Run `aptos --help` for more information about commands
{
  "Result": "Success"
}

hello_aptos/lesson9 on  main [?] via 🅒 base took 5.9s
➜
aptos move init --name lesson9
{
  "Result": "Success"
}

hello_aptos/lesson9 on  main [?] via 🅒 base
➜
open -a RustRover .
```

### 项目目录结构

```shell
tree . -L 6 -I 'build'


.
├── Move.toml
├── scripts
├── sources
│   └── main.move
└── tests

4 directories, 2 files
```

### 代码

#### `main.move`

```rust
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

```

### 运行测试

![image-20240914103648691](assets/image-20240914103648691.png)



## 查看源码

```rust
    /// Create a new named object and return the ConstructorRef. Named objects can be queried globally
    /// by knowing the user generated seed used to create them. Named objects cannot be deleted.
    public fun create_named_object(creator: &signer, seed: vector<u8>): ConstructorRef {
        let creator_address = signer::address_of(creator);
        let obj_addr = create_object_address(&creator_address, seed);
        create_object_internal(creator_address, obj_addr, false)
    }

    /// Create a new object whose address is derived based on the creator account address and another object.
    /// Derivde objects, similar to named objects, cannot be deleted.
    public(friend) fun create_user_derived_object(creator_address: address, derive_ref: &DeriveRef): ConstructorRef {
        let obj_addr = create_user_derived_object_address(creator_address, derive_ref.self);
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
```



![image-20240914104330922](assets/image-20240914104330922.png)

更多请参考：https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-framework/sources/object.move

## 参考

- https://aptos.dev/en/build/smart-contracts/objects
- https://aptos.dev/en/build/smart-contracts/objects/using-objects
- https://aptos.dev/en/build/smart-contracts/objects/creating-objects
- https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-framework/sources/object.move