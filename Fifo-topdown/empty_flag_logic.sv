/************************************************************************************
***                                                                               ***
*** ECE 527 		                              Julio Rodriguez, Spring,2020***
***                                                                               ***
*** FLAG generator logic for FIFO	                                          ***
*************************************************************************************
*** empty_flag_logic.sv        	         	 created by Julio R. , Apr 19 2020***
*** - Version 1.0								  ***
*** generates full or empty flag based on grey value inputs			  ***
*************************************************************************************/							
`timescale 1ps/1ps

module empty_flag_logic (CLK,READ_ENA,READ_PTR,WRITE_PTR,EMPTY);
	parameter WIDTH =8 ;	 
   	input 	CLK,READ_ENA;
	input 	[WIDTH-1:0] READ_PTR, WRITE_PTR;
	output 	reg EMPTY;

	reg [WIDTH-1:0] WRITE_PTR_SYNCD;
	
	synchronizer #(.WIDTH(WIDTH-1)) CNTSYNC(CLK,WRITE_PTR,WRITE_PTR_SYNCD);
 
always @(posedge CLK) begin
	//Compare logic
	if(READ_PTR[WIDTH-1] == WRITE_PTR_SYNCD[WIDTH-1]) begin
		//compare MSB if equal they are wrapped same # of times
		//need to check if empty
		if (READ_PTR[WIDTH-2:0] == WRITE_PTR_SYNCD[WIDTH-2:0 ] )
			EMPTY<=1'b1;
		 //read has caught up to write location and no longer empty
		else
			EMPTY<=1'b0;
		end
	else
		//write still ahead no need to check lower bits
		//FIFO is NOT empty
		EMPTY<=1'b0;
	//After checking functionality, set empty flag BEFORE it actually reaches this 
	
end 
endmodule

