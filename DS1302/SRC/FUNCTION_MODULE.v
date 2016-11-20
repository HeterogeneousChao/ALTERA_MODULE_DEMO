//////////////////////////////////////////////////
//// FUNCTION_MODULE.v
//// 			ZHAOCHAO
//// 				2016-11-18
/////////////////////////////////////////////////////////////
////

module FUNCTION_MODULE
(
	CLK, RSTn,
	Start_Sig, 
	Words_Addr,
	Write_Data,
	Read_Data,
	Done_Sig,
	RST,
	SCLK,
	SIO
);

	input CLK;
	input RSTn;
	input [1:0]Start_Sig;
	input [7:0]Words_Addr;
	input [7:0]Write_Data;
	output [7:0]Read_Data;
	output Done_Sig;
	output RST;
	output SCLK;
	inout SIO;
	
	
	//// 50M * 0.000005 -1 = 24;
	parameter TOP5US = 5'd24;
	
	reg [4:0]Count1;
	
	always@(posedge CLK or negedge RSTn)
		if (!RSTn)
			Count1 <= 5'd0;
		else if (Count1 == TOP5US)
			Count1 <= 5'd0;
		else if (Start_Sig[0] == 1'b1 || Start_Sig[1] == 1'b1)
			Count1 <= Count1 + 1'b1;
		else
			Count1 <= 5'd0;
			
			
	
	reg [5:0]state_index;
	reg [7:0]rData;
	reg rSCLK;
	reg rRST;
	reg rSIO;
	reg isOut;
	reg isDone;
	
	
	always@(posedge CLK or negedge RSTn)
		if (!RSTn)
			begin
				state_index <= 6'd0;
				rData <= 8'h00;
				rSCLK <= 1'b0;
				rRST <= 1'b0;
				rSIO <= 1'b0;
				isOut <= 1'b0;
				isDone <= 1'b0;
			end
		else if (Start_Sig[1])
			case (state_index)
				6'd0:
					begin
						rSCLK <= 1'b0;
						rData <= Words_Addr;
						rRST <= 1'b1;
						isOut <= 1'b1;
						state_index <= state_index + 1'b1;
					end
					
				6'd1, 6'd3, 6'd5, 6'd7, 
				6'd9, 6'd11, 6'd13, 6'd15:
					if (Count1 == TOP5US)
						state_index <= state_index + 1'b1;
					else
						begin
							rSIO <= rData[state_index >> 1];
							rSCLK <= 1'b0;
						end
					
							
				6'd2, 6'd4, 6'd6, 6'd8,
				6'd10, 6'd12, 6'd14, 6'd16:
					if (Count1 == TOP5US)
						state_index <= state_index + 1'b1;
					else 
						begin	
							rSCLK <= 1'b1;
						end
				
				6'd17:
					begin
						rData <= Write_Data;
						state_index <= state_index + 1'b1;
					end
					
				6'd18, 6'd20, 6'd22, 6'd24,
				6'd26, 6'd28, 6'd30, 6'd32:
					if (Count1 == TOP5US)
						state_index <= state_index + 1'b1;
					else 
						begin
							rSIO <= rData[(state_index >> 1) - 9];
							rSCLK <= 1'b0;
						end
						
				6'd19, 6'd21, 6'd23, 6'd25,
				6'd27, 6'd29, 6'd31, 6'd33:
					if (Count1 == TOP5US)
						state_index <= state_index + 1'b1;
					else
						begin
							rSCLK <= 1'b1;
						end
					
				6'd34:
					begin
						rRST <= 1'b0;
						state_index <= state_index + 1'b1; 
					end
					
				6'd35:
					begin
						isDone <= 1'b1;
						state_index <= state_index + 1'b1;
					end
					
				6'd36:
					begin
						isDone <= 1'b0;
						state_index <= 6'd0;
					end
			endcase
			
			
		else if (Start_Sig[0])
		
			case (state_index)
				6'd0:
					begin
						state_index <= state_index + 1'b1;
						rSCLK <= 1'b0;
						rRST <= 1'b1;
						rData <= Words_Addr;
						isOut <= 1'b1;
					end
						
				6'd1, 6'd3, 6'd5, 6'd7,
				6'd9, 6'd11, 6'd13, 6'd15:
					if (Count1 == TOP5US)
						state_index <= state_index + 1'b1;
					else 
						begin
							rSIO <= rData[state_index >> 1];
							rSCLK <= 1'b0;
						end
						
				6'd2, 6'd4, 6'd6, 6'd8,
				6'd10, 6'd12, 6'd14, 6'd16:
					if (Count1 == TOP5US)
						state_index <= state_index + 1'b1;
					else
						rSCLK <= 1'b1;
					
				6'd17:
					begin
						isOut <= 1'b0;
						state_index <= state_index + 1'b1;
					end
					
				6'd18, 6'd20, 6'd22, 6'd24, 
				6'd26, 6'd28, 6'd30, 6'd32:
					if (Count1 == TOP5US)
						state_index <= state_index + 1'b1;
					else
						rSCLK <= 1'b1;
					
				6'd19, 6'd21, 6'd23, 6'd25,
				6'd27, 6'd29, 6'd31, 6'd33:
					if (Count1 == TOP5US)
						begin	
							state_index <= state_index + 1'b1;
						end
					else
						begin
							rSCLK  <= 1'b0;
							rData[(state_index >> 1) - 9] <= SIO;
						end 
					
				6'd34:
					begin
						rRST <= 1'b0;
						isOut <= 1'b1;
						state_index <= state_index + 1'b1;
					end
					
				6'd35:
					begin
						isDone <= 1'b1;
						state_index <= state_index + 1'b1;
					end
			
				6'd36:
					begin
						isDone <= 1'b0;
						state_index <= 6'd0;
					end
			endcase
			
	////////////////////////////////////////////
	
	assign Read_Data = rData;
	assign Done_Sig = isDone;
	assign RST = rRST;
	assign SCLK = rSCLK;
	assign SIO = isOut ? rSIO : 1'bz;
	
	
endmodule

					
				