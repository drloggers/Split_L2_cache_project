/****************************************************************************************************************************************
*****************************************************************************************************************************************
Main module file which takes input as trace file and simulates the L2 cache.
The parameters of the L2 cache can be set in the conf.v file. 
*****************************************************************************************************************************************
****************************************************************************************************************************************/

`include "conf.v"

module cache_l2();
  
//Instantiation of Cache Memory. Further referenced as m.cache[set][column]
cacheModule c();  //change this variable name to L2_cache_module
mesi_function m();//change this to mesi_functions
BusOperation bus();

  parameter offset_size=`offset_size;
  
//File Handlers 
integer data_file    ; // file handler
integer scan_file,eof    ; // file handler

reg [3:0] command;
reg [31:0]address;

//cache specific variables
reg [`index_size-1:0]index;
reg [`tag_size-1:0]tag;
reg [`offset_size-1:0]offset;

//Variables for maintaining count
real hitCount,readOp,writeOp,hitRatio;

//process variables
reg[3:0]response,a;
reg [3:0]result,way, mesiState;
reg dummy;
initial
  begin
    data_file = $fopen(`file_name, "r");
    eof = $feof(data_file);
    hitCount = 0; readOp = 0; writeOp = 0; dummy=c.init_evict_count(0);
    while(!eof)
      begin
        scan_file = $fscanf(data_file, "%d %h\n", command,address); 
        eof = $feof(data_file);
      
        // calculating the parameters
        offset=address[`offset_size-1:0];
        index=address[`index_size+`offset_size-1:`offset_size];
        tag=address[(`add_size-1):(`index_size+`offset_size)];
     
        if(`debug) // set this only during debugging
          begin
             $display("Address is=%h",address);
             $display("Offset=%h Index=%h Tag=%h",offset,index,tag);
          end
    
      case(command)
        `L1_DataCacheRead: begin
                            readOp = readOp + 1;
                            result = c.check_cache(index,tag);  //Call Check Cache Function
                            if(!result[0])    //if its not hit, then get it from memory
                              begin
                                way = c.empty_way(index); 
                                if(way === 3'bxxx)
                                  begin
                                    way = c.find_evict_way(index);
                                    dummy = c.evict_way(index,way);
                                    if(`L1_cache_comm)
                                    $display("L1_cache I %h",address);
                                  end
                                dummy = c.cache_write(index,tag,way);
                                if(c.set_mesi(index,tag,way,command,c.GetSnoopResult(address,`R)))
                                  dummy = c.LRU(index,way);
                                else
                                  $display("Error in mesi function");
                              end
                            else        //If hit increment hit count
                              begin
                                hitCount = hitCount + 1;
                               // $display("cache HIT");
                                dummy = c.LRU(index,result[3:1]);
                              end
                            //Call Cache Write
                          end
         
        `L1_DataCacheWrite: begin
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
                                      if(`L1_cache_comm)
                                      $display("L1_cache I %h",address);
                                    end
                                  //dummy = bus.busRead({tag,index,{offset_size{1'b0}}});
                                  dummy = c.cache_write(index,tag,way);
                                  if(c.set_mesi(index,tag,way,command,c.GetSnoopResult(address,`W)))
                                  dummy = c.LRU(index,way);
                                  //Else Call Bus Operation function
                                  //Call Cache Write
              
                                end
                                //If Hit Call Cache Write Function
                              else
                                begin
                                  hitCount = hitCount + 1;
                               //   $display("Cache is write HIT");
                                  dummy = c.cache_write(index,tag,result[3:1]);
                                  if(c.set_mesi(index,tag,result[3:1],command,c.GetSnoopResult(address,`W)))
                                    dummy = c.LRU(index,result[3:1]);
                                end 
                          end
               
        `L1_InstructionCacheRead: begin
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
                                          if(`L1_cache_comm)
                                          $display("L1_cache I %h",address);
                                          end
                                        dummy = c.cache_write(index,tag,way);
                                        if(c.set_mesi(index,tag,way,command,c.GetSnoopResult(address,`R)))
                                          dummy = c.LRU(index,way);
                                        else
                                          $display("Error in mesi function");
                                      end
                                    else
                                      begin
                                        hitCount = hitCount + 1;
                                   //     $display("cache HIT");
                                        dummy = c.LRU(index,result[3:1]);
                                      end
                                      //Call Cache Write
                                  end
        `SnoopInvalidateRequest: begin
                                  //Call Check Cache 
                                  result = c.check_cache(index,tag);
                                  //Call Put Snoop Function 
                                  if(result[0])
                                    begin
                                   //   dummy = c.PutSnoopResult(address,`I);
                                      //Call MESI
                                      dummy = c.invalidateLine(index,result[3:1]);
                                      dummy = c.invalidate_lru(index,way);
                                      if(`L1_cache_comm)
                                      $display("L1_cache I %h",address);
                                    end
                                  end
        
        `SnoopReadRequest: begin
                            //Call Check Cache
                            result = c.check_cache(index,tag);
                            //Call Put Snoop Function 
                            case(c.PutSnoopResult(address,`R))
                                `HIT:begin
                                    if(`snoopResult)
                                      $display("SR HIT");
                                     end
                                
                                `NoHIT:begin
                                      if(`snoopResult)
                                      $display("SR no HIT");
                                     end
                                
                                `HITM:begin
                                      if(`snoopResult)
                                      $display("SR HITM");
                                     end
                              endcase
                            if(result[0])
                               //Call MESI
                               dummy = c.set_mesi(index,tag,result[3:1],command,`HIT);
                           end
                
        `SnoopWriteRequest: begin
                            //Call Check Cache
                            result = c.check_cache(index,tag);
                            //Call Put Snoop Function 
                            case(c.PutSnoopResult(address,`W))
                                `HIT:begin
                                      if(`snoopResult)
                                      $display("SR HIT");
                                     end
                                
                                `NoHIT:begin
                                      if(`snoopResult)
                                      $display("SR no HIT");
                                     end
                                
                                `HITM:begin
                                      if(`snoopResult)
                                      $display("SR HITM");
                                     end
                              endcase
                            if(result[0])
                               //Call MESI
                               dummy = c.set_mesi(index,tag,result[3:1],command,`HIT);
                            end
                
        `SnoopRFO: begin 
                    //Call Check Cache 
                            result = c.check_cache(index,tag);
                            //Call Put Snoop Function 
                            case(c.PutSnoopResult(address,`M))
                                `HIT:begin
                                      if(`snoopResult)
                                      $display("SR HIT");
                                     end
                                
                                `NoHIT:begin
                                      if(`snoopResult)
                                      $display("SR no HIT");
                                     end
                                
                                `HITM:begin
                                      if(`snoopResult)
                                      $display("SR HITM");
                                     end
                              endcase
                            if(result[0])
                               //Call MESI
                               dummy = c.set_mesi(index,tag,result[3:1],command,`HITM);
               end
               
        `ClearCache: begin
                      //Clear all lines
                      $display("hit=%d,read=%d,write=%d,hit ratio=%f %s",hitCount,readOp,writeOp,hitRatio,"%");
                      hitCount = 0; readOp = 0; writeOp = 0;
                      dummy = c.clearCache(0);
               end
               
        `PrintCache: begin
                       //Call print function
                       dummy = c.print(0);
                end 
                
        default:begin
                $display("\n This Command-->%d is not supported by current version. Please contact Sanket,Sameer and Rob", command);
                end
      endcase
     if(`debug)
      dummy = c.print(0);
  end
  hitRatio = hitCount*100 /(readOp+writeOp);
  $display("hit = %d, read = %d, write = %d, hit ratio= %f %s",hitCount,readOp,writeOp,hitRatio,"%");
  if(`debug)
    $display("evict count = %d",c.show_evict_count(0));
end
  
endmodule 