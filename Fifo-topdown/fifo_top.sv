/************************************************************************************
***                                                                               ***
*** ECE 527 		                              Julio Rodriguez, Spring,2020***
***                                                                               ***
*** Address & Pointer generator for FIFO                                          ***
*************************************************************************************
*** fifo_top.sv              	   		 created by Julio R. , Apr 20 2020***
*** - Version 1.0								  ***
*** FLAG low means not full or empty, RST is active low				  ***
*************************************************************************************/							
`timescale 1ps/1ps

module fifo_top(WCLK,W_RST,W_INC,WDATA,WFULL,RCLK,R_RST,R_INC,REMPTY,RDATA);
	//(CLK,RST,INC,W_PTR,EMPTY_FLAG,ADDR_OUT,R_PTR);

	parameter DATA_WIDTH = 8;
	parameter ADDR_WIDTH = 5;//this controls memory depth
				//True memory ADDR has 1 less bit width than ptr.
				//compenstate for that at this level.
	
	input WCLK,W_RST,W_INC;
	input [DATA_WIDTH-1:0] WDATA;
	
	input RCLK,R_RST,R_INC;
	output WFULL,REMPTY;
	output [DATA_WIDTH-1:0] RDATA;
	
	wire [ADDR_WIDTH-1:0] R_PTR,W_PTR;
	wire [ADDR_WIDTH-2:0] R_ADDR,W_ADDR;
	//instances
	fifo_read #(.WIDTH(ADDR_WIDTH))	TO_RECERIVER(RCLK,R_RST,R_INC,W_PTR,REMPTY,R_ADDR,R_PTR);
	
	fifo_memory #(.DATA_WIDTH(DATA_WIDTH),
	.ADDR_WIDTH(ADDR_WIDTH-1)) MEMORY(WCLK,WDATA,W_ADDR,{W_INC&!WFULL},RCLK,{R_INC&!REMPTY},R_ADDR,RDATA);
	
	fifo_write #(.WIDTH(ADDR_WIDTH)) TO_TRANSMITTER(WCLK,W_RST,W_INC,R_PTR,WFULL,W_ADDR,W_PTR);

endmodule



