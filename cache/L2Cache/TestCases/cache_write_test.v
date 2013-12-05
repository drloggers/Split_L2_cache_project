/*
cache write test
*/

module cache_write_test();
  `include "conf.v"
cacheModule c();
reg [index_size-1:0]index;
reg [tag_size-1:0]tag;
reg [offset_size-1:0]offset;

reg dummy;
reg [2:0]way,command,i;
reg[3:0] result;
initial 
begin
  index = 0;
  tag = 12'h111;
  way = 2;
  command = 2'b01;
  dummy = c.cache_write(index,tag,way);
  dummy = c.update_mesi(index,tag,way,command,c.GetSnoopResult(4'h0000,R));
  result = c.check_cache(index,tag);
  $display("written data at index:0 way:2 tag:111\n----> found at %d:way", result[3:1]);
  
end
endmodule