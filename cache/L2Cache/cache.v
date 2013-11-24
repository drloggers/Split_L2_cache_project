// Cache Array 
// The Cache Array holds Tag Overhead (MESI Bits + LRU Counter Bits + Tag)

`include "conf.v"

module cache();
  
  reg [(`tag_size-1):0]cache[`set_count-1:0];
  
endmodule