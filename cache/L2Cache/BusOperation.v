/*
Bus operation function
*/

module BusOperation();
  
  `include "conf.v"
  
  function busRead;
    input [add_size-1:0]address;
    if(busOperation)
    $display("R %h",address);
  endfunction
 
  function busWrite;
    input [add_size-1:0]address;
    if(busOperation)
    $display("W %h",address);
  endfunction
  
 function busModify;
   input [add_size-1:0]address;
   if(busOperation)
   $display("M %h",address);
 endfunction
 
 function busInvalidate;
   input [add_size-1:0]address;
   if(busOperation)
   $display("I %h",address);
 endfunction
  
endmodule