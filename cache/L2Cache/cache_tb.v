//Cache Testbench 



`include "conf.v"

module cache();
  
/////////////////////////////////
//File Handels 
////////////////////////////////
integer data_file    ; // file handler
integer scan_file,eof    ; // file handler
reg [3:0] command;
reg [31:0]address;
//////////////////////////////


initial
begin
  
  data_file = $fopen("trace.txt", "r");
  eof = $feof(data_file);
   
  while(!eof)
    begin
      scan_file = $fscanf(data_file, "%d %h\n", command,address); 
      eof = $feof(data_file);
      
      case(command)
        `L1DR: begin
              //Call Check Cache Function
              //If hit increment hit count
              //else do bus operation
              //Call Cache Write
               end
         
        `L1DW: begin
              //Call Check Cache Function
              //If Hit Call Cache Write Function
              //Else Call Bus Operation function
              //Call Cache Write 
               end
               
        `L1IR: begin
              //Call Check Cache Function 
              //If Hit increment hit counter
              //Else call bus operation
               end
        
        `SIREQ: begin
              //Call Check Cache 
              //Call Put Snoop Function 
              //Call MESI
                end
        
        `SRREQ: begin
                //Call Check Cache
                //Call Put Snoop Function
                //Call MESI
                end
                
        `SWREQ: begin
                //Call Check Cache
                //Call Put Snoop
                //Call MESI
                end
                
        `SRFO: begin 
               //Call Check Cache 
               //Call Put Snoop
               //Call MESI 
               end
               
        `CCLR: begin
               //Clear all lines 
               end
               
        `PRINT: begin
              //Call print function
                end 
                
        default:begin
                $display("\nSorry, Invalid Command");
                end
                
         
        
        
        
        
      endcase
     
     
     
     
     
  
  
  /* byte_offset=address[`offset_size-1:0];
  index=address[`index_size+`offset_size-1:`offset_size];
 tag=address[(`add_size-1):(`index_size+`offset_size)];
    
    $display("Offset=%h Index=%h Tag=%h",byte_offset,index,tag);
    
   
    
         
    end
    
    for(i=0;i<`set_count;i=i+1)
    begin
    if(~(&cache[i]===1'bx))
    $display("Cache Contents Are Index=%h Tag=%h",i,cache[i]);*/
    
  end
end
  
endmodule 