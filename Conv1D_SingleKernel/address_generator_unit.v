module address_generator_unit #(
	parameter KERNEL_SIZE = 3,
	STRIDE = 1,
	INPUT_SIZE = 27,
	W_BUFFER_ADDRESS_BITS = 2,
	INPUT_BUFFER_ADDRESS_BITS = 5)(
	input clk,
	output reg [W_BUFFER_ADDRESS_BITS-1:0] w_in_1_address,
	output reg [INPUT_BUFFER_ADDRESS_BITS-1:0] x_in_1_address,
	output reg [INPUT_BUFFER_ADDRESS_BITS-1:0] out_1_address,
	output reg clear,
	output reg valid,
	output reg write);
		
	reg [INPUT_BUFFER_ADDRESS_BITS:0] input_index = 0;
	reg [W_BUFFER_ADDRESS_BITS:0] kernel_index = 0;
	reg [INPUT_BUFFER_ADDRESS_BITS-1:0] output_index = 0;
	
	always @ (posedge clk) begin
		
		if (input_index <= INPUT_SIZE - KERNEL_SIZE) begin
			if (kernel_index == 0) begin
				clear = 1;
				write = 0;
				kernel_index = kernel_index + 1;
				output_index = output_index + 1;
			end
			else if (kernel_index > 0 && kernel_index < KERNEL_SIZE + 1) begin
				clear = 0;
				w_in_1_address = kernel_index - 1;
				x_in_1_address = input_index + (kernel_index - 1);
				kernel_index = kernel_index + 1;
			end
			else if (kernel_index == KERNEL_SIZE + 1) begin
				out_1_address = output_index - 1;
				kernel_index = kernel_index + 1;
				valid = 1;
			end
			else if (kernel_index == KERNEL_SIZE + 2) begin
				valid = 0;
				write = 1;
				kernel_index = 0;
				input_index = input_index + STRIDE;
			end
		end
		
	end
	
endmodule
