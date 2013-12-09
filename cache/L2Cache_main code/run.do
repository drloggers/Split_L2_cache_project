vsim -novopt cache_l2 +TRACE=TestCases/hit_test.txt
run
vsim -novopt cache_l2 +TRACE=TestCases/max_hits.txt
run
vsim -novopt cache_l2 +TRACE=TestCases/LRU_status.txt
run
vsim -novopt cache_l2 +TRACE=TestCases/LRU_evict.txt
run
vsim -novopt cache_l2 +TRACE=TestCases/MESI_test.txt
run
vsim -novopt cache_l2 +TRACE=TestCases/MESI_exceptions.txt
run
vsim -novopt cache_l2 +TRACE=TestCases/get_snoop_test.txt
run
vsim -novopt cache_l2 +TRACE=TestCases/put_snoop_test.txt
run
vsim -novopt cache_l2 +TRACE=TestCases/print_test.txt
run
vsim -novopt cache_l2 +TRACE=TestCases/clear_cache_test.txt
run
