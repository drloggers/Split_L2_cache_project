/****************************************************************************************************************************************
*****************************************************************************************************************************************
Main module file which takes input as trace file and simulates the L2 cache.
The parameters of the L2 cache can be set in the conf.v file. 
*****************************************************************************************************************************************
****************************************************************************************************************************************/


module cache_l2();
  
`include "config.v"


  
//Instantiation of Cache Memory. Further referenced as m.cache[set][column]
cacheModule c();  //change this variable name to L2_cache_module
file_write f();


  
//File Handlers 
integer data_file, output_file    ; // file handler
integer scan_file,eof    ; // file handler
reg [256:0] testname;
reg [3:0] command;
reg [31:0]address;



//cache specific variables
reg [index_size-1:0]index;
reg [tag_size-1:0]tag;
reg [offset_size-1:0]offset;

//Variables for maintaining count
real hitCount,readOp,writeOp,hitRatio;

//process variables
reg[3:0]response,a;
reg [3:0]result,way, mesiState;
reg [1:0]SnoopResult;
reg dummy;
initial
  begin
    
    
    if ($value$plusargs("TRACE=%s", testname)) 
begin
    dummy = f.string_display(testname);
end
else 
  begin
  dummy = f.string_display("Error: Test Not Specified in Command Line. The syntax is: vsim -novopt cache_l2 +TRACE=<Trace To Be Run>");
  dummy = f.string_display("Simulation Halted. Please spcecify a trace file to run.");
  $stop;
end





//$finish;
    data_file = $fopen(testname, "r");
    output_file = $fopen({testname,".out"},"w");
   eof = $feof(data_file);
    hitCount = 0; readOp = 0; writeOp = 0; 
    while(!eof)
      begin
        scan_file = $fscanf(data_file, "%b", command);
        if(~(command== 4'b0111 || command ==4'b1000 || command ==4'b1001) )
        scan_file = $fscanf(data_file,"%h\n", address); 
        eof = $feof(data_file);
      $display("command : %d",command);
      if( address==={add_size{1'bx}} && ((command!=ClearCache)||(command!=PrintCache)||(command === 1'bx)))
        begin
          dummy = f.string_display("Error in Trace File. Missing address. Please provide correct trace file.");
          $stop;
        end
        
   
        
        // calculating the parameters
        offset=address[offset_size-1:0];
        index=address[index_size+offset_size-1:offset_size];
        tag=address[(add_size-1):(index_size+offset_size)];
     
        if(debug) // set this only during debugging
          begin
             $display("Address is=%h",address);
             $display("Offset=%h Index=%h Tag=%h",offset,index,tag);
          end
  
      case(command)
        L1_DataCacheRead: begin
                            readOp = readOp + 1;
                            result = c.check_cache(index,tag);  //Call Check Cache Function
                           SnoopResult = c.GetSnoopResult(address,R); 
                            if(!result[0])    //if its not hit, then get it from memory
                              begin
                                way = c.empty_way(index); 
                                if(way === 3'bxxx)
                                  begin
                                    way = c.find_evict_way(index);
                                    dummy = c.evict_way(index,way);
                                  end
                                 dummy=f.L1_display("M",address); 
                                dummy = c.cache_write(index,tag,way);
                                if(c.update_mesi(index,tag,way,command,SnoopResult))
                                  dummy = c.update_LRU(index,way);
                                else
                                  $display("Error in mesi function");
                              end
                            else        //If hit increment hit count
                              begin
                                hitCount = hitCount + 1;
                                dummy=f.L1_display("H",address); 
                               // $display("cache HIT");
                               dummy=c.update_mesi(index,tag,way,command,SnoopResult);                           
                                dummy = c.update_LRU(index,result[3:1]);
                              end
                            //Call Cache Write
                          end
         
        L1_DataCacheWrite: begin
                              writeOp = writeOp + 1;
                              //Call Check Cache Function
                              result = c.check_cache(index,tag);
                              if(!result[0])
                                begin
                                  //$display("Cache is written from memory");
                                  way = c.empty_way(index);
                                  if(way === 3'bxxx)// all ways are filled
                                    begin
                                      way = c.find_evict_way(index);
                                      dummy = c.evict_way(index,way);
                                  
                                    end
                                  //dummy = bus.busRead({tag,index,{offset_size{1'b0}}});
                                  dummy=f.L1_display("M",address); 
                                  dummy = c.cache_write(index,tag,way);
                                  if(c.update_mesi(index,tag,way,command,c.GetSnoopResult(address,W)))
                                  dummy = c.update_LRU(index,way);
                                  //Else Call Bus Operation function
                                  //Call Cache Write
              
                                end
                                //If Hit Call Cache Write Function
                              else
                                begin
                                  hitCount = hitCount + 1;
                                  dummy=f.L1_display("H",address); 
                               //   $display("Cache is write HIT");
                                  dummy = c.cache_write(index,tag,result[3:1]);
                                  if(c.update_mesi(index,tag,result[3:1],command,c.GetSnoopResult(address,W)))
                                    dummy = c.update_LRU(index,result[3:1]);
                                end 
                          end
               
        L1_InstructionCacheRead: begin
                                    readOp = readOp + 1;
                                    //Call Check Cache Function
                                    result = c.check_cache(index,tag);
                                    //If hit increment hit count
                                    //else do bus operation
                                    if(!result[0])
                                      begin
                                        //$display("Cache is read from memory");
                                        way = c.empty_way(index);
                                        if(way === 3'bxxx)
                                          begin
                                          way = c.find_evict_way(index);
                                          dummy = c.evict_way(index,way);
                                          end
                                          dummy=f.L1_display("M",address); 
                                        dummy = c.cache_write(index,tag,way);
                                        if(c.update_mesi(index,tag,way,command,c.GetSnoopResult(address,R)))
                                          dummy = c.update_LRU(index,way);
                                        else
                                          $display("Error in mesi function");
                                      end
                                    else
                                      begin
                                        hitCount = hitCount + 1;
                                        dummy=f.L1_display("H",address); 
                                   //     $display("cache HIT");
                                   dummy=c.update_mesi(index,tag,way,command,SnoopResult); 
                                        dummy = c.update_LRU(index,result[3:1]);
                                      end
                                      //Call Cache Write
                                  end
        SnoopInvalidateRequest: begin
                                  //Call Check Cache 
                                  result = c.check_cache(index,tag);
                                  //Call Put Snoop Function 
                                  if(result[0])
                                    begin
                                   //   dummy = c.PutSnoopResult(address,`I);
                                      //Call MESI
                                     dummy = c.update_mesi(index,tag,way,command,c.GetSnoopResult(address,I)); 
                                          
                                    end
                                  end
        
        SnoopReadRequest: begin
                            //Call Check Cache
                            result = c.check_cache(index,tag);
                            //Call Put Snoop Function 

                            case(c.PutSnoopResult(address,R))
                                HIT:begin
                                    dummy=f.snoop_display("SR HIT");
                                     end
                                
                                NoHIT:begin
                                     dummy=f.snoop_display("SR NoHIT");
                                     end
                                
                                HITM:begin
                                     dummy=f.snoop_display("SR HITM");
                                     end
                              endcase
                            if(result[0])
                               //Call MESI
                               dummy = c.update_mesi(index,tag,result[3:1],command,HIT);
                           end
                
        SnoopWriteRequest: begin
                            //Call Check Cache
                            result = c.check_cache(index,tag);
                            //Call Put Snoop Function 
                            
                            if(result[0])
                               //Call MESI
                              //$display("there is something fuzzy going on during write!!!!");
