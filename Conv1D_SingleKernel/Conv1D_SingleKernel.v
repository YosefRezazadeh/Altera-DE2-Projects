module Conv1D_SingleKernel(
	input clk
);
	
	parameter 	KERNEL_SIZE = 3,
			STRIDE = 1,
			INPUT_SIZE = 27,
			W_BUFFER_ADDRESS_BITS = 2,
			INPUT_BUFFER_ADDRESS_BITS = 5;

	reg signed [7:0] weights [0:KERNEL_SIZE-1];
	reg signed [7:0] inputs [0:INPUT_SIZE-1];
	reg signed [15:0] outputs [0:((INPUT_SIZE - KERNEL_SIZE)/STRIDE)];
	
	initial begin: begin_block
		integer i, j;
		for (i = 0; i < KERNEL_SIZE; i = i + 1) begin
			weights[i] = i;
		end
		for (j = 0; j < INPUT_SIZE; j = j + 1) begin
			inputs[j] = j;
		end	 
	end
		
	wire [W_BUFFER_ADDRESS_BITS-1:0] w_in_1_address;
	wire [INPUT_BUFFER_ADDRESS_BITS-1:0] x_in_1_address, out_1_address;
	wire address_gen_clear, address_gen_valid, write_result;
	
	address_generator_unit #(.KERNEL_SIZE(KERNEL_SIZE), .STRIDE(STRIDE), .INPUT_SIZE(INPUT_SIZE), .W_BUFFER_ADDRESS_BITS(W_BUFFER_ADDRESS_BITS), .INPUT_BUFFER_ADDRESS_BITS(INPUT_BUFFER_ADDRESS_BITS)) address_gen (
		.clk(clk),
		.w_in_1_address(w_in_1_address),
		.x_in_1_address(x_in_1_address),
		.out_1_address(out_1_address),
		.clear(address_gen_clear),
		.valid(address_gen_valid),
		.write(write_result)
	);
	
	reg signed [7:0] w_in_1, x_in_1;
	wire signed [15:0] out_1;
	
	conv_1d_single_mac conv(
		.clk(clk),
		.w_in_1(w_in_1),
		.x_in_1(x_in_1),
		.out_1(out_1),
		.clear(address_gen_clear),
		.valid(address_gen_valid)
	);
	
	always @ (w_in_1_address) begin
		w_in_1 = weights[w_in_1_address];
	end
		
	always @ (x_in_1_address) begin
		x_in_1 = inputs[x_in_1_address];
	end
		
	always @ (posedge write_result) begin
		outputs[out_1_address] = out_1;
	end
	
endmodule