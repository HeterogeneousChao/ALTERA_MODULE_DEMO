////////////////////////////////////////////////////////////////////////
//// LED CTL module 
//// 				ZHAOCHAO
//// 					2016-11-11
/////////////////////////////////////////////////////////////////////////
////
module LED_CTL(
			clk, rst_n,
			led
	);
	// clk and reset input
	input clk; 		// 25MHz input clk.
	input rst_n; 	// rest input, low level available.
	output led;	 	// led ctl output

	// counter var
	reg[23:0] cnt;
	
	always @(posedge clk or negedge rst_n)
		if (!rst_n)
			cnt <= 24'd0;
		else
			cnt <= cnt + 1;
			
	assign led = cnt[23];
	
endmodule
