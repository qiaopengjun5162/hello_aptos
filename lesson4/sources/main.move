module 0x42::VectorDemo {
    use std::debug;
    use std::vector;

    const ARR: vector<u64> = vector[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

    #[test]
    fun test_vector() {
        debug::print(&ARR);
    }

    #[test]
    fun test_vector_len() {
        debug::print(&vector::length(&ARR));
    }

    #[test]
    fun test_empty_vector() {
        let bools: bool = vector::is_empty(&ARR);
        debug::print(&bools);
    }

    #[test]
    fun test_vector_borrow() {
        let val = vector::borrow(&ARR, 3);
        debug::print(val);
    }

    #[test]
    fun test_vector_borrow_mut() {
        let arr: vector<u64> = vector[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
        let val = vector::borrow_mut(&mut arr, 3);
        debug::print(val);
        *val = 100;
        debug::print(val);
        debug::print(&arr);
    }

    #[test]
    fun test_vector_contains() {
        let n: u64 = 3;
        let n2: u64 = 100;
        debug::print(&vector::contains(&ARR, &n));
        let bools: bool = vector::contains(&ARR, &n2);
        debug::print(&bools);
    }

    #[test]
    fun test_vector_index_of() {
        let n: u64 = 3;
        let n2: u64 = 100;
        let (isIndex, index) = vector::index_of(&ARR, &n);
        let (isIndex2, index2) = vector::index_of(&ARR, &n2);
        debug::print(&isIndex);
        debug::print(&index);
        debug::print(&isIndex2);
        debug::print(&index2);
    }

    #[test]
    fun test_vector_push_back() {
        let arr: vector<u64> = vector[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
        vector::push_back(&mut arr, 100);
        debug::print(&arr);
    }

    #[test]
    fun test_vector_append() {
        let arr: vector<u64> = vector[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
        let arr2: vector<u64> = vector[100, 200, 300, 400, 500, 600, 700, 800, 900, 1000,
        1100];
        vector::append(&mut arr, arr2);
        debug::print(&arr);
    }

    #[test]
    fun test_reverse_append() {
        let arr: vector<u64> = vector[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
        let arr2: vector<u64> = vector[100, 200, 300, 400, 500, 600, 700, 800, 900, 1000,
        1100];
        vector::reverse_append(&mut arr, arr2);
        debug::print(&arr);
    }

    #[test]
    fun test_vector_pop_back() {
        let arr: vector<u64> = vector[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
        let val = vector::pop_back(&mut arr);
        debug::print(&val);
        debug::print(&arr);
    }

    #[test]
    fun test_vector_insert() {
        let arr: vector<u64> = vector[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
        vector::insert(&mut arr, 3, 100);
        debug::print(&arr);
    }

    #[test]
    fun test_vector_remove() {
        let arr: vector<u64> = vector[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
        let val = vector::remove(&mut arr, 3);
        debug::print(&val);
        debug::print(&arr);
    }

    #[test]
    fun test_vector_swap() {
        let arr: vector<u64> = vector[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
        vector::swap(&mut arr, 3, 4);
        debug::print(&arr);
    }

    #[test]
    fun test_vector_reverse() {
        let arr: vector<u64> = vector[1, 2, 53, 4, 55, 6, 7, 8, 9, 10, 11];
        vector::reverse(&mut arr);
        debug::print(&arr);
    }

    #[test]
    fun test_vector_rotate() {
        let arr: vector<u64> = vector[1, 2, 53, 4, 55, 6, 7, 8, 9, 10, 11];
        vector::rotate(&mut arr, 3);
        debug::print(&arr);
    }

    #[test]
    fun test_vector_swap_remove() {
        let arr: vector<u64> = vector[1, 2, 53, 4, 55, 6, 7, 8, 9, 10, 11];
        let val = vector::swap_remove(&mut arr, 3);
        debug::print(&val);
        debug::print(&arr);
    }

    #[test]
    fun test_vector_trim() {
        let arr: vector<u64> = vector[1, 2, 53, 4, 55, 6, 7, 8, 9, 10, 11];
        let arr2 = vector::trim(&mut arr, 3);
        debug::print(&arr);
        debug::print(&arr2);
    }

    #[test]
    fun test_vector_trim_reverse() {
        let arr: vector<u64> = vector[1, 2, 53, 4, 55, 6, 7, 8, 9, 10, 11];
        let arr2 = vector::trim_reverse(&mut arr, 3);
        debug::print(&arr);
        debug::print(&arr2);
    }
}
