# Aptos Move 编程语言中的四大基础类型解析：UINT、STRING、BOOL 与 ADDRESS

在 Aptos Move 编程语言中，基础数据类型是开发智能合约和链上应用的核心要素。本文将详细解析四种最常用的数据类型——`UINT`、`STRING`、`BOOL` 与 `ADDRESS`，并通过代码示例展示它们在实际编程中的应用。这些类型分别对应整数、字符串、布尔值和地址，它们为构建可靠的区块链应用提供了重要的基础功能。

---

在 Aptos Move 中，理解基本类型的使用和特点是编写智能合约的基础。以下是 Move 编程语言中四种常用的基本类型及其应用示例。

#### 1. **UINT 类型**
`UINT` 代表无符号整数，有不同的位数版本，如 `u8` 和 `u256`，分别对应 8 位和 256 位的无符号整数。

- `u8` 范围：0 ~ 2^8 - 1。
- `u256` 范围：0 ~ 2^256 - 1。

在下面的代码中，我们演示了 `u8` 和 `u256` 类型的声明和相加操作：

```move
#[test]
fun test_num() {
    let num_u8: u8 = 42; 
    let num_u8_2 = 43u8;
    let num_u8_3 = 0x2A; // 十六进制表示法

    let num_u256: u256 = 100_000;

    let num_sum = (num_u8 as u256) + num_u256; // 类型转换与运算
    print(&num_u8);
    print(&num_u8_2);
    print(&num_u8_3);
    print(&num_u256);
    print(&num_sum);
}
```

在此函数中，使用了 `u8` 和 `u256` 类型，并进行了简单的加法运算，展示了不同位数整数的灵活性。

#### 2. **BOOL 类型**
布尔类型 `bool` 只有两个取值：`true` 和 `false`。它们通常用于控制流逻辑和条件判断。

```move
#[test]
fun test_bool() {
    let bool_true: bool = true;
    let bool_false: bool = false;
    print(&bool_true);
    print(&bool_false);
    print(&(bool_true == bool_false)); // 打印比较结果
}
```

该函数展示了布尔类型的声明和比较操作。

#### 3. **STRING 类型**
`STRING` 是一个动态长度的字符串，常用于存储和操作文本数据。Aptos Move 提供了通过字节数组（`utf8`）创建字符串的方式。

```move
#[test]
fun test_string() {
    let str: String = utf8(b"Hello, Move!"); // 字符串声明
    print(&str);
}
```

这里我们创建了一个字符串 `"Hello, Move!"`，并通过 `print` 函数将其输出。

#### 4. **ADDRESS 类型**
`ADDRESS` 类型用于表示区块链上的地址，它是一个 16 字节的标识符，通常代表一个账户或智能合约。

```move
#[test]
fun test_addr() {
    let addr: address = @0x42; // 地址声明
    let addr_2: address = @0x00000000000000000000000000000000000000000A; // 完整地址
    print(&addr);
    print(&addr_2);
}
```

在这个示例中，我们声明了两个地址并输出它们。地址通常用于标识链上用户或合约的唯一性。

UINT/ STRING/ BOOL 与 ADDRESS 四大类型

```move
module 0x42::Types {
    use std::debug::print;
    use std::string;
    use std::string::{String, utf8};

    #[test]
    fun test_num() {
        let num_u8: u8 = 42; // 0~2**8-1
        let num_u8_2 = 43u8;
        let num_u8_3 = 0x2A; // hash

        let num_u256: u256 = 100_000;

        let num_sum = (num_u8 as u256) + num_u256;
        print(&num_u8);
        print(&num_u8_2);
        print(&num_u8_3);
        print(&num_u256);
        print(&num_sum);
    }

    #[test]
    fun test_bool() {
        let bool_true: bool = true;
        let bool_false: bool = false;
        print(&bool_true);
        print(&bool_false);
        print(&(bool_true == bool_false));
    }

    #[test]
    fun test_string() {
        let str: String = utf8(b"Hello, Move!");
        print(&str);
    }

    #[test]
    fun test_addr() {
        let addr: address = @0x42;
        let addr_2: address = @0x00000000000000000000000000000000000000000A;

        print(&addr);
        print(&addr_2);
    }
}

```

通过本篇文章，我们深入探讨了 Aptos Move 中四种基础数据类型的定义和应用。这些类型在智能合约开发中起着关键作用，理解它们有助于开发更高效、安全的链上应用。

## 参考

- https://aptos.dev/en/build/smart-contracts/book/vector
- https://aptos.dev/en/build/guides/your-first-nft