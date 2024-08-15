module demux3x8(
	input data,
	input [2:0] select,
	output reg out_1,
	output reg out_2,
	output reg out_3,
	output reg out_4,
	output reg out_5,
	output reg out_6,
	output reg out_7,
	output reg out_8
);

	always @ (data, select) begin
		out_1 = 1'b0;
		out_2 = 1'b0;
		out_3 = 1'b0;
		out_4 = 1'b0;
		out_5 = 1'b0;
		out_6 = 1'b0;
		out_7 = 1'b0;
		out_8 = 1'b0;
		
		case(select)
			3'b000: out_1 = data;
			3'b001: out_2 = data;
			3'b010: out_3 = data;
			3'b011: out_4 = data;
			3'b100: out_5 = data;
			3'b101: out_6 = data;
			3'b110: out_7 = data;
			3'b111: out_8 = data;
		endcase
		
	end


endmodule