/*

sample simulation of MESI protocol

*/

module cache_Mesi_new(
input [1:0]presentState,
input [3:0]command,
output reg [1:0]resultState,
output reg [1:0]resultResponse
);

parameter M   =   2'b00;
parameter E   =   2'b01;
parameter S   =   2'b10;
parameter I   =   2'b11;

parameter NoHIT   = 2'b00;
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

always @(command,presentState)
begin
  case(command)
    L1_read:
      begin
        if(presentState == M)
          begin
            resultState = M;
          end
        else if(presentState == E)
          begin
            resultState = E;
          end
        else if(presentState == S)
          begin
            resultState = S;   
          end
        else
          begin
            resultState = E;  
          end
      end
    L1_write :
      begin
        if(presentState == M)
          begin
            resultState = M;
          end
        else if(presentState == E)
          begin
            resultState = M;
          end
        else if(presentState == S)
          begin
            resultState = M;
          end
        else
          begin
            resultState = M;
          end
      end
    L1_inst_read :
      begin
        if(presentState == M)
          begin
              resultState = M;
          end
        else if(presentState == E)
          begin
            resultState = E;
          end
        else if(presentState == S)
          begin
            resultState = S;   
          end
        else
          begin
            resultState = E;  
          end
      end
    snoop_invalidate :
      begin
        resultState = I;
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
end

endmodule

/* begin  
  checkTag(2'b01,2'b10,check);
  $display("%d",check);
end

task checkTag;
  input [2:0]index;
  input [2:0]tag;
  output [2:0]condt;
  begin
    condt = 2'b11;
  end
  
endtask
*/



