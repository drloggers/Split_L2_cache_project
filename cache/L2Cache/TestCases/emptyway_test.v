/*
testing emptyway cache function
*/
`include "conf.v"
module emptyway_test();
cacheModule c();

reg [`index_size-1:0]index;
reg [`tag_size-1:0]tag;
reg [`offset_size-1:0]offset;

reg dummy;
reg [2:0]result,way,command,i;
initial 
begin
  index = 0;
  tag = 12'h111;
  way = 2;
  command = 2'b01;
  for(i=0;i<7;i=i+1)
  begin
  dummy = c.cache_write(index,i,i);
  dummy = c.LRU(index,i);
  dummy = c.set_mesi(index,i,i,command,c.GetSnoopResult(4'h0000,`R));
  end
  result = c.empty_way(index);
  $display("required result : %b :: function returned : %b",3'b111,result);
  dummy = c.cache_write(index,3'b111,3'b111);
  dummy = c.LRU(index,1'd7);
  dummy = c.set_mesi(index,3'b111,3'b111,command,c.GetSnoopResult(4'h0000,`R));
  result = c.empty_way(index);
  $display("required result : %b :: function returned : %b",3'bxxx,result);
end
endmodule

