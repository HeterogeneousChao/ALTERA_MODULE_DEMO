////////////////////////////////////////////////////////////////////////
//// TOP module 
//// 				ZHAOCHAO
//// 					2016-11-11
/////////////////////////////////////////////////////////////////////////
////

module top (
		ext_clk, ext_rst_n,
		led
	);
	
	input ext_clk; 			// outer 50MHz clk input.
	input ext_rst_n; 			// outer reset input, low level enable.
	output led;					// output led pin.
	
	// system clk initial and instance module.
	wire sys_rst_n; 			// reset signal of system.
	wire clk_25m;
	wire clk_33m;
	wire clk_50m;
	wire clk_65m;
	wire clk_100m;
	
	SYS_CTL 	u_sys_ctl_inst(
		.ext_clk(ext_clk),
		.ext_rst_n(ext_rst_n),
		.sys_rst_n(sys_rst_n),
		.clk_25m(clk_25m),
		.clk_33m(clk_33m),
		.clk_50m(clk_50m),
		.clk_65m(clk_65m),
		.clk_100m(clk_100m)
	);
	
	// led flash logic.
	LED_CTL u_led_ctl_inst(
		.clk(clk_25m),
		.rst_n(sys_rst_n),
		.led(led)
	);
	
endmodule
