module address_generator_unit #(parameter N = 8, W_BUFFER_ADDRESS_BITS = 6, INPUT_BUFFER_ADDRESS_BITS = 3)(
	input clk,
	output reg [W_BUFFER_ADDRESS_BITS-1:0] w_in_1_address,
	output reg [W_BUFFER_ADDRESS_BITS-1:0] w_in_2_address,
	output reg [W_BUFFER_ADDRESS_BITS-1:0] w_in_3_address,
	output reg [W_BUFFER_ADDRESS_BITS-1:0] w_in_4_address,
	output reg [INPUT_BUFFER_ADDRESS_BITS-1:0] x_in_1_address,
	output reg [INPUT_BUFFER_ADDRESS_BITS-1:0] x_in_2_address,
	output reg [INPUT_BUFFER_ADDRESS_BITS-1:0] x_in_3_address,
	output reg [INPUT_BUFFER_ADDRESS_BITS-1:0] x_in_4_address,
	output reg [INPUT_BUFFER_ADDRESS_BITS-1:0] out_1_address,
	output reg [INPUT_BUFFER_ADDRESS_BITS-1:0] out_2_address,
	output reg [INPUT_BUFFER_ADDRESS_BITS-1:0] out_3_address,
	output reg [INPUT_BUFFER_ADDRESS_BITS-1:0] out_4_address,
	output reg clear,
	output reg valid,
	output reg write);

	reg [INPUT_BUFFER_ADDRESS_BITS:0] row_counter = 0;
	reg [INPUT_BUFFER_ADDRESS_BITS:0] column_counter = 0;
	
	always @ (posedge clk) begin
		
		if (row_counter < N) begin
			if (column_counter == 0) begin
				clear = 1;
				write = 0;
				column_counter = column_counter + 1;
			end
			else if (column_counter > 0 && column_counter < N+1) begin
				clear = 0;
				w_in_1_address = row_counter*N + column_counter - 1 ;
				w_in_2_address = row_counter*N + column_counter - 1 + 1*N;
				w_in_3_address = row_counter*N + column_counter - 1 + 2*N;
				w_in_4_address = row_counter*N + column_counter - 1 + 3*N;
				x_in_1_address =  column_counter - 1;
				x_in_2_address = column_counter -1;
				x_in_3_address = column_counter -1;
				x_in_4_address = column_counter -1;
				column_counter =  column_counter + 1;
			end
			else if (column_counter == N+1) begin
				out_1_address = row_counter;
				out_2_address = row_counter + 1;
				out_3_address = row_counter + 2;
				out_4_address = row_counter + 3;
				column_counter = column_counter + 1;
				valid = 1;
			end
			else if (column_counter == N+2) begin
				valid = 0;
				write = 1;
				column_counter = 0;
				row_counter = row_counter + 4;
			end
		end
		
	end
	
endmodule
