/*
Bus operation function
*/
`include "conf.v"
module BusOperation();
  
  function busRead;
    input [31:0]address;
    $display("R %b",address);
  endfunction
 
  function busWrite;
    input [31:0]address;
    $display("W %b",address);
  endfunction
  
 function busModify;
   input [31:0]address;
   $display("M %b",address);
 endfunction
 
 function busInvalidate;
   input [31:0]address;
   $display("I %b",address);
 endfunction
  
endmodule