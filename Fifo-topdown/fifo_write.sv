/************************************************************************************
***                                                                               ***
*** ECE 527 		                              Julio Rodriguez, Spring,2020***
***                                                                               ***
*** Address & Pointer generator for FIFO                                          ***
*************************************************************************************
*** fifo_write.sv              	   		 created by Julio R. , Apr 20 2020***
*** - Version 1.0								  ***
*** FLAG low means not full or empty, RST is active low				  ***
*************************************************************************************/							
`timescale 1ps/1ps

module fifo_write(CLK,RST,INC,R_PTR,FULL_FLAG,ADDR_OUT,W_PTR);

	parameter WIDTH =8 ;	 
   	input CLK,RST,INC;//inc data from sender saying there is data coming.
	input [WIDTH-1:0] R_PTR;

	output FULL_FLAG; //full signal goes to pointer gen & to transmitter
   	output reg [WIDTH-2:0] ADDR_OUT;
	output reg [WIDTH-1:0] W_PTR;
	
	reg FULL;
	
	//instances
	pointer_gen #(.WIDTH(WIDTH)) WADDR (CLK,RST,FULL_FLAG,INC,ADDR_OUT,W_PTR);
	full_flag_logic #(.WIDTH(WIDTH)) FULL_LOGIC (CLK,INC,W_PTR,R_PTR,FULL_FLAG);
endmodule



