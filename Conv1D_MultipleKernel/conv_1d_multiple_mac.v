module conv_1d_multiple_mac(
	input clk,
	// MAC 1
	input signed [7:0] w_in_1,
	input signed [7:0] x_in_1,
	output signed [15:0] out_1,
	// MAC 2
	input signed [7:0] w_in_2,
	input signed [7:0] x_in_2,
	output signed [15:0] out_2,
	// MAC 3
	input signed [7:0] w_in_3,
	input signed [7:0] x_in_3,
	output signed [15:0] out_3,
	// MAC 4
	input signed [7:0] w_in_4,
	input signed [7:0] x_in_4,
	output signed [15:0] out_4,
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
	
	mac_unit m2(
		.clk(clk),
		.clear(clear),
		.valid(valid),
		.w(w_in_2),
		.x(x_in_2),
		.psum_in(16'b0),
		.psum_out(out_2)
	);

	mac_unit m3(
		.clk(clk),
		.clear(clear),
		.valid(valid),
		.w(w_in_3),
		.x(x_in_3),
		.psum_in(16'b0),
		.psum_out(out_3)
	);	

	mac_unit m4(
		.clk(clk),
		.clear(clear),
		.valid(valid),
		.w(w_in_4),
		.x(x_in_4),
		.psum_in(16'b0),
		.psum_out(out_4)
	);

endmodule