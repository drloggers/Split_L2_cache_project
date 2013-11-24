// Reverse Address Finder 

`include "conf.v"

module radd();
  
integer data_file    ; // file handler
integer scan_file,eof    ; // file handler
reg [`index_size-1:0]index;
reg [`counter_size-1:0]=way;


initial
begin
  
   data_file = $fopen("trace.txt", "r");
  eof = $feof(data_file);
   
  while(!eof)
  begin
    
  end
  
  
end
  
endmodule 