ECE585_cache_project
====================
We are tasked with simulating a L2 unified cache design for a 32 bit processor. The processor needs be able to be used in a multi-processor system so a MESI protocol will need to be used  to ensure cache coherence.

Our cache will use 64-byte lines and will be 8 way set associative with 16k sets. We are required to use a true LRU replacement policy with write allocate.

We also will need to take into account that our processor's L1 cache will be split for separate data and instruction portions. the L1 cache will use 32-byte lines and be 2-way (instruction) and 4-way(data) set associative. The L2 cche we are to simulate is backed by a DRAM memory subsystem that reads and writes 64-bytes at a time. We do not need to model these, however we do need to make sure that we maintain inclusivity between these components.
