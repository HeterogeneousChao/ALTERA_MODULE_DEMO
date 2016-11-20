/////////////////////////////////////
//// PS2_DECODE_MODULE.v
//// 				ZHAOCHAO
//// 					2016-11-14
/////////////////////////////////////////////////////
////

module PS2_DECODE_MODULE
(
	CLK, RSTn,
	H2L_Sig, PS2_Data_Pin_In,
	PS2_Data, PS2_Done_Sig
);

	input CLK;
	input RSTn;
	input H2L_Sig;
	input PS2_Data_Pin_In;
	output [7:0]PS2_Data;
	output PS2_Done_Sig;
	
	////////////////////////////
	
	reg [7:0]rData;
	reg [4:0]rIndex;
	reg isShift;
	reg isDone;
	
	always@(posedge CLK or negedge RSTn)
		if(!RSTn)
			begin
				rData <= 8'd0;
				rIndex <= 5'd0;
				isDone <= 1'b0;
			end 
		else 
			case(rIndex)
				5'd0:
					if(H2L_Sig)
						rIndex <= rIndex + 1'b1;
						
				5'd1, 5'd2, 5'd3, 5'd4, 
				5'd5, 5'd6, 5'd7, 5'd8:
					if (H2L_Sig)
						begin	
							rIndex <= rIndex + 1'b1;
							rData[rIndex -1] <= PS2_Data_Pin_In;
						end
				
				5'd9, 5'd10:
					if (H2L_Sig)
						rIndex <= rIndex + 1'b1;
						
				5'd11:
					if (rData == 9'hf0) 
						rIndex <= 5'd12; 
					else 
						rIndex <= 5'd23;
						
				5'd12, 5'd13, 5'd14, 5'd15, 
				5'd16, 5'd17, 5'd18, 5'd19,
				5'd20, 5'd21, 5'd22:
					if (H2L_Sig)
						rIndex <= rIndex + 1'b1;
						
				5'd23:
					begin
						rIndex <= rIndex + 1'b1;
						isDone <= 1'b1;
					end
				
				5'd24:
					begin
						rIndex <= 5'd0;
						isDone <= 1'b0;
					end
			endcase
		
		
	///////////////////////////////////////////////////////
	
	assign PS2_Data = rData;
	assign PS2_Done_Sig = isDone;
	
endmodule

			