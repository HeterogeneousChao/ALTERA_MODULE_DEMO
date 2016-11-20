////////////////////////////////////////////////
////  TOP_MODULE.v
//// 					ZHAOCHAO
////						2016-11-13
/////////////////////////////////////////////////////////////////////
////

module top_module
(
	CLK, RSTn, Flash_LED, Run_LED
);

	input CLK;
	input RSTn;
	output Flash_LED;
	output [2:0]Run_LED;
	
	
	///////////
	
	wire Flash_LED;
	
	flash_module U_FLASH_Inst
	(
		.CLK(CLK),
		.RSTn(RSTn),
		.LED_Out(Flash_LED)
	);
	
	//////////////////////////////////////
	
	wire [2:0]Run_LED;
	
	run_module U_RUN_Inst
	(
		.CLK(CLK),
		.RSTn(RSTn),
		.LED_Out(Run_LED)
	);
	
	////////////////////
	
	assign Flash_LED = Flash_LED;
	assign Run_LED = Run_LED;
	
endmodule
