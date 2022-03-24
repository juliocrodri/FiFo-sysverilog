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

module bist_logic(BIST_EN,RST,CLK,CTRL_WINC,CTRL_RINC,DATA,ADDR,READ_ADDR,EXPECTED);
	parameter DATA_WIDTH = 8;
	parameter ADDR_WIDTH = 4;

	input BIST_EN,RST,CLK;
	output reg CTRL_WINC,CTRL_RINC;
	output reg [DATA_WIDTH-1:0] DATA,EXPECTED;
	output reg [ADDR_WIDTH-1:0] ADDR,READ_ADDR;
	
	reg [ADDR_WIDTH-1:0] STATEADDR; //addr increment
	reg [DATA_WIDTH-1:0] STATE_DATA;//walking ones shift reg
	reg READ; 	//initial zero once state addr has ben saturated, 
			//start reading the walking ones & output expected values
	reg [DATA_WIDTH-1:0] BUFF; //expected values will be one clock ahead must be delayed when reading
always @(posedge CLK or negedge RST) begin
	if (!RST) begin
	STATE_DATA<=1;
	STATEADDR<={ADDR_WIDTH{1'b0}};
	CTRL_WINC<=1'b0;
	CTRL_RINC<=1'b0;
	READ<=1'b0;
	end
	else begin
		if (READ) begin
		CTRL_RINC<=1'b1;
		READ_ADDR<=STATEADDR;
		BUFF<=STATE_DATA;
		EXPECTED<=BUFF;

		STATEADDR<=STATEADDR + 1;
		STATE_DATA<= {STATE_DATA[DATA_WIDTH-2:0],STATE_DATA[DATA_WIDTH-1]};//shift
		end
		else begin
		CTRL_WINC<=1'b1;
		//this section writes to the memory under test
		ADDR<=STATEADDR;
		DATA<=STATE_DATA;

		EXPECTED<={DATA_WIDTH{1'b0}};
		STATEADDR<=STATEADDR +1;
		STATE_DATA<= {STATE_DATA[DATA_WIDTH-2:0],STATE_DATA[DATA_WIDTH-1]};//shift
		READ<= & STATEADDR;//when address reaches 1111...1 , switch to read state
		end
	end

end	
endmodule



