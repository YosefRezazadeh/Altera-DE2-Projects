module mac_unit(
	input clk,
	input clear,
	input valid,
	input signed [7:0] w,
	input signed [7:0] x,
	input signed [15:0] psum_in,
	output reg signed [15:0] psum_out
);
	
	reg [15:0] accumulate, product;
		
	initial begin
		accumulate = 16'd0;
		product = 16'd0;
	end
	
	always @ (posedge clk) begin
		if (clear == 1) begin
			accumulate <= 0;
			psum_out <= 0;
		end
		else begin
			if (valid == 1) begin
				accumulate = accumulate + psum_in;
				psum_out = accumulate;
			end
			else begin
				product = w * x;
				accumulate = accumulate + product;
				// psum_out = accumulate;
			end
		end
		
		
	end

endmodule
