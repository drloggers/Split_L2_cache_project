// Check Cache Function
// This function checks if a line is present in the cache (i.e. in any state but invalid)
// Input - Index and Tag 
// Output- Hit or Miss

`include "conf.v"

module check_cache();
  
  parameter count_bits=`counter_size;
  cache_mem m();
  
   // Check Cache function traverses a set to find existance of a line/way. Returns Miss or Hit with way number
  function [`counter_size:0]check_cache;
    input [`index_size-1:0]index;
    input [`tag_size-1:0]tag;
    reg[`associativity:0] i;
    begin
      
      check_cache=1'b0;
      
      for(i=0;i<`associativity&&check_cache[0]==0;i=i+1)
      begin
     
       $display("Cache Content=%h",m.cache[index][i][(`mesi_bits+`counter_size-1):0]);
       if((m.cache[index][i][(`mesi_bits+`counter_size-1):0])==tag)
         begin
           check_cache={i,1'b1};
  //                check_cache[0]=1;
  //       check_cache[`counter_size:1]=i;
         end
       
      end
     
    end
    endfunction
    
//function read_cache; 
  
    
    
function LRU;
  input [`index_size-1:0]index;
  input [`counter_size-1:0]way;
  integer i;
  
  begin
    
    for(i=0;i<`associativity;i=i+1)
    begin
      
     if(m.cache[index][i][`counter_size+`tag_size-1:`tag_size]<7)
      m.cache[index][i][`counter_size+`tag_size-1:`tag_size]=m.cache[index][i][`counter_size+`tag_size-1:`tag_size]+1;
      end
      
      //`counter_size not allowed in replication. `counter_size includes $ln operation. Treats it as zero somehow
      m.cache[index][way][`counter_size+`tag_size-1:`tag_size]={count_bits{1'b0}};
     
       $display("================Counter States are======================\n");
     for(i=0;i<`associativity;i=i+1)
    begin
    
      $display("%b\n",m.cache[index][i][`counter_size+`tag_size-1:`tag_size]);
      end 
      
      
    end
    endfunction
    
    
    
    
    
    
    function cache_write;
       input [`index_size-1:0]index;
       input [`tag_size-1:0]tag;
       input [`counter_size-1:0]way;
       begin
         m.cache[index][way][`tag_size+`counter_size-1:0]={{count_bits{1'b0}},tag};
         end
         endfunction
         
         
  function [`counter_size:0]empty_way;
    input [`index_size-1:0]index;
    integer i;
    
    begin
      
      empty_way={count_bits{1'bx}};
      for(i=0;i<`associativity;i=i+1)
      if((m.cache[index][i][`tag_size+`counter_size+`mesi_bits-1:`tag_size+`counter_size])===2'bxx)
        empty_way=i;
        else
        if((m.cache[index][i][`tag_size+`counter_size+`mesi_bits-1:`tag_size+`counter_size])==2'b11)
          empty_way=i;
      end
      endfunction
      
      
      function [`counter_size:0]evict_this_way;
        input [`index_size-1:0]index;
        integer i;
        reg[`counter_size-1:0] max_val;
        
        begin
          max_val = 10'd0;
          for(i=0;i<`associativity;i=i+1)
            begin
          if(m.cache[index][i][`counter_size+`tag_size-1:`tag_size] > max_val)
          begin
            max_val = m.cache[index][i][`counter_size+`tag_size-1:`tag_size];
            evict_this_way = i;
          end
        end
          //Sorting !
          end
          endfunction
        
    
  
    
    
   
endmodule