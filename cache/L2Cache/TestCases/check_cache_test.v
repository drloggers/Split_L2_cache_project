/*
testing check cache function
*/

module check_cache_test();
  `include "conf.v"
cacheModule c();

reg [index_size-1:0]index;
reg [tag_size-1:0]tag;
reg [offset_size-1:0]offset;

reg dummy;
reg [3:0]result,way,command;
initial 
begin
  index = 0;
  tag = 12'h111;
  way = 2;
  command = 2'b01;
  dummy = c.cache_write(index,tag,way);
  dummy = c.update_LRU(index,way);
  dummy = c.update_mesi(index,tag,way,command,c.GetSnoopResult(4'h0000,R));
  result = c.check_cache(index, tag);
 /*
Returned values are LSB indicates hit or miss. Remaining bit specify the way in which hit was found
*/
  $display("required result : %b :: function returned : %b",{3'b010,1'b1},result);
index = 1'd1;
result = c.check_cache(index, tag);
  $display("required result : %b :: function returned : %b",{3'b000,1'b0},result);

end
endmodule
