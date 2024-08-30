module conv_1d_single_mac(
	input clk,
	// MAC 1
	input signed [7:0] w_in_1,
	input signed [7:0] x_in_1,
	output signed [15:0] out_1,
	// General
	input clear,
	input valid
);

	mac_unit m1(
		.clk(clk),
		.clear(clear),
		.valid(valid),
		.w(w_in_1),
		.x(x_in_1),
		.psum_in(16'b0),
		.psum_out(out_1)
	);
	
endmodule