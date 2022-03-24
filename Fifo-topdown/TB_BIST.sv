/************************************************************************************
***                                                                               ***
*** ECE 527 		                              Julio Rodriguez, Spring,2020***
*************************************************************************************/							
`timescale 1ps/1ps

module TB_BIST();

	reg BIST_EN,RST,WCLK,W_INC,RCLK,R_INC,PASSFAIL;
	reg [7:0] WDATA;
	reg [3:0] W_ADDR,R_ADDR;
	
	wire [7:0] RDATA;

	
	//Design instance
	fifo_mem_bist #(.DATA_WIDTH(8),
	 .ADDR_WIDTH(4) ) DUT (BIST_EN,RST,WCLK,WDATA,D_ADDR,W_INC,RCLK,R_INC,R_ADDR,RDATA,PASSFAIL);
		
	
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
	$display("%d |WCLK|BIST|RST|ADDR| EXPECTED ||  READ  |R_ADDR| PASSFAIL|",$time);

	$monitor("%d | %b  |  %b | %b |  %h | %b ||%b|  %h |   %b   |",$time,WCLK,BIST_EN,RST,DUT.B_RADDR,DUT.EXPECTED,RDATA,DUT.B_RADDR,PASSFAIL);

	
	//BIST testing set everything to zero
	//note: BIST logic makes WCLK both the read and write clock.

	BIST_EN<=1'b0;
	RST<=1'b1;
	W_INC<=1'b0; //external increments disabled
	R_INC<=1'b0;
	WDATA<={8{1'b0}};
	W_ADDR<={4{1'b0}};
	R_ADDR<={4{1'b0}};
	
	
	#(2500) BIST_EN=1'b1; //reset the device with BIST enabled
	RST<=1'b0;

	
	#(2500) RST<=1'b1;//release RST to allow memory population then reading
	
 	//


	W_INC <=0; //incoming data done
	//expect same data at output 
		#(25000*10) R_INC <=0; //expected to have read things by then
	#10 $finish;
	end
endmodule



