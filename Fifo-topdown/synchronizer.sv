/************************************************************************************
***                                                                               ***
*** ECE 527 		                              Julio Rodriguez, Spring,2020***
***                                                                               ***
*** Cross CLK input synchronizer                                                  ***
*************************************************************************************
*** synchronizer.sv	                         created by Julio R. , Apr 14 2020***
*** - Version 2.0 no rest necessary b/c no benefit to 1 or 0 starting value	  ***
*************************************************************************************/							
`timescale 1ps/1ps

module synchronizer(CLK,D_In,D_Out); 
   	parameter WIDTH = 8 ;
	input	CLK;
	input		[WIDTH:0] D_In;
   	output reg 	[WIDTH:0] D_Out;
   	reg  		[WIDTH:0] Q; 

always @(posedge CLK) begin
		Q<=D_In;
 		D_Out<=Q;
end 
endmodule
