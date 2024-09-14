
```bash
/opt/homebrew/bin/aptos move test
INCLUDING DEPENDENCY AptosFramework
INCLUDING DEPENDENCY AptosStdlib
INCLUDING DEPENDENCY MoveStdlib
BUILDING lesson4
warning: unused alias
  ┌─ /Users/qiaopengjun/Code/Aptos/hello_aptos/lesson4/sources/main.move:2:14
  │
2 │     use std::debug;
  │              ^^^^^ Unused 'use' of alias 'debug'. Consider removing it

warning: unused alias
  ┌─ /Users/qiaopengjun/Code/Aptos/hello_aptos/lesson4/sources/main.move:3:14
  │
3 │     use std::vector;
  │              ^^^^^^ Unused 'use' of alias 'vector'. Consider removing it

Running Move unit tests
[debug] false
[ PASS    ] 0x42::VectorDemo::test_empty_vector
[debug] [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 1100, 1000, 900, 800, 700, 600, 500, 400, 300, 200, 100 ]
[ PASS    ] 0x42::VectorDemo::test_reverse_append
[debug] [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 ]
[ PASS    ] 0x42::VectorDemo::test_vector
[debug] [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100 ]
[ PASS    ] 0x42::VectorDemo::test_vector_append
[debug] 4
[ PASS    ] 0x42::VectorDemo::test_vector_borrow
[debug] 4
[debug] 100
[debug] [ 1, 2, 3, 100, 5, 6, 7, 8, 9, 10, 11 ]
[ PASS    ] 0x42::VectorDemo::test_vector_borrow_mut
[debug] true
[debug] false
[ PASS    ] 0x42::VectorDemo::test_vector_contains
[debug] true
[debug] 2
[debug] false
[debug] 0
[ PASS    ] 0x42::VectorDemo::test_vector_index_of
[debug] [ 1, 2, 3, 100, 4, 5, 6, 7, 8, 9, 10, 11 ]
[ PASS    ] 0x42::VectorDemo::test_vector_insert
[debug] 11
[ PASS    ] 0x42::VectorDemo::test_vector_len
[debug] 11
[debug] [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]
[ PASS    ] 0x42::VectorDemo::test_vector_pop_back
[debug] [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 100 ]
[ PASS    ] 0x42::VectorDemo::test_vector_push_back
[debug] 4
[debug] [ 1, 2, 3, 5, 6, 7, 8, 9, 10, 11 ]
[ PASS    ] 0x42::VectorDemo::test_vector_remove
[debug] [ 11, 10, 9, 8, 7, 6, 55, 4, 53, 2, 1 ]
[ PASS    ] 0x42::VectorDemo::test_vector_reverse
[debug] [ 4, 55, 6, 7, 8, 9, 10, 11, 1, 2, 53 ]
[ PASS    ] 0x42::VectorDemo::test_vector_rotate
[debug] [ 1, 2, 3, 5, 4, 6, 7, 8, 9, 10, 11 ]
[ PASS    ] 0x42::VectorDemo::test_vector_swap
[debug] 4
[debug] [ 1, 2, 53, 11, 55, 6, 7, 8, 9, 10 ]
[ PASS    ] 0x42::VectorDemo::test_vector_swap_remove
[debug] [ 1, 2, 53 ]
[debug] [ 4, 55, 6, 7, 8, 9, 10, 11 ]
[ PASS    ] 0x42::VectorDemo::test_vector_trim
[debug] [ 1, 2, 53 ]
[debug] [ 11, 10, 9, 8, 7, 6, 55, 4 ]
[ PASS    ] 0x42::VectorDemo::test_vector_trim_reverse
Test result: OK. Total tests: 19; passed: 19; failed: 0
{
  "Result": "Success"
}

Process finished with exit code 0

```