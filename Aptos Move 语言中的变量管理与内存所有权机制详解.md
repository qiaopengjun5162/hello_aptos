

# **Aptos Move 语言中的变量管理与内存所有权机制详解**



在Move语言中，变量不仅仅是简单的存储单元，它们通过所有权机制管理内存的使用和回收。这种独特的设计使得Move能够在编译阶段优化内存分配，避免内存泄漏并提高代码的安全性和可维护性。本文将深入探讨Move语言中的变量类型、值类型与引用类型的存储方式，并结合实际代码演示如何在Move中有效管理变量的所有权。

本文介绍了Move语言中的变量及其存储方式，详细分析了值类型与引用类型的区别和联系。值类型变量直接存储在栈上，适用于小型数据类型，而引用类型变量则存储在堆上，通过栈上的引用进行访问。Move语言采用独特的所有权机制，确保内存的高效使用和安全性。通过对值类型和引用类型的详细讲解，本文展示了如何在Move语言中定义、存储和操作变量，以及通过所有权转移避免内存泄漏。

## Move 语言与变量

变量是什么？

变量是存储数据值的容器，可以用来存储和操作数据。在 Move 语言中，变量可以用来存储整数、布尔值、字符串等数据类型。

变量：是有名字的对象

对象：存储某个类型值的内存区域
值：按照类型进行解释的bytes集合
类型：定义可能值的操作
类型系统：定义类型和值之间的关系
值类型是如何存储的？
值类型，意为简单的类型，其主要特征是数量量较小，常见有以下类型：
布尔类型
整数
浮点数
枚举
字符串
堆类型值的指向
...

引用类型是如何存储的？
引用类型，意为复杂类型，其主要特征是数量量较大，常见有以下类型：
结构体
数组
向量
函数
模块
对象
类
...

Move 语言中的变量是如何存储的？
Move 语言中的变量分为值类型变量和引用类型变量，它们的存储方式有所不同。
值类型变量：直接存储在栈上，不需要额外的内存分配。
引用类型变量：存储在堆上，需要通过引用来访问。

值类型与引用类型的关系
通常我们定义一个变量为对象时，其对象的值存储在堆上，其堆内存的索引存储在栈上，用栈上的索引指向堆上存储的引用类型数据。

Move 的核心差异之一
在值类型与引用类型关系上，不同于其他语言的索引方式。而是以“所有权”来作为引用类型的操作。

1. 所有权只能同时由 1 “人” 拥有
2. 所有权以转移的形式流转给其他变量

这样做有什么好处？

1. 避免内存泄露，不同于其他语言，在编译阶段就可以告知什么时候可以回收内存
2. 提高内存使用效率，避免对引用类型的不必要拷贝
3. 更好的可读性和可维护性



**所有权机制的核心原则**



​	1.	**唯一所有权**：Move 语言中，每个值都有且只有一个所有者。当该所有者超出作用域时，值会自动被回收。

​	2.	**所有权转移**：所有权可以通过赋值操作转移给另一个变量，转移后原所有者将失去对该值的访问权。

## 实操

### 创建项目并进入项目目录

```shell
mcd lesson2 # mkdir lesson2 && cd lesson2
```

### 初始化项目

```shell
aptos move init --name lesson2
```

### 初始化账户

```shell
aptos init
```

### 使用编辑器打开项目

```shell
open -a RustRover .
```

#### 实操

