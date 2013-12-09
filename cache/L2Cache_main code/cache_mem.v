/*
cache_mem.v
Cache Array 
The Cache Array holds Tag Overhead (MESI Bits + LRU Counter Bits + Tag)
*/

module cache_mem();
  
  `include "config.v"
  
  reg [(mesi_bits+counter_size+tag_size-1):0]cache[set_count-1:0][associativity-1:0];
  
endmodule