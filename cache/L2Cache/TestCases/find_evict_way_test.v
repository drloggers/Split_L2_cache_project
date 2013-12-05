/*
testing emptyway cache function
*/

module find_evict_way_test();
  `include "conf.v"
cacheModule c();

reg [index_size-1:0]index;
reg [tag_size-1:0]tag;
reg [offset_size-1:0]offset;

reg dummy;
reg [2:0]result,way,command;
integer i;
initial 
begin
  index = 0;
  tag = 12'h111;
  way = 2;
  command = 4'd00;
  for(i=0;i<8;i=i+1)
  begin
  dummy = c.cache_write(index,i,i);
  dummy = c.update_LRU(index,i);
  dummy = c.update_mesi(index,i,i,command,c.GetSnoopResult(4'h0002,R));
  end
  dummy = c.print(0);
  result = c.find_evict_way(index);
  dummy = c.print(0);
  $display("required result : %b :: function returned : %b",3'b000,result);
  
  dummy = c.cache_write(index,8,0);
  dummy = c.update_LRU(index,0);
  dummy = c.update_mesi(index,8,0,command,c.GetSnoopResult(4'h0002,R));
  result = c.find_evict_way(index);
   dummy = c.print(0);
  $display("required result : %b :: function returned : %b",3'b001,result);
end
endmodule


