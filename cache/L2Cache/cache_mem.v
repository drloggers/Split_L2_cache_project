// Cache Array 
// The Cache Array holds Tag Overhead (MESI Bits + LRU Counter Bits + Tag)

`include "conf.v"

module cache_mem();
  
  reg [(`mesi_bits+`counter_size+`tag_size-1):0]cache[`set_count-1:0][`associativity-1:0];
  
endmodule