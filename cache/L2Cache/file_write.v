// File Write Module




module file_write();
  
  `include"config.v"
  
  integer log_file;
   
   
function bus_display;
  input [7:0]operation;
  input [add_size-1:0]address;
  begin
    if(busOperation)
      if(transout)
        $display("%0s %h",operation,address);
        
      if(fileop)
      begin 
      log_file=$fopen("output.log","a");
      $fwrite(log_file,"\n%0s %h",operation,address);
      $fclose(log_file);
    end
    bus_display=1;
  end
endfunction

function L1_display;
  input [7:0]operation;
  input [add_size-1:0]address;
  begin
    if(L1_cache_comm)
      if(transout)
         $display("L1 %0s %h",operation,address);
         
      if(fileop)   
        begin
      log_file=$fopen("output.log","a");
      $fwrite(log_file,"\nL1 %0s %h",operation,address);
      $fclose(log_file);
    end
    L1_display=1;
  end
endfunction

function snoop_display;
    input [63:0]snoop_result;
    begin
    if(snoopResult)
      if(transout)
         $display("%0s",snoop_result);
         
        if(fileop)
        begin 
       log_file=$fopen("output.log","a");
      $fwrite(log_file,"\n%0s",snoop_result);
      $fclose(log_file);
    end
    snoop_display=1;
  end
endfunction
 
function stats_display;
  input [63:0]hitCount,readOp,writeOp;
  real hitRatio,temp_hitCount,temp_readOp,temp_writeOp;
  integer missCount;
  
    begin
     temp_readOp=readOp;
  temp_writeOp=writeOp;
  temp_hitCount=hitCount;
  missCount=readOp+writeOp-hitCount;
  
  if(temp_readOp+temp_writeOp!=0)
     hitRatio = temp_hitCount*100 /(temp_readOp+temp_writeOp);
   else
     hitRatio=0;
      begin
            $display("---------Cache Statistics--------");
           $display("CPU Reads= %0d\nCPU Writes= %0d\nHits= %0d\nMisses=%0d\nHit Ratio= %0f %0s",readOp,writeOp,hitCount,missCount,hitRatio,"%");
            $display("---------------------------------");
       end
       
       
       if(fileop)
         begin
       log_file=$fopen("output.log","a");
     $fwrite(log_file,"\n%0s","---------Cache Statistics--------");
     $fwrite(log_file,"\nCPU Reads= %0d\nCPU Writes= %0d\nHits= %0d\nMisses=%0d\nHit Ratio= %0f %0s",readOp,writeOp,hitCount,missCount,hitRatio,"%");
     $fwrite(log_file,"\n%0s","---------------------------------");
      $fclose(log_file);
    end
    stats_display=1;
  end
  
endfunction

function string_display;
    input [2047:0]string;
    begin
      if(transout)
         $display("%0s",string);
       
       if(fileop)
       begin  
       log_file=$fopen("output.log","a");
      $fwrite(log_file,"\n%0s",string);
      $fclose(log_file);
    end
    string_display=1;
  end
endfunction

function cache_display;
    input [index_size-1:0]index;
    input [associativity-1:0]way;
    input [1:0]mesi;
    input [tag_size-1:0]tag;
    input [counter_size-1:0]Lru;
    begin
      if(transout)
         $display("   %h         %h      %b     %h    %h",index,way,mesi,tag,Lru);
         
         if(fileop)
           begin
       log_file=$fopen("output.log","a");
      $fwrite(log_file,"\n   %h         %h      %b     %h    %h",index,way,mesi,tag,Lru);
      $fclose(log_file);
    end
    cache_display=1;
  end
endfunction

endmodule 