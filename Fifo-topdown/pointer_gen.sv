/************************************************************************************
***                                                                               ***
*** ECE 527 		                              Julio Rodriguez, Spring,2020***
***                                                                               ***
*** Address & Pointer generator for FIFO                                          ***
*************************************************************************************
*** pointer_gen.sv              	         created by Julio R. , Apr 19 2020***
*** - Version 1.0								  ***
*** FLAG low means not full or empty, RST is active low				  ***
*************************************************************************************/							
`timescale 1ps/1ps

module pointer_gen(CLK,RST,FLAG,INC,ADDR_OUT,GRAY_OUT);
	parameter WIDTH =8 ;	 

   	input CLK,RST,FLAG,INC;
   	output reg [WIDTH-2:0] ADDR_OUT;
	output reg [WIDTH-1:0] GRAY_OUT;
	
	reg [WIDTH-1:0] B_REG;
	reg [WIDTH-1:0] G_REG;
	reg [WIDTH-1:0] BNEXT;
	reg [WIDTH-1:0] GNEXT;
   	
//BIN2GRAY conversion
// XOR bits with the one above
assign GNEXT[WIDTH-1:0] = BNEXT[WIDTH-1:0] ^ {1'b0,BNEXT[WIDTH-1:1]};
 

always @(posedge CLK or negedge RST) begin
	if (!RST) begin 
		B_REG<={WIDTH{1'b0}};
		G_REG<={WIDTH{1'b0}};
		BNEXT<=0;
	end
	else begin
		if(INC & !FLAG)
		BNEXT<=B_REG+1;
		else
		BNEXT<=BNEXT;


	B_REG<=BNEXT;
	G_REG<=GNEXT;

	ADDR_OUT<=B_REG[WIDTH-2:0];
	GRAY_OUT<=G_REG[WIDTH-1:0];

	end


	
end
 
endmodule



