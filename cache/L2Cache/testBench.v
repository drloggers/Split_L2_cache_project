// test bench
`include "cacheSnoopFunctions.v"
module testBench;
  parameter L1_read           =   8'd0;
parameter L1_write          =   8'd1;
parameter L1_inst_read      =   8'd2;
parameter snoop_invalidate  =   8'd3;
parameter snoop_read        =   8'd4;
parameter snoop_write       =   8'd5;
parameter snoop_readRFO     =   8'd6;
parameter clear             =   8'd8;
parameter print_cache       =   8'd9;
cacheSnoopFunctions fun();
  reg result;
initial 
begin
  $display("answer : %d",fun.GetSnoopResult(2'd3,L1_write));
end
endmodule