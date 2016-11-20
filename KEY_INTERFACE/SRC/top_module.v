/////////////////////////////////////////////////////
//// top_module.v
//// 		ZHAOCHAO
////   			2016-11-19
////////////////////////////////////////////////////////////
////

module top_module
(
	CLK, RSTn,
	Key_In,
	LED
);

	input CLK;
	input RSTn;
	input [4:0]Key_In;
	output LED;
	
	
	wire [4:0]Key_Out;
	
	KEY_INTERFACE_MODULE U11
	(
		.CLK(CLK),
		.RSTn(RSTn),
		.Key_In(Key_In),
		.Key_Out(Key_Out)
	);
	
	
	OPTION_PWM_MODULE U12
	(
		.CLK(CLK),
		.RSTn(RSTn),
		.Option_Key(Key_Out),
		.Out_Pin(LED)
	);
	
	
endmodule
