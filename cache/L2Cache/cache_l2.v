//Cache Testbench 



`include "conf.v"

module cache_l2();
  
//Instantiation of Cache Memory. Further referenced as m.cache[set][column]
check_cache c();

//File Handels 
integer data_file    ; // file handler
integer scan_file,eof    ; // file handler
reg [3:0] command;
reg [31:0]address;

reg [`index_size-1:0]index;
reg [`tag_size-1:0]tag;
reg [`offset_size-1:0]offset;
reg[3:0]response,a;


initial
begin
  
  data_file = $fopen("trace.txt", "r");
  eof = $feof(data_file);
   
  while(!eof)
    begin
      scan_file = $fscanf(data_file, "%d %h\n", command,address); 
      eof = $feof(data_file);
      
      offset=address[`offset_size-1:0];
      index=address[`index_size+`offset_size-1:`offset_size];
      tag=address[(`add_size-1):(`index_size+`offset_size)];
      
      if(`debug)
        begin
    $display("Address is=%b",address);
    $display("Offset=%h Index=%h Tag=%h",offset,index,tag);
    
    response=c.check_cache(index,tag);
    $display("Response Is=%b",response);
    a=c.LRU(index,response[`counter_size:1]);
    $display("evicted  way : %b", c.evict_this_way(index));
        end
    
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
     
     
     
     
     
  
  
  /* 
    
   
    
         
    end
    
    for(i=0;i<`set_count;i=i+1)
    begin
    if(~(&cache[i]===1'bx))
    $display("Cache Contents Are Index=%h Tag=%h",i,cache[i]);*/
    
  end
end
  
endmodule 