/****************************************************************************************************************************************
*****************************************************************************************************************************************
Configuration File. Contains parameters, defination of essential variables 
*****************************************************************************************************************************************
****************************************************************************************************************************************/

//File Name
`define file_name "cc1.din"


//Cache Parameters
`define add_size 32
`define associativity 8            //Associtivity (lines/set)
`define line_size 64               //Line Size (in Bytes)
`define set_count 16384           //Number of sets in cache

//Calculation of Tag Overhead 
`define offset_size $ln(`line_size)/$ln(2)
`define index_size $ln(`set_count)/$ln(2)
`define tag_size `add_size-`offset_size-`index_size
`define counter_size $ln(`associativity)/$ln(2)
`define mesi_bits 2

//constants
`define Modified 2'b00
`define Exclusive 2'b01
`define Shared 2'b10
`define Invalid 2'b11

`define NoHIT 2'b00
`define HIT   2'b01
`define HITM  2'b10

`define nothing 2'b00
`define memoryRead 2'b01
`define RFO 2'b10
`define memoryWrite 2'b11

`define R 0
`define W 1
`define M 2
`define I 3

//Debug Options 
`define fileop 1
`define debug 0
`define L1_cache_comm 0
`define snoopResult 0
`define busOperation 0

//Operation Trace File 
`define L1_DataCacheRead 0
`define L1_DataCacheWrite 1
`define L1_InstructionCacheRead 2
`define SnoopInvalidateRequest 3
`define SnoopReadRequest 4
`define SnoopWriteRequest 5
`define SnoopRFO 6
`define ClearCache 8
`define PrintCache 9


// Include facility of code sanity- check lenghts of address and index bits are okay 

//Constants to access cache bits
`define mesi_start `mesi_bits+`counter_size+`tag_size-1
`define mesi_end `tag_size+`counter_size
`define LRU_start `counter_size+`tag_size-1
`define LRU_end `tag_size