```shell
Code/Aptos/hello_aptos via 🅒 base
➜
mcd lesson2

Aptos/hello_aptos/lesson2 via 🅒 base
➜
aptos move init --name lesson2
{
  "Result": "Success"
}

Aptos/hello_aptos/lesson2 via 🅒 base
➜
aptos init
Configuring for profile default
Choose network from [devnet, testnet, mainnet, local, custom | defaults to devnet]

No network given, using devnet...
Enter your private key as a hex literal (0x...) [Current: None | No input: Generate new key (or keep one if present)]

No key given, generating key...
Account 0x10e4b3090e1ddfac6dd8f61ff0f84c7ee38cc541f6bc7078d36469c53b213d39 doesn't exist, creating it and funding it with 100000000 Octas
Account 0x10e4b3090e1ddfac6dd8f61ff0f84c7ee38cc541f6bc7078d36469c53b213d39 funded successfully

---
Aptos CLI is now set up for account 0x10e4b3090e1ddfac6dd8f61ff0f84c7ee38cc541f6bc7078d36469c53b213d39 as profile default!
 See the account here: https://explorer.aptoslabs.com/account/0x10e4b3090e1ddfac6dd8f61ff0f84c7ee38cc541f6bc7078d36469c53b213d39?network=devnet
 Run `aptos --help` for more information about commands
{
  "Result": "Success"
}

Aptos/hello_aptos/lesson2 via 🅒 base took 12.3s
➜
open -a RustRover .

```

### 查看项目结构

```shell
Aptos/hello_aptos/lesson2 via 🅒 base 
➜ tree . -L 6 -I 'build'

.
├── Move.toml
├── scripts
├── sources
│   └── main.move
└── tests

4 directories, 2 files


```

### `main.move` 文件

```rust
module 0x42::Lesson2 {
    use std::debug::print;

    struct Wallet has drop {
        balance: u64
    }

    #[test]
    fun test_wallet() {
        let wallet = Wallet { balance: 1000 };
        let wallet2 = wallet; // move ownership

        // print(&wallet.balance);  // move ownership
        print(&wallet2.balance);

    }
}
```

### 代码总结
这段代码定义了一个名为 `Wallet` 的结构体，表示一个钱包，具有一个 `balance` （余额）字段。然后，在测试函数 `test_wallet` 中，创建了一个钱包实例并将其所有权转移给另一个变量。最后，代码打印了第二个钱包的余额。

### 代码逐步解释

1. **模块定义**:
module 0x42::Lesson2 {
这一行定义了一个模块 `0x42::Lesson2` ，用于组织相关代码。

2. **引入标准库的调试打印功能**:
use std::debug::print;
这行代码引入了标准库中的 `print` 函数，用于打印调试信息。

3. **结构体定义**:
struct Wallet has drop {
       balance: u64
   }
这里定义了一个名为 `Wallet` 的结构体，包含一个字段 `balance` ，类型为 `u64` （无符号64位整数）。 `has drop` 表示当 `Wallet` 实例超出作用域时，它的资源会被自动释放。

4. **测试函数定义**:
#[test]
   fun test_wallet() {
这行代码定义了一个测试函数 `test_wallet` ，用于测试 `Wallet` 结构体的功能。

5. **创建钱包实例**:
let wallet = Wallet { balance: 1000 };
这里创建了一个新的 `Wallet` 实例，初始余额为1000。

6. **转移所有权**:
let wallet2 = wallet; // move ownership
这一行将 `wallet` 的所有权转移给 `wallet2` ，此时 `wallet` 不再有效。

7. **打印余额**:
print(&wallet2.balance);
这行代码打印 `wallet2` 的余额。由于所有权已经转移， `wallet` 的余额不能再被访问。

总结来说，这段代码展示了如何定义一个结构体、创建其实例、转移所有权以及打印结构体字段的值。

1. Move 中的每一个值都有一个 **所有者**（*owner*）。
2. 值在任一时刻有且只有一个所有者。
3. 当所有者（变量）离开作用域，这个值将被丢弃。



Aptos Move 语言的所有权机制为内存安全提供了强大的保障，特别是在区块链环境中，它确保了资源的唯一性与安全性。通过严格的所有权转移规则与内存管理机制，Move 能有效防止常见的内存错误，如内存泄漏或重复释放。通过结合 Move 中的静态检查与所有权模型，开发者可以编写出高效且安全的区块链应用。

## 参考

- https://learn.aptoslabs.com/zh/tutorials/ethereum-to-aptos-guide/cheat-sheet?workshop=eth-to-aptos
- https://kaisery.github.io/trpl-zh-cn/ch04-01-what-is-ownership.html