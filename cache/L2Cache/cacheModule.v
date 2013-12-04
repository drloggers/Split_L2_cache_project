/****************************************************************************************************************************************
*****************************************************************************************************************************************
This is top cache  module  with  basic  cache  memory  module.
It also contains various functions to access cache, modify the 
contains and uses LRU - MESI modules. 
------------------------------------------------------------------ECE 585 project-------------------------------------------------------
*****************************************************************************************************************************************
****************************************************************************************************************************************/


module cacheModule();
  
  `include "conf.v"
  
  
  /*
  Initializing Block
  */
  
  cache_mem m();
 
  BusOperation bus();
  mesi_function mesi_function();
  
  integer evict_count,busRead,busWrite,busModify,busInvalid;
  
  
  /*
  Check Cache function traverses a set to find existance of a line/way. Returns Miss or Hit with way number
  */
  function [counter_size:0]check_cache;
    input [index_size-1:0]index;
    input [tag_size-1:0]tag;
    
    reg[associativity:0] i;
    
    begin  
      check_cache=1'b0; //Default return value of LSB 0 for No Hit
      
      for(i=0;i<associativity && check_cache[0]==0;i=i+1)
      begin
      //checking for valid state, if not in invalid state then read
     if(m.cache[index][i][mesi_start:mesi_end] != Invalid)
       begin
       if((m.cache[index][i][tag_size-1:0])==tag)
         begin
           check_cache={i,1'b1};        // if the cache finds match for tag it returns 'way' and a hit signal
         end
      end
     end
    end
    endfunction
  
  /*
  this function makes LRU bit according to number of active ways.
  */
  function invalidate_lru;
    input [index_size-1:0]index;
    input [counter_size-1:0]way;
    integer i;
    begin
          ////////////////////////////setting LRU bit in sequence
      for(i=0;i<associativity;i=i+1)
          begin
            if(m.cache[index][i][LRU_start:LRU_end] > m.cache[index][way][LRU_start:LRU_end])
              m.cache[index][i][LRU_start:LRU_end] = m.cache[index][i][LRU_start:LRU_end] -1;
          end
      m.cache[index][way][LRU_start:LRU_end] = {counter_size{1'bx}};
      ////////////////////////////
    end
  endfunction
    
  /*
  Determine the next state of the cache and set the mesi bits
  */
    function update_mesi;
    input [index_size-1:0]index;
    input [tag_size-1:0]tag;
    input [counter_size-1:0]way;
    input [3:0]command;
    input [1:0]snoopResult;
    reg [3:0]result,dummy;
    reg [add_size-1:0] address;
    begin   
     address = {tag,index,{offset_size{1'b0}}};
     result = mesi_function.mesi(m.cache[index][way][mesi_start:mesi_end],command,snoopResult);
     if(result[3:2] == Invalid)
       begin
         dummy = c.invalidate_lru(index,way);
        if(L1_cache_comm)
            begin
            $display("L1_cache I %h",address);
            $display("L1_cache I %h",(address+add_size));
          end
       end
       if(result[3:2] === 2'bxx)
         $display("Cannot determine the next state!");
       else
         begin
        m.cache[index][way][mesi_start:mesi_end] = result[3:2];
        case(result[1:0])
         invalidate:begin
                      if(!bus.busInvalidate(address))
                      $display("bus invalidate failed!");
                    end
         memoryRead:begin
                     if(!bus.busRead(address))
                       $display("bus read failed!");
                    end
         memoryWrite:begin
                      if(!bus.busWrite(address))
                        $display("bus write failed!");
                      end
         RFO:begin
                    if(!bus.busModify(address))
                      $display("bus modify failed!");
              end
      endcase 
    end
      update_mesi = 1'b1;
    end
  endfunction
  

/* Snoop Functions */

// Get Snoop. Inputs- Int Address, Char Operation. Output- NoHIT / HIT / HITM
  function[1:0] GetSnoopResult;
    input[31:0] Address;
    input[7:0] Operation;  
      begin
        case(Address)
          2'b00: GetSnoopResult = NoHIT;
          2'b01: GetSnoopResult = NoHIT;
          2'b10: GetSnoopResult = HIT;
          2'b11: GetSnoopResult = HITM;
        endcase
      end
    endfunction

// Put Snoop. Inputs- Int Address, Char Operation. Output- NoHIT / HIT / HITM
  function [1:0]PutSnoopResult;
    input[31:0] Address;
    input[7:0] Operation;
    
    reg [index_size-1:0]index;
    reg [tag_size-1:0]tag;
    reg [counter_size:0]result;
    
    begin
      
      index=Address[index_size+offset_size-1:offset_size];
      tag=Address[(add_size-1):(index_size+offset_size)];
      result = check_cache(index,tag);          // checks if address is in cache
      
      if(result[0])                             // if yes then check for modified state to send HITM else send HIT
      
        if(m.cache[index][result[3:1]][mesi_start:mesi_end] == Modified)
          PutSnoopResult = HITM;
        else
          PutSnoopResult = HIT;
      else                                      // if no then sends No HIT
      PutSnoopResult = NoHIT;                  
    end
  endfunction
/******************************
Snoop Functions ends
******************************/ 


  
  /*
  LRU increments the counter of all the ways and makes the accessed way 0.
  */  
  function update_LRU;
    input [index_size-1:0]index;
    input [counter_size-1:0]way;
    integer i;    
    begin 
      if(m.cache[index][way][LRU_start:LRU_end] === {counter_size{1'bx}})
        begin
          for(i=0;i<associativity;i=i+1)
            m.cache[index][i][LRU_start:LRU_end] = m.cache[index][i][LRU_start:LRU_end]+1;
        end
      else
        begin
          for(i=0;i<associativity;i=i+1)
          begin
           if(m.cache[index][i][LRU_start:LRU_end] < m.cache[index][way][LRU_start:LRU_end])
              m.cache[index][i][LRU_start:LRU_end] = m.cache[index][i][LRU_start:LRU_end]+1;
          end
        end
      //counter_size not allowed in replication. counter_size includes $ln operation. Treats it as zero somehow
      m.cache[index][way][LRU_start:LRU_end]={counter_size{1'b0}};
      update_LRU = 1'b1;
    end
  endfunction
   
  
  /*
  this function writes the tag bit at mentioned index and way 
  */ 
  function cache_write;
    input [index_size-1:0]index;
    input [tag_size-1:0]tag;
    input [counter_size-1:0]way;
    begin
      m.cache[index][way][tag_size-1:0]=tag;
      cache_write = 1;
    end
  endfunction
      
  /*
  returns the way that is empty for the mentioned index, if no way is empty then returns xx
  */       
  function [counter_size:0]empty_way;
    input [index_size-1:0]index;
    integer i;
    begin
      empty_way={counter_size{1'bx}};
      for(i=0;i<associativity;i=i+1)
      if((m.cache[index][i][mesi_start:mesi_end])===2'bxx)
        empty_way=i;
      else if((m.cache[index][i][mesi_start:mesi_end])== Invalid)
          empty_way=i;
    end
  endfunction
      
  /*
  it checks the LRU bits and returns the way with max counter value
  */
  function [counter_size:0]find_evict_way;
    input [index_size-1:0]index;
    integer i;
    reg[counter_size-1:0] max_val;
      begin
        max_val = {counter_size{1'b0}};
        for(i=0;i<associativity;i=i+1)
         begin
          if((m.cache[index][i][LRU_start:LRU_end] > max_val))
          begin
            max_val = m.cache[index][i][LRU_start:LRU_end];
            find_evict_way = i;
          end
        end
      end
  endfunction
  

  
  /*
  this function directly evicts the data from the cache and makes the state as invalid
  */
  function evict_way;
    input [index_size-1:0]index; 
    input [counter_size-1:0]way;
    integer i;
    reg[add_size-1:0] address;
     begin
       address = {m.cache[index][way][tag_size-1:0],index,{offset_size{1'b0}}};
      if(m.cache[index][way][mesi_start:mesi_end] == Modified)
        begin
        if(!bus.busWrite(address))
          $display("Bus write error");
          if(L1_cache_comm)
            begin
            $display("L1_cache I %h",address);
            $display("L1_cache I %h",(address+add_size));
          end
            
        end
        m.cache[index][way][mesi_start:mesi_end] = Invalid;
        m.cache[index][way][LRU_start:LRU_end] = {counter_size{1'bx}};
        evict_count = evict_count + 1;
        evict_way = 1'b1;       // return 1 if successfully evicted
     end 
  endfunction 
  
  function init_evict_count;
    input dummy;
    begin
      evict_count = 0;
    end
  endfunction
  function show_evict_count;
    input dummy;
    begin
      show_evict_count = evict_count;
    end
  endfunction
  
  /*
  Clears the cache by making all lines invalid
  */
  function clearCache;
    input dummy;
    integer i,j;
    begin
      for(j=0;j<set_count;j=j+1)
        begin
        for(i=0;i<associativity;i=i+1)
          begin
            m.cache[j][i][mesi_start:mesi_end] = Invalid;
          end
        end
        $display("---------------cache is cleared------------------");
    end
  endfunction
    
  /*
  this prints the content of the entire cache which are valid entries
  */  
  function print;
    input dummy;
    reg[associativity-1:0] i;
    integer j;
    begin
      $display("******************Contents of cache****************\n      Index         Way    mesi    tag   LRU");
      for(j=0;j<set_count;j=j+1)
        begin
        for(i=0;i<associativity;i=i+1)
          begin
            if(m.cache[j][i][mesi_start:mesi_end] != Invalid)//l.LRU_mem[j][i]
              $display("   %h         %h      %b     %h    %h",j,i,m.cache[j][i][mesi_start:mesi_end],m.cache[j][i][tag_size-1:0],m.cache[j][i][LRU_start:LRU_end]);
          end
        end
      print = 1'b1;
    end
  endfunction   
   

endmodule