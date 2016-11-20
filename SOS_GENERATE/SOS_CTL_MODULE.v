///////////////////////////////////////////////
//// SOS_CTL_MODULE.v
//// 			ZHAOCHAO
////				2016-11-14
///////////////////////////////////////////////////////////
////

module SOS_CTL_MODULE
(
	CLK, RSTn,
	Start_Sig,
	S_Done_Sig, O_Done_Sig,
	S_Start_Sig, O_Start_Sig,
	Done_Sig
);

	input CLK;
	input RSTn;
	input Start_Sig;
	output S_Start_Sig;
	output O_Start_Sig;
	input S_Done_Sig;
	input O_Done_Sig;
	output Done_Sig;
	
	
	/////////////////
	reg [3:0]state_index;
	reg isO;
	reg isS;
	reg isDone;
	
	
	always@(posedge CLK or negedge RSTn)
		if (!RSTn)
			begin
				state_index <= 4'd0;
				isO <= 1'b0;
				isS <= 1'b0;
				isDone <= 1'b0;
			end
		else if (Start_Sig)
			case (state_index)
				4'd0:
					if (S_Done_Sig)
						begin	
							isS <= 1'b0;
							state_index <= state_index + 1'b1;
						end
					else
						begin
							isS <= 1'b1;
						end
					
				4'd1:
					if (O_Done_Sig)
						begin
							isO <= 1'b0;
							state_index <= state_index + 1'b1;
						end
					else	
						isO <= 1'b1;
						
				4'd2:
					if (S_Done_Sig)
						begin	
							isS <= 1'b0;
							state_index <= state_index + 1'b1;
						end
					else
						isS <= 1'b1;
						
				4'd3:
					begin	
						isDone <= 1'b1;
						state_index <= state_index + 1'b1;
					end
				
				4'd4:
					begin
						isDone <= 1'b0;
						state_index <= 4'd0;
					end
			endcase
			
	////////////////////////
	
	assign S_Start_Sig = isS;
	assign O_Start_Sig = isO;
	
	
endmodule
