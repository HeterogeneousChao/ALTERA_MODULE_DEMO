////////////////////////////////////////////////////////////
//// BUZZER_SOS_CTL_MODULE.v
//// 					ZHAOCHAO
//// 						2016-11-13
//////////////////////////////////////////////////////////////
////

module BUZZER_SOS_CTL_MODULE
(
	CLK, RSTn, SOS_En_Sig
);

	input CLK;
	input RSTn;
	output SOS_En_Sig;
	
	//// 50M*3-1 = 28'd149_999_999;
	parameter T3S = 28'd149_999_999;
	
	
	reg isEn;
	reg [27:0]Count1;
	
	always@(posedge CLK or negedge RSTn)
		if(!RSTn)
			begin 
				isEn <= 1'b0;
				Count1 <= 28'd0;
			end
		else if(Count1 == T3S)
			begin 
				isEn <= 1'b1;
				Count1 <= 28'd0;
			end
		else 
			begin 
				isEn <= 1'b0;
				Count1 <= Count1 + 1'b1;
			end
			
	///////////////////////////////////
	
	
	assign SOS_En_Sig = isEn;
	
endmodule
	
	
	
	