dummy = c.update_mesi(index,tag,result[3:1],command,NoHIT);
                            end
                
        SnoopRFO: begin 
                    //Call Check Cache 
                            result = c.check_cache(index,tag);
                            //Call Put Snoop Function 
                            case(c.PutSnoopResult(address,M))
                                HIT:begin
                                    dummy=f.snoop_display("SR HIT");
                                     end
                                
                                NoHIT:begin
                                     dummy=f.snoop_display("SR NoHIT");
                                     end
                                
                                HITM:begin
                                     dummy=f.snoop_display("SR HITM");
                                     end
                              endcase
                            if(result[0])
                               //Call MESI
                               dummy = c.update_mesi(index,tag,result[3:1],command,NoHIT);
               end
               
        ClearCache: begin
                      //Clear all lines
                 
                      dummy=f.stats_display(hitCount,readOp,writeOp);
                      hitCount = 0; readOp = 0; writeOp = 0;
                      dummy = c.clearCache(0);
               end
               
        PrintCache: begin
                       //Call print function
                       dummy = c.print(0);
                end 
                
        default:begin
                dummy = f.string_display("This Command is not supported by the current version. Please contact us");
                end
      endcase
      
     if(debug)
      dummy = c.print(0);
  end
  
 $fclose(data_file);
  
   dummy=f.stats_display(hitCount,readOp,writeOp);
  
  dummy = f.string_display("xxxxxxxxxxxxxxx END OF TRACE FILE xxxxxxxxxxxxxxx \n\n\n\n");
  
end
  
endmodule 