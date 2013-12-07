/****************************************************************************************************************************************
*****************************************************************************************************************************************
functions to implement MESI protocol
*****************************************************************************************************************************************
****************************************************************************************************************************************/


module mesi_function();
`include "config.v"
file_write f();
reg dummy;
/*
returns the next mesi state and the bus operation that is required to perform
*/
function[3:0] mesi;
  input [1:0]presentState;
  input [3:0]command;
  input [1:0]snoopResult;
  begin
    mesi={presentState,nothing};
   case(presentState)
    Modified: begin
        if(command == SnoopReadRequest)
          mesi = {Shared, memoryWrite};
        else if(command == SnoopRFO)
          mesi = {Invalid,memoryWrite};
      else
          begin
          if(command == SnoopWriteRequest)
          dummy=f.string_display("modified line cannot be written back by other L2 cache.");
          else if(command == SnoopInvalidateRequest)
            begin
          dummy=f.string_display("cannot invalidate a line that is in modified state.");
        end
          
        else
        mesi = {Modified, nothing};
        end
      end
    Exclusive: begin
        if(command == SnoopReadRequest)
          mesi = {Shared,nothing};
        else if(command == SnoopRFO)
          mesi = {Invalid,nothing};
        else if(command == L1_DataCacheWrite)
          mesi = {Modified,nothing};
        else 
          begin
          if(command == SnoopWriteRequest)
          dummy=f.string_display("exclusive line cannot be written back by other L2 cache.");
          else if(command == SnoopInvalidateRequest)
          dummy=f.string_display("cannot invalidate a line that is in exclusive state.");
          else
        mesi = {Exclusive, nothing};
        end
      end
    Shared: begin
        if(command == SnoopReadRequest)
          mesi = {Shared,nothing};
        else if(command == SnoopInvalidateRequest || command == SnoopRFO)
          mesi = {Invalid,nothing};
        else if(command == L1_DataCacheWrite)
          mesi = {Modified,invalidate};
        else
          begin
          
          if(command == SnoopWriteRequest)
          dummy=f.string_display("Shared Line cannot be written back by other L2 cache.");
          mesi = {Shared,nothing};
        end
        end
    Invalid: begin
        if((command == L1_DataCacheRead || command == L1_InstructionCacheRead) && (snoopResult == HIT || snoopResult == HITM))
          mesi = {Shared,memoryRead};
        else if((command == L1_DataCacheRead || command == L1_InstructionCacheRead) && snoopResult == NoHIT)
          mesi = {Exclusive,memoryRead};
        else if(command == L1_DataCacheWrite)
          mesi = {Modified,RFO};
        else
          mesi = {Invalid,nothing};
        end
    default:begin
          if((command == L1_DataCacheRead || command == L1_InstructionCacheRead) && (snoopResult == HIT || snoopResult == HITM))
          mesi = {Shared,memoryRead};
        else if((command == L1_DataCacheRead || command == L1_InstructionCacheRead) && snoopResult == NoHIT)
          mesi = {Exclusive,memoryRead};
        else if(command == L1_DataCacheWrite)
          mesi = {Modified,RFO};
        else
          mesi = {Invalid,nothing};
        end
   endcase
  end
 endfunction
endmodule