/****************************************************************************************************************************************
*****************************************************************************************************************************************
Configuration File. Contains parameters, defination of essential variables 
*****************************************************************************************************************************************
****************************************************************************************************************************************/

//File Name
//`define file_name "lru_test1.txt"


//Cache Size Parameters
parameter add_size = 32,                //Address Size
          associativity = 8,            //Associtivity (lines/set)
          line_size = 64,               //Line Size (in Bytes)
          set_count = 16384;           //Number of sets in cache 16384
  
//Calculation of Tag Overhead 
parameter offset_size = $ln(line_size)/$ln(2),
          index_size = $ln(set_count)/$ln(2),
          tag_size = add_size-offset_size-index_size,
          counter_size = $ln(associativity)/$ln(2),
          mesi_bits = 2;

//Constants
parameter Modified = 2'b00,
          Exclusive = 2'b01,
          Shared = 2'b10,
          Invalid = 2'b11;

parameter NoHIT = 2'b00,
          HIT   = 2'b01,
          HITM  = 2'b10;

parameter nothing = 2'bxx,
          invalidate = 2'b00,
          memoryRead = 2'b01,
          memoryWrite = 2'b10,
          RFO = 2'b11;

parameter R = 0,
          W = 1,
          M = 2,
          I = 3;

//Debug Options 
parameter fileop = 0,
          debug = 0,
          L1_cache_comm = 1,
          snoopResult = 1,
          busOperation = 1;

//Operation Trace File 
parameter L1_DataCacheRead = 0,
          L1_DataCacheWrite = 1,
          L1_InstructionCacheRead = 2,
          SnoopInvalidateRequest = 3,
          SnoopReadRequest = 4,
          SnoopWriteRequest = 5,
          SnoopRFO = 6,
          ClearCache = 8,
          PrintCache = 9;


// Include facility of code sanity- check lenghts of address and index bits are okay 

//Constants to access cache bits
parameter mesi_start = mesi_bits+counter_size+tag_size-1,
          mesi_end = tag_size+counter_size,
          LRU_start =counter_size+tag_size-1,
          LRU_end = tag_size;