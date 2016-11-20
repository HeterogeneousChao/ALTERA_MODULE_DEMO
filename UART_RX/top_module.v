////////////////////////////////////////////////////////////////
//// top_module.v
//// 			 		ZHAOCHAO
//// 						2016-11-14
////////////////////////////////////////////
////
	
module top_module
(
	CLK, RSTn,
	RX_Pin_In,
	NUM_Data
);

	input CLK;
	input RSTn;
	input RX_Pin_In;
	output [3:0]NUM_Data;
	
	////////////////////////////////////
	
	
	wire RX_Done_Sig;
	wire [7:0]RX_Data;
	
	RX_MODULE U3
	(
		.CLK(CLK),
		.RSTn(RSTn),
		.RX_Pin_In(RX_Pin_In),
		.RX_En_Sig(RX_En_Sig),
		.RX_Done_Sig(RX_Done_Sig),
		.RX_Data(RX_Data)
	);
	
	
	//////////////////////////////
	
	wire RX_En_Sig;
	wire [7:0]Output_Data;
	
	CTL_MODULE U4
	(
		.CLK(CLK),
		.RSTn(RSTn),
		.RX_Done_Sig(RX_Done_Sig),
		.RX_Data(RX_Data),
		.RX_En_Sig(RX_En_Sig),
		.Num_Data(Output_Data)
	);
	
	
	////////////////////////////////////
	
	assign NUM_Data = Output_Data[3:0];
	
	
endmodule
