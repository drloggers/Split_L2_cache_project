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
integer hitCount,readOp,writeOp;
reg [3:0]result,way;
reg dummy;
initial
begin
  
  data_file = $fopen("trace.txt", "r");
  eof = $feof(data_file);
   hitCount = 0;
   readOp = 0;
   writeOp = 0;
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
   // response=c.check_cache(index,tag);
   // $display("Response Is=%b",response);
   // a=c.LRU(index,response[`counter_size:1]);
   // $display("evicted  way : %b", c.evict_this_way(index));
    
   //$display("reading from address : %b :: valid bits : %b",address,c.check_cache(index,tag));
        end
    
      case(command)
        `L1DR: begin
              readOp = readOp + 1;
              //Call Check Cache Function
              result = c.check_cache(index,tag);
              //If hit increment hit count
              //else do bus operation
              if(!result[0])
                begin
                $display("Cache is read from memory");
                way = c.empty_way(index);
                if(way === 3'bxxx)
                way = c.find_evict_way(index);
                dummy = c.cache_write(index,tag,way);
                dummy = c.cache_DV_write(10,index,tag,way);
                dummy = c.LRU(index,way);
              end
              else
                begin
                  hitCount = hitCount + 1;
                $display("cache HIT");
                dummy = c.LRU(index,result[3:1]);
              end
              //Call Cache Write
               end
         
        `L1DW: begin
              writeOp = writeOp + 1;
              //Call Check Cache Function
              result = c.check_cache(index,tag);
              if(!result[0])
                begin
               $display("Cache is read from memory");
                way = c.empty_way(index);
                if(way === 3'bxxx)
                way = c.find_evict_way(index);
                dummy = c.cache_write(index,tag,way);
                dummy = c.cache_DV_write(10,index,tag,way);
                dummy = c.LRU(index,way);
              //Else Call Bus Operation function
              //Call Cache Write
              
            end
            //If Hit Call Cache Write Function
          else
            begin
              $display("Cache is write HIT");
            dummy = c.cache_write(index,result[3:1]);
            dummy = c.cache_DV_write(11,index,tag,result[3:1]);
            dummy = c.LRU(index,result[3:1]);
          end 
               end
               
        `L1IR: begin
              readOp = readOp + 1;
              //Call Check Cache Function
              result = c.check_cache(index,tag);
              //If hit increment hit count
              //else do bus operation
              if(!result[0])
                begin
                $display("Instruction Cache is read from memory");
                way = c.empty_way(index);
                if(way === 3'bxxx)
                way = c.find_evict_way(index);
                dummy = c.cache_write(index,tag,way);
                dummy = c.cache_DV_write(10,index,tag,way);
                dummy = c.LRU(index,way);
              end
              else
                begin
                  hitCount = hitCount + 1;
                $display("Instruction cache HIT");
                dummy = c.LRU(index,result[3:1]);
              end
              //Call Cache Write
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
              dummy = c.print(0);
                end 
                
        default:begin
                $display("\n This Command is not supported by current version. Please contact Sameer,Sanket and Rob");
                end
                
         
        
        
        
        
      endcase
     
     
     
     
     
  
  
  /* 
    
   
    
         
    end
    
    for(i=0;i<`set_count;i=i+1)
    begin
    if(~(&cache[i]===1'bx))
    $display("Cache Contents Are Index=%h Tag=%h",i,cache[i]);*/
    
  end
  $display("hit = %d, read = %d",hitCount,readOp);
end
  
endmodule 