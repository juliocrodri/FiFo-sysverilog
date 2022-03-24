/************************************************************************************
***                                                                               ***
*** ECE 527 		                              Julio Rodriguez, Spring,2020***
***                                                                               ***
*** Dual Port Memory for FIFO		                                          ***
*************************************************************************************
*** fifo_memory.sv        	         	 created by Julio R. , Apr 20 2020***
*** - Version 1.0								  ***
*** 										  ***
*************************************************************************************/							
`timescale 1ps/1ps
//insert items for mem BIST
module fifo_memory (WCLK,WDATA,W_ADDR,W_EN,RCLK,R_EN,R_ADDR,RDATA);
	parameter DATA_WIDTH = 8 ;
	parameter ADDR_WIDTH = 8 ;
	 
   	input 	WCLK,RCLK,W_EN,R_EN;
	input 	[DATA_WIDTH-1:0] WDATA;
	input	[ADDR_WIDTH-1:0] W_ADDR;
	input	[ADDR_WIDTH-1:0] R_ADDR;
	output	reg [DATA_WIDTH-1:0] RDATA;

	reg [DATA_WIDTH-1:0] MEM [2**ADDR_WIDTH -1 :0];

	//depth of ram calculated from the Address width, 
	//chose an appropiate width based on desired depth 
	//FIFO_DEPTH=B-B*(F2/F1) 
 
always @(posedge WCLK) begin
	if(W_EN)
	MEM[W_ADDR] <= WDATA;
	//else do nothing, its up to the transmitter
		
end

always @(posedge RCLK) begin
	if (R_EN)
	RDATA<=MEM[R_ADDR];
	else
	RDATA<=RDATA;//R_ADDR will not be incrementing in its own module.
	
end 
endmodule

