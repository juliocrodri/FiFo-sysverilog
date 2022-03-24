/************************************************************************************
***                                                                               ***
*** ECE 527 		                              Julio Rodriguez, Spring,2020***
***                                                                               ***
*** Address & Pointer generator for FIFO                                          ***
*************************************************************************************
*** TB_fifo.sv              	   		 created by Julio R. , Apr 20 2020***
*** - Version 1.0								  ***
*** Simulate the interface w/ 400MHz transmitter and a 40MHz receiver		  ***
*** FIFO should hold a burst of 10 words from transmitter			  ***
*************************************************************************************/							
`timescale 1ps/1ps

module TB_fifo();

	reg WCLK,W_RST,W_INC,RCLK,R_RST,R_INC;
	reg [7:0] WDATA;
	wire WFULL,REMPTY;
	wire [7:0] RDATA;

	integer SENDCNT;
	//Design instance
	fifo_top #(.DATA_WIDTH(8),
	 .ADDR_WIDTH(5) ) DUT (WCLK,W_RST,W_INC,WDATA,WFULL,RCLK,R_RST,R_INC,REMPTY,RDATA);
		
	//5 bits are used for grey ptr. 4 bits are actual amount used for addressing. 
	//15 words fit in FIFO before full. 4 grey ptr bit width would be insufficient 
	
	//Stimulus
	initial begin 
	//"gen_WCLK" : begin
	WCLK=1'b0;
	forever #(2500/2) WCLK=~WCLK; //400mhz = 2.5ns = 2500ps
	end

	initial begin 
	//"gen_RCLK" : begin
	RCLK=1'b0;
	forever #(25000/2) RCLK=~RCLK; //40mhz = 25,000ps
	end
	
	initial begin
	$vcdpluson;
	$display("%d | WCLK | W_ADDR | WFULL | WDATA || RCLK | R_ADDR |REMPTY| RDATA |",$time);
	$monitor("%d |  %b   | %b |   %b   |  %h   ||  %b   | %b |   %b  |   %h  |",$time,WCLK,DUT.W_ADDR,WFULL,WDATA,RCLK,DUT.R_ADDR,REMPTY,RDATA);

	//Feed fifo incoming data in a burst. hold if full or finished w/ burst
	//reset low counters to initialize device
	W_RST<=0;
	W_INC<=0;
	R_RST<=0;
	R_INC<=0;
		
	//Burst
	#(2500/2) W_RST<=1;
	W_INC<=1;//enable incoming data
	R_RST<=1;
	R_INC<=1; //read data @ RCLK rate from burst
	
 	WDATA<=8'h01;
	//additional writes commented out to test empty flag
	#(2500*2) WDATA<=8'hE9;
	#(2500*2) WDATA<=8'hA0;
	W_INC<=0;
//	#(2500*2) WDATA<=8'hFF;
//	#(2500*2) WDATA<=8'h99;
//	#(2500*2) WDATA<=8'hAB;
//	#(2500*2) WDATA<=8'h0F;
//	#(2500*2) WDATA<=8'hF0;
//	#(2500*2) WDATA<=8'hA0;
//	#(2500*2) WDATA<=8'hAA;

	//Saturating to get FULL flag uncomment to test
//	#(2500*2) WDATA<=8'hA0;
//	#(2500*2) WDATA<=8'hFF;
//	#(2500*2) WDATA<=8'h99;
//	#(2500*2) WDATA<=8'hAB;
//	#(2500*2) WDATA<=8'h0F;
//	#(2500*2) WDATA<=8'hF0;
//	#(2500*2) WDATA<=8'hA0;
//	#(2500*2) WDATA<=8'hAA;
//	#(2500*2) WDATA<=8'hA0;
//	#(2500*2) WDATA<=8'hFF;
//	#(2500*2) WDATA<=8'h99;
//	#(2500*2) WDATA<=8'hAB;
//	#(2500*2) WDATA<=8'h0F;
//	#(2500*2) WDATA<=8'hF0;
//	#(2500*2) WDATA<=8'hA0;
//	#(2500*2) WDATA<=8'hAA;

	W_INC <=0; //incoming data done
	//expect same data at output 
		#(25000*10) R_INC <=0; //expected to have read things by then
	#10 $finish;
	end
endmodule



