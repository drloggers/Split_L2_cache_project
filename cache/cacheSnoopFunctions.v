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
endmodule
/*function PutSnoopResult();
    input reg[32:0] Address;
    input reg[7:0] Operation;
    begin
      L1_read:
      begin
        PutSnoopResult = 0;
      end
    L1_write :
      begin
        PutSnoopResult = 0;
      end
    L1_inst_read :
      begin
        PutSnoopResult = 0;
      end
    snoop_invalidate :
      begin
        PutSnoopResult = 0;
      end  
    snoop_read :
      begin
        if(presentState == M)
          begin
              resultResponse = HITM;
              resultState = S;
          end
        else if(presentState == E)
          begin
              resultResponse = HIT;
              resultState = S;
          end
        else if(presentState == S)
          begin
            resultState = S;
          end
        else
          begin
            resultResponse = HIT;
            resultState = S;
          end
      end  
    snoop_write :
      begin
      if(presentState == M)
          begin
              resultResponse = HITM;
              resultState = I;
          end
        else if(presentState == E)
          begin
            resultResponse = HIT;
            resultState = I;
          end
        else if(presentState == S)
          begin
            resultResponse = HIT;
                resultState = I;
          end
        else
          begin
            resultState = I;
          end
        end  
    snoop_readRFO :
      begin
        if(presentState == M)
          begin
             resultResponse = HITM;
                  resultState = I;
          end
        else if(presentState == E)
          begin
             resultResponse = HIT;
             resultState = I;
          end
        else if(presentState == S)
          begin
         resultResponse = HIT;
               resultState = I;
          end
        else
          begin
            
          end
      end  
    clear:
      begin
        resultState = I;
      end  
    print_cache :
      begin
        
      end 
      endcase 
    end*/