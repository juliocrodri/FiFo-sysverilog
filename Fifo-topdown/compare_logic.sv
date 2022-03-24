/**************************************************************************
*** 									***
***ECE 527 				Julio Rodriguez, Spring 2020	***
*** Comparator Logic for Memory BIST					***
*** compare_logic.sv							***
**************************************************************************/

`timescale 1ps/1ps

module compare_logic (CLK,DATA,EXPECTED,PASSFAIL);
	parameter DATA_WIDTH =8;

	input CLK;
	input [DATA_WIDTH-1:0] DATA,EXPECTED;
	output reg PASSFAIL;

always@(posedge CLK) begin
	if (DATA == EXPECTED)
	PASSFAIL<=1'b1;
	else
	PASSFAIL<=1'b0;


end
endmodule
