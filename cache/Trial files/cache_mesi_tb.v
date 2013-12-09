/*
testbench for cache_mesi testing
*/

module Cache_mesi_new_tb;
reg [1:0]presentState;
reg [3:0]command;
wire [1:0]resultResponse;
wire [1:0]resultState;

parameter M   =   2'b00;
parameter E   =   2'b01;
parameter S   =   2'b10;
parameter I   =   2'b11;

parameter noHIT   = 2'b00;
parameter HIT     = 2'b01;
parameter HITM    = 2'b10;

parameter L1_read           =   4'b0000;
parameter L1_write          =   4'b0001;
parameter L1_inst_read      =   4'b0010;
parameter snoop_invalidate  =   4'b0011;
parameter snoop_read        =   4'b0100;
parameter snoop_write       =   4'b0101;
parameter snoop_readRFO     =   4'b0110;
parameter clear             =   4'b1000;
parameter print_cache       =   4'b1001;
cache_Mesi_new cm1(.presentState(presentState),.command(command),.resultResponse(resultResponse),.resultState(resultState));

initial
begin
  $monitor("resultState = %b : resultResponse = %b", resultState,resultResponse);
  {presentState,command} = {E,snoop_readRFO};
  #5;
  $display("answer : %b :: response : %b",resultState, resultResponse);
 /* 
  // testcases for L1 reads
  {presentState,command,snoopResponse} = {M,L1_read,HIT};
  #5
  {presentState,command,snoopResponse} = {M,L1_read,HITM};
  #5
  {presentState,command,snoopResponse} = {M,L1_read,noHIT};
  #5
  {presentState,command,snoopResponse} = {E,L1_read,HIT};
  #5
  {presentState,command,snoopResponse} = {E,L1_read,HITM};
  #5
  {presentState,command,snoopResponse} = {E,L1_read,noHIT};
  #5
  {presentState,command,snoopResponse} = {S,L1_read,HIT};
  #5
  {presentState,command,snoopResponse} = {S,L1_read,HITM};
  #5
  {presentState,command,snoopResponse} = {S,L1_read,noHIT};
  #5
  {presentState,command,snoopResponse} = {I,L1_read,HIT};
  #5
  {presentState,command,snoopResponse} = {I,L1_read,HITM};
  #5
  {presentState,command,snoopResponse} = {I,L1_read,noHIT};
  #5

  // testcases for L1_write
  {presentState,command,snoopResponse} = {M,L1_write,HIT};
  #5
  {presentState,command,snoopResponse} = {M,L1_write,HITM};
  #5
  {presentState,command,snoopResponse} = {M,L1_write,noHIT};
  #5
  {presentState,command,snoopResponse} = {E,L1_write,HIT};
  #5
  {presentState,command,snoopResponse} = {E,L1_write,HITM};
  #5
  {presentState,command,snoopResponse} = {E,L1_write,noHIT};
  #5
  {presentState,command,snoopResponse} = {S,L1_write,HIT};
  #5
  {presentState,command,snoopResponse} = {S,L1_write,HITM};
  #5
  {presentState,command,snoopResponse} = {S,L1_write,noHIT};
  #5
  {presentState,command,snoopResponse} = {I,L1_write,HIT};
  #5
  {presentState,command,snoopResponse} = {I,L1_write,HITM};
  #5
  {presentState,command,snoopResponse} = {I,L1_write,noHIT};
  #5
  
    // testcases for L1_inst_read
  {presentState,command,snoopResponse} = {M,L1_inst_read,HIT};
  #5
  {presentState,command,snoopResponse} = {M,L1_inst_read,HITM};
  #5
  {presentState,command,snoopResponse} = {M,L1_inst_read,noHIT};
  #5
  {presentState,command,snoopResponse} = {E,L1_inst_read,HIT};
  #5
  {presentState,command,snoopResponse} = {E,L1_inst_read,HITM};
  #5
  {presentState,command,snoopResponse} = {E,L1_inst_read,noHIT};
  #5
  {presentState,command,snoopResponse} = {S,L1_inst_read,HIT};
  #5
  {presentState,command,snoopResponse} = {S,L1_inst_read,HITM};
  #5
  {presentState,command,snoopResponse} = {S,L1_inst_read,noHIT};
  #5
  {presentState,command,snoopResponse} = {I,L1_inst_read,HIT};
  #5
  {presentState,command,snoopResponse} = {I,L1_inst_read,HITM};
  #5
  {presentState,command,snoopResponse} = {I,L1_inst_read,noHIT};
  #5

  // testcases for snoop_invalidate
  {presentState,command,snoopResponse} = {M,snoop_invalidate,HIT};
  #5
  {presentState,command,snoopResponse} = {M,snoop_invalidate,HITM};
  #5
  {presentState,command,snoopResponse} = {M,snoop_invalidate,noHIT};
  #5
  {presentState,command,snoopResponse} = {E,snoop_invalidate,HIT};
  #5
  {presentState,command,snoopResponse} = {E,snoop_invalidate,HITM};
  #5
  {presentState,command,snoopResponse} = {E,snoop_invalidate,noHIT};
  #5
  {presentState,command,snoopResponse} = {S,snoop_invalidate,HIT};
  #5
  {presentState,command,snoopResponse} = {S,snoop_invalidate,HITM};
  #5
  {presentState,command,snoopResponse} = {S,snoop_invalidate,noHIT};
  #5
  {presentState,command,snoopResponse} = {I,snoop_invalidate,HIT};
  #5
  {presentState,command,snoopResponse} = {I,snoop_invalidate,HITM};
  #5
  {presentState,command,snoopResponse} = {I,snoop_invalidate,noHIT};
  #5
  
    // testcases for snoop_read
  {presentState,command,snoopResponse} = {M,snoop_read,HIT};
  #5
  {presentState,command,snoopResponse} = {M,snoop_read,HITM};
  #5
  {presentState,command,snoopResponse} = {M,snoop_read,noHIT};
  #5
  {presentState,command,snoopResponse} = {E,snoop_read,HIT};
  #5
  {presentState,command,snoopResponse} = {E,snoop_read,HITM};
  #5
  {presentState,command,snoopResponse} = {E,snoop_read,noHIT};
  #5
  {presentState,command,snoopResponse} = {S,snoop_read,HIT};
  #5
  {presentState,command,snoopResponse} = {S,snoop_read,HITM};
  #5
  {presentState,command,snoopResponse} = {S,snoop_read,noHIT};
  #5
  {presentState,command,snoopResponse} = {I,snoop_read,HIT};
  #5
  {presentState,command,snoopResponse} = {I,snoop_read,HITM};
  #5
  {presentState,command,snoopResponse} = {I,snoop_read,noHIT};
  #5
  
  // testcases for snoop_write
  {presentState,command,snoopResponse} = {M,snoop_write,HIT};
  #5
  {presentState,command,snoopResponse} = {M,snoop_write,HITM};
  #5
  {presentState,command,snoopResponse} = {M,snoop_write,noHIT};
  #5
  {presentState,command,snoopResponse} = {E,snoop_write,HIT};
  #5
  {presentState,command,snoopResponse} = {E,snoop_write,HITM};
  #5
  {presentState,command,snoopResponse} = {E,snoop_write,noHIT};
  #5
  {presentState,command,snoopResponse} = {S,snoop_write,HIT};
  #5
  {presentState,command,snoopResponse} = {S,snoop_write,HITM};
  #5
  {presentState,command,snoopResponse} = {S,snoop_write,noHIT};
  #5
  {presentState,command,snoopResponse} = {I,snoop_write,HIT};
  #5
  {presentState,command,snoopResponse} = {I,snoop_write,HITM};
  #5
  {presentState,command,snoopResponse} = {I,snoop_write,noHIT};
  #5
  
  // testcases for snoop_readRFO
  {presentState,command,snoopResponse} = {M,snoop_readRFO,HIT};
  #5
  {presentState,command,snoopResponse} = {M,snoop_readRFO,HITM};
  #5
  {presentState,command,snoopResponse} = {M,snoop_readRFO,noHIT};
  #5
  {presentState,command,snoopResponse} = {E,snoop_readRFO,HIT};
  #5
  {presentState,command,snoopResponse} = {E,snoop_readRFO,HITM};
  #5
  {presentState,command,snoopResponse} = {E,snoop_readRFO,noHIT};
  #5
  {presentState,command,snoopResponse} = {S,snoop_readRFO,HIT};
  #5
  {presentState,command,snoopResponse} = {S,snoop_readRFO,HITM};
  #5
  {presentState,command,snoopResponse} = {S,snoop_readRFO,noHIT};
  #5
  {presentState,command,snoopResponse} = {I,snoop_readRFO,HIT};
  #5
  {presentState,command,snoopResponse} = {I,snoop_readRFO,HITM};
  #5
  {presentState,command,snoopResponse} = {I,snoop_readRFO,noHIT};
  #5

  //testcase for clear
  {presentState,command,snoopResponse} = {M,clear,noHIT};
  #5
  {presentState,command,snoopResponse} = {E,clear,HIT};
  #5
  {presentState,command,snoopResponse} = {S,clear,HITM};
  #5
  {presentState,command,snoopResponse} = {I,clear,noHIT};
  #5;
  */
end

endmodule
