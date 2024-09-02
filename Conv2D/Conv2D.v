module Conv2D(
	input clk
);
	
	parameter 	KERNEL_SIZE = 3,
			KERNELS = 4,
			STRIDE = 1,
			PADDING = 0,
			INPUT_WIDTH = 5,
			INPUT_HEIGHT = 5,
			CHANNELS = 3,
			WEIGHT_BUFFER_ADDRESS_BITS = 8,
			INPUT_BUFFER_ADDRESS_BITS = 8,
			OUTPUT_BUFFER_ADDRESS_BITS = 7;

	reg signed [7:0] weights [0:(KERNEL_SIZE*KERNEL_SIZE*CHANNELS*KERNELS)-1];
	reg signed [7:0] inputs [0:(INPUT_WIDTH*INPUT_HEIGHT*CHANNELS)];
	reg signed [15:0] outputs [0:((INPUT_WIDTH+2*PADDING-KERNEL_SIZE)/STRIDE + 1)*((INPUT_HEIGHT+2*PADDING-KERNEL_SIZE)/STRIDE + 1)*KERNELS - 1];
	
	initial begin: begin_block
		integer i, j;
		for (i = 0; i < KERNEL_SIZE*KERNEL_SIZE*CHANNELS*KERNELS; i = i + 1) begin
			weights[i] = i % 7;
		end
		for (j = 0; j < INPUT_WIDTH*INPUT_HEIGHT*CHANNELS; j = j + 1) begin
			inputs[j] = j % 10;
		end
		inputs[INPUT_WIDTH*INPUT_HEIGHT*CHANNELS] = 0;
	end
		
	wire [WEIGHT_BUFFER_ADDRESS_BITS-1:0] w_in_1_address, w_in_2_address, w_in_3_address, w_in_4_address;
	wire [INPUT_BUFFER_ADDRESS_BITS-1:0] x_in_1_address, x_in_2_address, x_in_3_address, x_in_4_address;
	wire [OUTPUT_BUFFER_ADDRESS_BITS-1:0] out_1_address, out_2_address, out_3_address, out_4_address;
	wire address_gen_clear, address_gen_valid, write_result_1, write_result_2, write_result_3, write_result_4;
	
	address_generator_unit #(.KERNEL_SIZE(KERNEL_SIZE), .STRIDE(STRIDE), .KERNELS(KERNELS), .PADDING(PADDING), .INPUT_WIDTH(INPUT_WIDTH), .INPUT_HEIGHT(INPUT_HEIGHT), .WEIGHT_BUFFER_ADDRESS_BITS(WEIGHT_BUFFER_ADDRESS_BITS), .INPUT_BUFFER_ADDRESS_BITS(INPUT_BUFFER_ADDRESS_BITS), .OUTPUT_BUFFER_ADDRESS_BITS(OUTPUT_BUFFER_ADDRESS_BITS)) address_gen (
		.clk(clk),
		.w_in_1_address(w_in_1_address),
		.x_in_1_address(x_in_1_address),
		.out_1_address(out_1_address),
		.w_in_2_address(w_in_2_address),
		.x_in_2_address(x_in_2_address),
		.out_2_address(out_2_address),	
		.w_in_3_address(w_in_3_address),
		.x_in_3_address(x_in_3_address),
		.out_3_address(out_3_address),
		.w_in_4_address(w_in_4_address),
		.x_in_4_address(x_in_4_address),
		.out_4_address(out_4_address),
		.clear(address_gen_clear),
		.valid(address_gen_valid),
		.write_1(write_result_1),
		.write_2(write_result_2),
		.write_3(write_result_3),
		.write_4(write_result_4)
	);
	
	reg signed [7:0] w_in_1, x_in_1, w_in_2, x_in_2, w_in_3, x_in_3, w_in_4, x_in_4;
	wire signed [15:0] out_1, out_2, out_3, out_4;
	
	conv_2d_engine mm(
		.clk(clk),
		.w_in_1(w_in_1),
		.x_in_1(x_in_1),
		.out_1(out_1),
		.w_in_2(w_in_2),
		.x_in_2(x_in_2),
		.out_2(out_2),
		.w_in_3(w_in_3),
		.x_in_3(x_in_3),
		.out_3(out_3),
		.w_in_4(w_in_4),
		.x_in_4(x_in_4),
		.out_4(out_4),
		.clear(address_gen_clear),
		.valid(address_gen_valid)
	);
	
	always @ (w_in_1_address) begin
		w_in_1 = weights[w_in_1_address];
	end
	
	always @ (w_in_2_address) begin
		w_in_2 = weights[w_in_2_address];
	end
	
	always @ (w_in_3_address) begin
		w_in_3 = weights[w_in_3_address];
	end
	
	always @ (w_in_4_address) begin
		w_in_4 = weights[w_in_4_address];
	end
	
	always @ (x_in_1_address) begin
		x_in_1 = inputs[x_in_1_address];
	end
	
	always @ (x_in_2_address) begin
		x_in_2 = inputs[x_in_2_address];
	end

	always @ (x_in_3_address) begin
		x_in_3 = inputs[x_in_3_address];
	end

	always @ (x_in_4_address) begin
		x_in_4 = inputs[x_in_4_address];
	end
	
	always @ (posedge write_result_1) begin
		outputs[out_1_address] = out_1;
	end

	always @ (posedge write_result_2) begin
		outputs[out_2_address] = out_2;
	end

	always @ (posedge write_result_3) begin
		outputs[out_3_address] = out_3;
	end

	always @ (posedge write_result_4) begin
		outputs[out_4_address] = out_4;
	end
	
endmodule
