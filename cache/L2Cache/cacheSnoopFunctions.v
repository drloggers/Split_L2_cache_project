/*
getSnoop and putSnoop function
*/

module cacheSnoopFunctions;
parameter L1_read           =   8'd0;
parameter L1_write          =   8'd1;
parameter L1_inst_read      =   8'd2;
parameter snoop_invalidate  =   8'd3;
parameter snoop_read        =   8'd4;
parameter snoop_write       =   8'd5;
parameter snoop_readRFO     =   8'd6;
parameter clear             =   8'd8;
parameter print_cache       =   8'd9;
  function[1:0] GetSnoopResult;
    input[31:0] Address;
    input[7:0] Operation;  
      begin
        if(Address[1:0] <= 2'b01)
          GetSnoopResult = 2'b00;
      else if(Address[1:0] == 2'b10)
          GetSnoopResult = 2'b01;
      else
          GetSnoopResult = 2'b10;   
      end 
endfunction

function PutSnoopResult;
    input[32:0] Address;
    input[7:0] Operation;
    begin
        PutSnoopResult = getSnoopResultFromL2cache(Address, Operation);
    end
endfunction
endmodule