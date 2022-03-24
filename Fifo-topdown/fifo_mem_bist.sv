/************************************************************************************
***                                                                               ***
*** ECE 527 		                              Julio Rodriguez, Spring,2020***
***                                                                               ***
*** Address & Pointer generator for FIFO                                          ***
*************************************************************************************
*** fifo_mem_bist.sv           	   		 created by Julio R. , May 03 2020***
*** - Version 1.0								  ***
*** BIST logic => memory => comparator => passfail				  ***
*************************************************************************************/							
`timescale 1ps/1ps

module fifo_mem_bist(BIST_EN,RST,WCLK,WDATA,W_ADDR,W_INC,RCLK,R_INC,R_ADDR,RDATA,PASSFAIL);
	//When BIST is enabled, WCLK is the test clock. 
	parameter DATA_WIDTH = 8;
	parameter ADDR_WIDTH = 4;//this controls memory depth
				//True memory ADDR has 1 less bit width than ptr.
	input BIST_EN,RST;
	input WCLK,W_INC;
	input [DATA_WIDTH-1:0] WDATA;
	input [ADDR_WIDTH-1:0] W_ADDR,R_ADDR;
	
	input RCLK,R_INC;
	output [DATA_WIDTH-1:0] RDATA;
	output PASSFAIL;

	//post MUX lines 
	wire B_WINC,B_RCLK,B_RRST,B_RINC;
	wire [ADDR_WIDTH-1:0] B_WADDR,B_RADDR;
	wire [DATA_WIDTH-1:0] B_WDATA,B_RDATA; //need these lines to compare values
	
	//lines from BIST MODULE
	wire [DATA_WIDTH-1:0] DATA,EXPECTED;
	wire [ADDR_WIDTH-1:0] ADDR,READ_ADDR;
	wire CTRL_WINC,CTRL_RINC;

	assign B_RCLK = BIST_EN ? WCLK:RCLK; //make read clock same as outclock when BIST_EN;  	
	assign B_WINC = BIST_EN ? CTRL_WINC:W_INC;
	assign B_RINC = BIST_EN ? CTRL_RINC:R_INC; 	
	assign B_WDATA = BIST_EN ? DATA : WDATA;
	assign B_WADDR = BIST_EN ? ADDR: W_ADDR;
	assign B_RADDR = BIST_EN ? READ_ADDR:R_ADDR;

	//assign RDATA = B_RDATA;//connect output line back to comparitor using B_RDATA net
	
	fifo_memory #(.DATA_WIDTH(DATA_WIDTH),
	.ADDR_WIDTH(ADDR_WIDTH)) MEMORY(WCLK,B_WDATA,B_WADDR,B_WINC,B_RCLK,B_RINC,B_RADDR,RDATA);
	
	bist_logic #(.DATA_WIDTH(DATA_WIDTH),
	.ADDR_WIDTH(ADDR_WIDTH)) B_LOGIC(BIST_EN,RST,WCLK,CTRL_WINC,CTRL_RINC,DATA,ADDR,READ_ADDR,EXPECTED);
	
	compare_logic#(.DATA_WIDTH(DATA_WIDTH),
	.ADDR_WIDTH(ADDR_WIDTH)) COMP_LOGIC (WCLK,RDATA,EXPECTED,PASSFAIL);
	
endmodule



