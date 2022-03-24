/************************************************************************************
***                                                                               ***
*** ECE 527 		                              Julio Rodriguez, Spring,2020***
***                                                                               ***
*** FLAG generator logic for FIFO	                                          ***
*************************************************************************************
*** full_flag_logic.sv        	         	 created by Julio R. , Apr 19 2020***
*** - Version 1.0								  ***
*** generates full or empty flag based on grey value inputs			  ***
*************************************************************************************/							
`timescale 1ps/1ps

module full_flag_logic (CLK,WRITE_ENA,WRITE_PTR,READ_PTR,FULL);
	parameter WIDTH =8 ;	 
   	input 	CLK,WRITE_ENA;
	input 	[WIDTH-1:0] READ_PTR, WRITE_PTR;
	output 	reg FULL;

	reg [WIDTH-1:0] READ_PTR_SYNCD;
	
	synchronizer #(.WIDTH(WIDTH-1)) CNTSYNC(CLK,WRITE_PTR,READ_PTR_SYNCD);
 
always @(posedge CLK) begin
	//Compare logic
	if(WRITE_PTR[WIDTH-1] == READ_PTR_SYNCD[WIDTH-1]) 
		//compare MSB if equal they are wrapped same # of times
		//when read operation takes place, the PTR changes and will clear the 
		//full flag here. 
		FULL<=1'b0;
	else
		//write ptr has wrapped around. must check lower bits
		//we want 
		if (WRITE_PTR[WIDTH-2:0] == READ_PTR_SYNCD[WIDTH-2:0])
		FULL<=1'b1;
		else
		FULL<=1'b0;
		
	//After checking functionality, set full flag BEFORE it actually
	//reaches the same address. 
	
end 
endmodule

