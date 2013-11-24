// ECE 585 Fall 2013 
//Configuration File. Contains parameter defination of essential variables 

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

//Debug Options 
`define fileop 0
`define debug 1

//Operation Trace File 
`define L1DR 0
`define L1DW 1
`define L1IR 2
`define SIREQ 3
`define SRREQ 4
`define SWREQ 5
`define SRFO 6
`define CCLR 8
`define PRINT 9

// Include facility of code sanity- check lenghts of address and index bits are okay 