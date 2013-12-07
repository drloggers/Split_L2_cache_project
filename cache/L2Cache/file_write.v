// File Write Module




module file_write();
  
  `include"config.v"
  
  integer log_file;
   
   
function automatic bus_display;
  input [7:0]operation;
  input [add_size-1:0]address;
  begin
    if(busOperation)
      if(transout)
        $display("%0s %h",operation,address);
       log_file=$fopen("output.log","a");
      $fwrite(log_file,"\n%0s %h",operation,address);
      $fclose(log_file);
  end
endfunction

function automatic [255:0]log_filename;
    input [255:0]testfile;
    input w;
  
  begin
    if(w)
    log_filename={testfile,".out"};
  else
    log_filename=log_filename;
  end
endfunction


function L1_display;
  input [7:0]operation;
  input [add_size-1:0]address;
  begin
    if(L1_cache_comm)
      if(transout)
         $display("L1 %0s %h",operation,address);
       log_file=$fopen("output.log","a");
      $fwrite(log_file,"\nL1 %0s %h",operation,address);
      $fclose(log_file);
  end
endfunction

function snoop_display;
    input [63:0]snoop_result;
    begin
    if(snoopResult)
      if(transout)
         $display("%0s",snoop_result);
       log_file=$fopen("output.log","a");
      $fwrite(log_file,"\n%0s",snoop_result);
      $fclose(log_file);
  end
endfunction
 
function stats_display;
  input [63:0]hitCount,readOp,writeOp;
  real hitRatio;
   begin
     hitRatio = hitCount*100 /(readOp+writeOp);
    if(L1_cache_comm)
      if(transout)
        begin
            $display("---------Cache Statistics--------");
            $display("Hits= %0d\nCPU Reads= %0d\nCPU Writes= %0d\nHit Ratio= %0f %0s",hitCount,readOp,writeOp,hitRatio,"%");
            $display("---------------------------------");
       end
       
       
       log_file=$fopen("output.log","a");
     $fwrite(log_file,"\n%0s","---------Cache Statistics--------");
     $fwrite(log_file,"\nHits= %0d\nCPU Reads= %0d\nCPU Writes= %0d\nHit Ratio= %0f %0s",hitCount,readOp,writeOp,hitRatio,"%");
     $fwrite(log_file,"\n%0s","---------------------------------");
      $fclose(log_file);
  end
  
endfunction

function string_display;
    input [2047:0]string;
    begin
      if(transout)
         $display("%0s",string);
       log_file=$fopen("output.log","a");
      $fwrite(log_file,"\n%0s",string);
      $fclose(log_file);
  end
endfunction

function cache_display;
    input [index_size-1:0]index;
    input [associativity-1:0]way;
    input [2:0]mesi;
    input [tag_size-1:0]tag;
    input [counter_size-1:0]Lru;
    begin
      if(transout)
         $display("   %h         %h      %b     %h    %h",index,way,mesi,tag,Lru);
       log_file=$fopen("output.log","a");
      $fwrite(log_file,"\n   %h         %h      %b     %h    %h",index,way,mesi,tag,Lru);
      $fclose(log_file);
  end
endfunction

endmodule 