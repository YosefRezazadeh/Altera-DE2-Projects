module address_generator_unit #(
	parameter KERNEL_SIZE = 3,
	KERNELS = 4,
	STRIDE = 1,
	PADDING = 0,
	INPUT_WIDTH = 5,
	INPUT_HEIGHT = 5,
	CHANNELS = 3,
	WEIGHT_BUFFER_ADDRESS_BITS = 8,
	INPUT_BUFFER_ADDRESS_BITS = 7,
	OUTPUT_BUFFER_ADDRESS_BITS = 7)(
	input clk,
	output reg [WEIGHT_BUFFER_ADDRESS_BITS-1:0] w_in_1_address,
	output reg [WEIGHT_BUFFER_ADDRESS_BITS-1:0] w_in_2_address,
	output reg [WEIGHT_BUFFER_ADDRESS_BITS-1:0] w_in_3_address,
	output reg [WEIGHT_BUFFER_ADDRESS_BITS-1:0] w_in_4_address,
	output reg [INPUT_BUFFER_ADDRESS_BITS-1:0] x_in_1_address,
	output reg [INPUT_BUFFER_ADDRESS_BITS-1:0] x_in_2_address,
	output reg [INPUT_BUFFER_ADDRESS_BITS-1:0] x_in_3_address,
	output reg [INPUT_BUFFER_ADDRESS_BITS-1:0] x_in_4_address,
	output reg [OUTPUT_BUFFER_ADDRESS_BITS-1:0] out_1_address,
	output reg [OUTPUT_BUFFER_ADDRESS_BITS-1:0] out_2_address,
	output reg [OUTPUT_BUFFER_ADDRESS_BITS-1:0] out_3_address,
	output reg [OUTPUT_BUFFER_ADDRESS_BITS-1:0] out_4_address,
	output reg clear,
	output reg valid,
	output reg write_1,
	output reg write_2,
	output reg write_3,
	output reg write_4);
	
	// Corner of window with size of KxKxC
	reg [INPUT_BUFFER_ADDRESS_BITS:0] input_index_w = 0;
	reg [INPUT_BUFFER_ADDRESS_BITS:0] input_index_h = 0;
	// Kernel Cooredinate (x,y,z)
	reg [WEIGHT_BUFFER_ADDRESS_BITS:0] kernel_index_w = 0;
	reg [WEIGHT_BUFFER_ADDRESS_BITS:0] kernel_index_h = 0;
	reg [WEIGHT_BUFFER_ADDRESS_BITS:0] kernel_index_c = 0;
	reg [WEIGHT_BUFFER_ADDRESS_BITS:0] kernel_counter = 0;
	// Output
	reg [OUTPUT_BUFFER_ADDRESS_BITS-1:0] output_index_w = 0;
	reg [OUTPUT_BUFFER_ADDRESS_BITS-1:0] output_index_h = 0;
	reg [OUTPUT_BUFFER_ADDRESS_BITS:0] output_width = (INPUT_WIDTH + 2*PADDING - KERNEL_SIZE)/STRIDE + 1;
	reg [OUTPUT_BUFFER_ADDRESS_BITS:0] output_height = (INPUT_HEIGHT + 2*PADDING - KERNEL_SIZE)/STRIDE + 1;
	reg [INPUT_BUFFER_ADDRESS_BITS:0] zero_address = INPUT_WIDTH*INPUT_HEIGHT*CHANNELS;
	
	always @ (posedge clk) begin
		
		if (kernel_counter < KERNELS) begin
		
		if (input_index_h <= (INPUT_HEIGHT + 2*PADDING - KERNEL_SIZE)) begin

			if (kernel_index_w == 0 && kernel_index_h ==0 && kernel_index_c == 0) begin
				clear = 1;
				write_1 = 0;
				write_2 = 0;
				write_3 = 0;
				write_4 = 0;
				kernel_index_w = kernel_index_w + 1;
				kernel_index_h = kernel_index_h + 1;
				kernel_index_c = kernel_index_c + 1;
				if (output_index_w == 0) begin
					output_index_w = 1;
					output_index_h = 1;
				end
				else begin
					output_index_w = output_index_w + 1;
				end
				if (output_index_w == ((INPUT_WIDTH + 2*PADDING - KERNEL_SIZE)/STRIDE) + 2) begin
					output_index_h = output_index_h + 1;
					output_index_w = 1;
				end
			end
			else if (kernel_index_c > 0 && kernel_index_c < CHANNELS + 1) begin
				clear = 0;
				w_in_1_address = (kernel_counter*KERNEL_SIZE*KERNEL_SIZE*CHANNELS) + ((kernel_index_c-1)*KERNEL_SIZE*KERNEL_SIZE) + ((kernel_index_h-1)*KERNEL_SIZE) + (kernel_index_w-1);
				w_in_2_address = (kernel_counter*KERNEL_SIZE*KERNEL_SIZE*CHANNELS) +((kernel_index_c-1)*KERNEL_SIZE*KERNEL_SIZE) + ((kernel_index_h-1)*KERNEL_SIZE) + (kernel_index_w-1) + (KERNEL_SIZE*KERNEL_SIZE*CHANNELS);
				w_in_3_address = (kernel_counter*KERNEL_SIZE*KERNEL_SIZE*CHANNELS) + ((kernel_index_c-1)*KERNEL_SIZE*KERNEL_SIZE) + ((kernel_index_h-1)*KERNEL_SIZE) + (kernel_index_w-1) + 2*(KERNEL_SIZE*KERNEL_SIZE*CHANNELS);
				w_in_4_address = (kernel_counter*KERNEL_SIZE*KERNEL_SIZE*CHANNELS) + ((kernel_index_c-1)*KERNEL_SIZE*KERNEL_SIZE) + ((kernel_index_h-1)*KERNEL_SIZE) + (kernel_index_w-1) + 3*(KERNEL_SIZE*KERNEL_SIZE*CHANNELS);
				if ((input_index_h + kernel_index_h - 1 < PADDING) || (input_index_w + kernel_index_w - 1 < PADDING) || (input_index_h + kernel_index_h - 1 >= PADDING + INPUT_HEIGHT) || (input_index_w + kernel_index_w - 1 >= PADDING + INPUT_WIDTH)) begin
					x_in_1_address = zero_address;
					x_in_2_address = zero_address;
					x_in_3_address = zero_address;
					x_in_4_address = zero_address;
				end
				else begin
					x_in_1_address = ((input_index_h-PADDING)*INPUT_WIDTH) + (input_index_w-PADDING) + ((kernel_index_c-1)*INPUT_WIDTH*INPUT_HEIGHT) + ((kernel_index_h-1)*INPUT_WIDTH) + (kernel_index_w-1);
					x_in_2_address = ((input_index_h-PADDING)*INPUT_WIDTH) + (input_index_w-PADDING) + ((kernel_index_c-1)*INPUT_WIDTH*INPUT_HEIGHT) + ((kernel_index_h-1)*INPUT_WIDTH) + (kernel_index_w-1);
					x_in_3_address = ((input_index_h-PADDING)*INPUT_WIDTH) + (input_index_w-PADDING) + ((kernel_index_c-1)*INPUT_WIDTH*INPUT_HEIGHT) + ((kernel_index_h-1)*INPUT_WIDTH) + (kernel_index_w-1);
					x_in_4_address = ((input_index_h-PADDING)*INPUT_WIDTH) + (input_index_w-PADDING) + ((kernel_index_c-1)*INPUT_WIDTH*INPUT_HEIGHT) + ((kernel_index_h-1)*INPUT_WIDTH) + (kernel_index_w-1);
				end
				kernel_index_w = kernel_index_w + 1;
				if (kernel_index_w == KERNEL_SIZE + 1) begin
					kernel_index_w = 1;
					kernel_index_h = kernel_index_h + 1;
				end
				if (kernel_index_h == KERNEL_SIZE + 1) begin
					kernel_index_w = 1;
					kernel_index_h = 1;
					kernel_index_c = kernel_index_c + 1;
				end
			end
			else if (kernel_index_c == CHANNELS + 1) begin
				out_1_address = (kernel_counter*output_width*output_height) + (output_index_h-1)*output_width + output_index_w - 1;
				out_2_address = (kernel_counter*output_width*output_height) + (output_index_h-1)*output_width + output_index_w + (output_width * output_height) - 1;
				out_3_address = (kernel_counter*output_width*output_height) + (output_index_h-1)*output_width + output_index_w + 2*(output_width * output_height) - 1;
				out_4_address = (kernel_counter*output_width*output_height) + (output_index_h-1)*output_width + output_index_w + 3*(output_width * output_height) - 1;
				kernel_index_c = kernel_index_c + 1;
				valid = 1;
			end
			else if (kernel_index_c == CHANNELS + 2) begin
				valid = 0;
				kernel_index_c = 0;
				kernel_index_w = 0;
				kernel_index_h = 0;
				input_index_w = input_index_w + STRIDE;
				if (input_index_w > (INPUT_WIDTH + 2*PADDING - KERNEL_SIZE)) begin
					input_index_w = 0;
					input_index_h = input_index_h + STRIDE;
				end

				if (KERNELS - kernel_counter >= 4) begin
					write_1 = 1;
					write_2 = 1;
					write_3 = 1;
					write_4 = 1;
				end 
				else if (KERNELS - kernel_counter == 3) begin
					write_1 = 1;
					write_2 = 1;
					write_3 = 1;
				end
				else if (KERNELS - kernel_counter == 2) begin
					write_1 = 1;
					write_2 = 1;
				end
				else if (KERNELS - kernel_counter == 1) begin
					write_1 = 1;
				end
			end
		end
		else begin
			kernel_counter = kernel_counter + 4;
			input_index_w = 0;
			input_index_h = 0;
			kernel_index_w = 0;
			kernel_index_h = 0;
			kernel_index_c = 0;
			output_index_w = 0;
			output_index_h = 0;
		end

		end
		
	end
	
endmodule

