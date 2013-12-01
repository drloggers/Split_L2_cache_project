`include "conf.v"

module LRU();
  
  reg [`counter_size:0]LRU_mem[`set_count-1:0][`associativity-1:0];
  
endmodule