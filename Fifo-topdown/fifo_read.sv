/************************************************************************************
***                                                                               ***
*** ECE 527 		                              Julio Rodriguez, Spring,2020***
***                                                                               ***
*** Address & Pointer generator for FIFO                                          ***
*************************************************************************************
*** fifo_read.sv              	   		 created by Julio R. , Apr 20 2020***
*** - Version 1.0								  ***
*** FLAG low means not full or empty, RST is active low				  ***
*************************************************************************************/							
`timescale 1ps/1ps

module fifo_read(CLK,RST,INC,W_PTR,EMPTY_FLAG,ADDR_OUT,R_PTR);

	parameter WIDTH =8 ;	 
   	input CLK,RST,INC;//inc signal = read enable 
	input [WIDTH-1:0] W_PTR;

	output EMPTY_FLAG; //empty signal goes to ptr_gen & receiver device
   	output reg [WIDTH-2:0] ADDR_OUT;
	output reg [WIDTH-1:0] R_PTR;
	
	reg FULL;
	
	//instances
	pointer_gen #(.WIDTH(WIDTH)) RADDR (CLK,RST,EMPTY_FLAG,INC,ADDR_OUT,R_PTR);
	empty_flag_logic #(.WIDTH(WIDTH)) EMPTY_LOGIC (CLK,INC,R_PTR,W_PTR,EMPTY_FLAG);
endmodule



