////////////////////////////////////////////////
////  FLASH_LED_MODULE.v
//// 					ZHAOCHAO
////						2016-11-13
/////////////////////////////////////////////////////////////////////
////

module flash_module
(
	CLK, RSTn, LED_Out
);

	input CLK;
	input RSTn;
	output LED_Out;
	
	//// System CLK = 50MHz, 50M*0.05-1=2_499_999
	parameter T50MS = 22'd2_499_999;
	
	
	reg [21:0]Count1;
	
	always@(posedge CLK or negedge RSTn)
		if(!RSTn)
			Count1 <= 22'd0;
		else if(Count1 == T50MS)
			Count1 <= 22'd0;
		else 
			Count1 <= Count1 + 1'b1;
			
	///////////////////////////////////////////////////////
	
	reg rLED_Out;
	
	always@(posedge CLK or negedge RSTn)
		if(!RSTn)
			rLED_Out <= 1'b1;
		else if(Count1 == T50MS)
			rLED_Out <= ~rLED_Out;
			
	////////////////////////////////////////////////////////////
	
	
	assign LED_Out = rLED_Out;
	
	
endmodule

			