// Parameter Checker 
//This function checks sizes of Tag, Index and Offset
// Makes sure that Tag+Index+Offset is NOT greater than Address Size 

function parameter_check;

`include "conf.v"
        input a;
  begin
    if(tag_size+index_size+offset_size>add_size)
      parameter_check=1;
    else
      parameter_check=0;
    
  end
  endfunction