/*
testing mesi_function function
*/

module mesi_function_test();
  
// `include "conf.v"

parameter Modified = 2'b00,
          Exclusive = 2'b01,
          Shared = 2'b10,
          Invalid = 2'b11;

parameter NoHIT = 2'b00,
          HIT   = 2'b01,
          HITM  = 2'b10;
          
parameter L1_DataCacheRead = 0,
          L1_DataCacheWrite = 1,
          L1_InstructionCacheRead = 2,
          SnoopInvalidateRequest = 3,
          SnoopReadRequest = 4,
          SnoopWriteRequest = 5,
          SnoopRFO = 6,
          ClearCache = 8,
          PrintCache = 9;

mesi_function mesi();


reg [1:0]presentState;
reg [3:0]command;
//reg [1:0]snoopResult;

reg [3:0]result;

initial
begin

// Modified 

result = mesi.mesi(Modified, SnoopReadRequest, NoHIT);
$display("present_state = Modified, Command = SnoopReadRequest, SnoopResult = x (we do not care when present state is modified)");
$display("actual result = %b, expected result = 1010 ", result);

result = mesi.mesi(Modified, L1_DataCacheRead, NoHIT);
$display("present_state = Modified, Command = L1_DataCacheRequest, SnoopResult = x (we do not care when present state is modified)");
$display("actual result = %b, expected result = 00xx ", result);

result = mesi.mesi(Modified, SnoopRFO, NoHIT);
$display("present_state = Modified, Command = SnoopRFO, SnoopResult = x (we do not care when present state is modified)");
$display("actual result = %b, expected result = 1110 ", result);


$display("present_state = Modified, Command = SnoopWriteRequest, SnoopResult = x (we do not care when present state is modified) ");
result = mesi.mesi(Modified, SnoopWriteRequest, NoHIT);
$display("actual result = %b, expected result = 00xx ", result);

$display("present_state = Modified, Command = SnoopInvalidateRequest, SnoopResult = x (we do not care when present state is modified) ");
result = mesi.mesi(Modified, SnoopInvalidateRequest, NoHIT);
$display("actual result = %b, expected result = 00xx and error message", result);

// Exclusive

$display("present_state = Exclusive, Command = SnoopReadRequest, SnoopResult = x (we do not care when present state is Exclusive) ");
result = mesi.mesi(Exclusive,SnoopReadRequest , NoHIT);
$display("actual result = %b, expected result = 10xx ", result);

$display("present_state = Exclusive, Command = SnoopRFO, SnoopResult = x (we do not care when present state is Exclusive) ");
result = mesi.mesi(Exclusive, SnoopRFO , NoHIT);
$display("actual result = %b, expected result = 11xx ", result);

$display("present_state = Exclusive, Command = L1_DataCacheWrite, SnoopResult = x (we do not care when present state is Exclusive) ");
result = mesi.mesi(Exclusive, L1_DataCacheWrite , NoHIT);
$display("actual result = %b, expected result = 00xx ", result);

$display("present_state = Exclusive, Command = SnoopWriteRequest, SnoopResult = x (we do not care when present state is Exclusive) ");
result = mesi.mesi(Exclusive, SnoopWriteRequest, NoHIT);
$display("actual result = %b, expected result = 01xx and error message ", result);

$display("present_state = Exclusive, Command = SnoopInvalidateRequest, SnoopResult = x (we do not care when present state is Exclusive) ");
result = mesi.mesi(Exclusive, SnoopInvalidateRequest , NoHIT);
$display("actual result = %b, expected result = 01xx and error message", result);

// Shared

$display("present_state = Shared, Command = SnoopReadRequest, SnoopResult = x (we do not care when present state is Shared) ");
result = mesi.mesi(Shared, SnoopReadRequest , NoHIT);
$display("actual result = %b, expected result = 10xx ", result);

$display("present_state = Shared, Command = SnoopInvalidateRequest, SnoopResult = x (we do not care when present state is Shared) ");
result = mesi.mesi(Shared, SnoopInvalidateRequest , NoHIT);
$display("actual result = %b, expected result = 11xx ", result);

$display("present_state = Shared, Command = SnoopRFO, SnoopResult = x (we do not care when present state is Shared) ");
result = mesi.mesi(Shared, SnoopRFO , NoHIT);
$display("actual result = %b, expected result = 11xx ", result);

$display("present_state = Shared, Command = L1DataCacheWrite, SnoopResult = x (we do not care when present state is Shared) ");
result = mesi.mesi(Shared, L1_DataCacheWrite , NoHIT);
$display("actual result = %b, expected result = 0000 ", result);

$display("present_state = Shared, Command = SnoopWriteRequest, SnoopResult = x (we do not care when present state is Shared) ");
result = mesi.mesi(Shared, SnoopWriteRequest , NoHIT);
$display("actual result = %b, expected result = 10xx and error message ", result);


// Invalid

$display("present_state = Invalid, Command = L1_DataCacheRead, SnoopResult = HIT");
result = mesi.mesi(Invalid, L1_DataCacheRead , HIT);
$display("actual result = %b, expected result = 1001 ", result);

$display("present_state = Invalid, Command = L1_InstructionCacheRead, SnoopResult = HIT");
result = mesi.mesi(Invalid, L1_InstructionCacheRead , HIT);
$display("actual result = %b, expected result = 1001 ", result);

$display("present_state = Invalid, Command = L1_DataCacheRead, SnoopResult = HITM");
result = mesi.mesi(Invalid, L1_DataCacheRead , HITM);
$display("actual result = %b, expected result = 1001 ", result);

$display("present_state = Invalid, Command = L1_InstructionCacheRead, SnoopResult = No_HIT");
result = mesi.mesi(Invalid, L1_InstructionCacheRead , HITM);
$display("actual result = %b, expected result = 1001 ", result);

$display("present_state = Invalid, Command = L1_DataCacheRead, SnoopResult = NoHIT");
result = mesi.mesi(Invalid, L1_DataCacheRead , NoHIT);
$display("actual result = %b, expected result = 0101 ", result);

$display("present_state = Invalid, Command = L1_InstructionCacheRead, SnoopResult = NoHIT");
result = mesi.mesi(Invalid, L1_InstructionCacheRead , NoHIT);
$display("actual result = %b, expected result = 0101 ", result);

$display("present_state = Invalid, Command = L1_DataCacheWrite, SnoopResult = x");
result = mesi.mesi(Invalid, L1_DataCacheWrite , HIT);
$display("actual result = %b, expected result = 0011 ", result);

end
endmodule
