/*

function of MESI protocol

*/
`include "conf.v"
module mesi_function();

function[3:0] mesi_function;
input [1:0]presentState;
input [3:0]command;
reg [1:0]resultState;
reg [1:0]resultResponse;
begin
  case(command)
    L1_read:
      begin
        if(presentState == `M)
            resultState = `M;
        else if(presentState == `E)
            resultState = `E;
          
        else if(presentState == `S)
            resultState = `S;   
          
        else
            resultState = `E;  
          
      end
    L1_write :
      begin
        if(presentState == `M)
            resultState = `M;
                  else if(presentState == `E)
            resultState = `M;
          
        else if(presentState == `S)
            resultState = `M;
                  else
            resultState = `M;
          
      end
    L1_inst_read :
      begin
        if(presentState == `M)
              resultState = `M;
           else if(presentState == `E)
            resultState = `E;
          else if(presentState == `S)
            resultState = `S;   
          else
            resultState = `E;  
                end
    snoop_invalidate :
      begin
        resultState = `I;
      end  
    snoop_read :
      begin
        if(presentState == `M)
          begin
              resultResponse = HITM;
              resultState = `S;
          end
        else if(presentState == `E)
          begin
              resultResponse = HIT;
              resultState = `S;
          end
        else if(presentState == `S)
            resultState = `S;
        else
          begin
            resultResponse = HIT;
            resultState = `S;
          end
      end  
    snoop_write :
      begin
      if(presentState == `M)
          begin
              resultResponse = HITM;
              resultState = `I;
          end
        else if(presentState == `E)
          begin
            resultResponse = HIT;
            resultState = `I;
          end
        else if(presentState == `S)
          begin
            resultResponse = HIT;
                resultState = `I;
          end
        else
            resultState = `I;
        end  
    snoop_readRFO :
      begin
        if(presentState == `M)
          begin
             resultResponse = HITM;
                  resultState = `I;
          end
        else if(presentState == `E)
          begin
             resultResponse = HIT;
             resultState = `I;
          end
        else if(presentState == `S)
          begin
         resultResponse = HIT;
               resultState = `I;
          end
      end  
    clear:
      begin
        resultState = `I;
      end  
   
      endcase 
      mesi_function = {resultState,resultResponse};
end
endfunction
endmodule




