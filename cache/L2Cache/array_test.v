// Array Test 


`include "conf.v"

module array_test();
  
  cache_mem m();
  integer i,j;
  initial
  begin
    
    for(j=0;j<`set_count;j=j+1)
    begin
    for(i=0;i<`associativity;i=i+1)
    begin
      m.cache[j][i]=$random();
    end
  end
  
  for(j=0;j<`set_count;j=j+1)
    begin
    for(i=0;i<`associativity;i=i+1)
    begin
      $display("Content At %d Index %d Column = %d",j,i,m.cache[j][i]);
    end
    
    
  end
 $finish(); 
      
  end
endmodule