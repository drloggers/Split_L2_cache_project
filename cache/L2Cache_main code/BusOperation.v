/*
BusOperation.v
Bus Operation Functions
This file includes definitions of all Bus Operation Functions
*/

module BusOperation();
  
  file_write f();
  `include "config.v"
  integer output_file;
  reg dummy;
  
  //Bus Read Function. Prints out R Address 
  function busRead;
    input [add_size-1:0]address;
    begin
    if(busOperation)
    dummy=f.bus_display("R",address);
         
    busRead=1;
  end      
  endfunction
 
  //Bus Write Function. Prints out W Address 
  function busWrite;
    input [add_size-1:0]address;
    begin
    if(busOperation)
    dummy=f.bus_display("W",address);
    
    busWrite=1;
  end
  endfunction
  
  //Bus Modify Function. Prints out M Address
 function busModify;
   input [add_size-1:0]address;
    begin
   if(busOperation)
   dummy=f.bus_display("M",address);
 
busModify=1;
 end
 endfunction
 
 //Bus Invalidate Function. Prints out I Address
 function busInvalidate;
   input [add_size-1:0]address;
   begin
   if(busOperation)
   dummy=f.bus_display("I",address);
   
   busInvalidate=1;
 end
 endfunction
 endmodule