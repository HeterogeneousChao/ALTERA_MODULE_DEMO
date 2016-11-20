////////////////////////////////////////////////////////////
//// BUZZER_SOS_MODULE.v
//// 					ZHAOCHAO
//// 						2016-11-13
//////////////////////////////////////////////////////////////
////

module BUZZER_SOS_MODULE
(
	CLK, RSTn, Pin_Out, En_Sig
);

	input CLK;
	input RSTn;
	input En_Sig;
	output Pin_Out;
	
	//// system clock: 50MHz, 50M*0.001-1=49_999;
	parameter T1MS = 16'd49_999;
	
	reg [15:0]Count1;
	
	always@(posedge CLK or negedge RSTn)
		if(!RSTn)
			Count1 <= 16'd0;
		else if(isCount && Count1 == T1MS)
			Count1 <= 16'd0;
		else if(isCount)
			Count1 <= Count1 + 1'b1;
		else if(!isCount)
			Count1 <= 16'd0;
			
	/////////////////////////////////////////////////
	
	reg [9:0]Count_MS;
	
	always@(posedge CLK or negedge RSTn)
		if(!RSTn)
			Count_MS <= 10'd0;
		else if(isCount && Count1 == T1MS)
			Count_MS <= Count_MS + 1'b1;
		else if(!isCount)
			Count_MS <= 16'd0;
			
	////////////////////////////////////////////////////////////
	
	
	reg isCount;
	reg rPin_Out;
	reg[4:0]state_index;
	
	always@(posedge CLK or negedge RSTn)
		if (!RSTn)
			begin
				isCount <= 1'b0;
				rPin_Out <= 1'b0;
				state_index <= 5'd0;
			end
		else 
			case (state_index)
				5'd0:
					if(En_Sig) 
						state_index <= 5'd1;
				
				5'd1, 5'd3, 5'd5, 	// short
				5'd13, 5'd15, 5'd17:
					if(Count_MS == 10'd100)
						begin
							isCount <= 1'b0;
							rPin_Out <= 1'b0;
							state_index <= state_index + 1'b1;
						end
					else
						begin
							isCount <= 1'b1;
							rPin_Out <= 1'b1;
						end
						
				5'd2, 5'd4, 5'd6, 	// interval
				5'd8, 5'd10, 5'd12,
				5'd14, 5'd16, 5'd18:
					if(Count_MS == 10'd50) 
						begin	
							isCount <= 1'b0;
							state_index <= state_index + 1'b1;
						end
					else 
						isCount <= 1'b1;
						
				5'd7, 5'd9, 5'd11: 	// long
					if(Count_MS == 10'd300)
						begin 
							isCount <= 1'b0;
							rPin_Out <= 1'b0;
							state_index <= state_index + 1'b1;
						end
					else
						begin	
							isCount <= 1'b1;
							rPin_Out <= 1'b1;
						end 
						
				5'd19:
					begin 
						rPin_Out <= 1'b0;
						state_index <= 5'd0;
					end
			endcase 
			
	/////////////////////////////////////////
	
	assign Pin_Out = rPin_Out;
	
endmodule
