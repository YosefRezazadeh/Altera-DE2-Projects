module Matrix_Multiply(
	input clk,
	// LCD
	output LCD_ON,
	output LCD_BLON,
	output LCD_RW,
	output LCD_EN,
	output LCD_RS,
	inout [7:0] LCD_DATA
);
	
	parameter 	N = 16, 
					W_BUFFER_ADDRESS_BITS = 8,
					INPUT_BUFFER_ADDRESS_BITS = 4;

	reg signed [7:0] weights [0:N*N-1];
	reg signed [7:0] inputs [0:N-1];
	reg signed [15:0] outputs [0:N-1];
	
	initial begin: begin_block
		integer i, j;
		for (i = 0; i < N*N; i = i + 1) begin
			weights[i] = i-128;
		end
		for (j = 0; j < N; j = j + 1) begin
			inputs[j] = j-8;
			outputs[j] = 0;
		end	 
	end
		
	wire [W_BUFFER_ADDRESS_BITS-1:0] w_in_1_address, w_in_2_address, w_in_3_address, w_in_4_address;
	wire [INPUT_BUFFER_ADDRESS_BITS-1:0] x_in_1_address, out_1_address, x_in_2_address, out_2_address, x_in_3_address, out_3_address, x_in_4_address, out_4_address;
	wire address_gen_clear, address_gen_valid, write_result;
	
	address_generator_unit #(.N(N), .W_BUFFER_ADDRESS_BITS(W_BUFFER_ADDRESS_BITS), .INPUT_BUFFER_ADDRESS_BITS(INPUT_BUFFER_ADDRESS_BITS)) address_gen (
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
		.write(write_result)
	);
	
	reg signed [7:0] w_in_1, x_in_1, w_in_2, x_in_2, w_in_3, x_in_3, w_in_4, x_in_4;
	wire signed [15:0] out_1, out_2, out_3, out_4;
	
	matrix_multiplier mm(
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
	
	always @ (posedge write_result) begin
		outputs[out_1_address] = out_1;
		outputs[out_2_address] = out_2;
		outputs[out_3_address] = out_3;
		outputs[out_4_address] = out_4;
	end
	
	// LCD Update
	reg signed [15:0] number = 16'd0;
	wire [3:0] d4, d3, d2, d1, d0, neg;
	wire [8:0] sign;
	reg [31:0] second_counter = 32'd50000000;
	reg [INPUT_BUFFER_ADDRESS_BITS-1:0] output_out_index = 0;
	assign sign = (neg == 0)? 9'h120 : 9'h12D;
	
	digit_16bit d(
		.number_in(number),
		.digit_4(d4),
		.digit_3(d3),
		.digit_2(d2),
		.digit_1(d1),
		.digit_0(d0),
		.negative(neg));
		
	always @ (posedge clk) begin
		second_counter = second_counter - 1;
		if (second_counter == 0) begin
			output_out_index = output_out_index + 1;
			number = outputs[output_out_index];
			second_counter = 32'd50000000;
		end
	end
	
	always 
	begin
		case(LUT_INDEX)
			0:	LUT_DATA	<=	9'h038;
			1:	LUT_DATA	<=	9'h00C;
			2:	LUT_DATA	<=	9'h001;
			3:	LUT_DATA	<=	9'h006;
			4:	LUT_DATA	<=	9'h080;
			//	Line 1
			LINE1+0:	LUT_DATA	<=	sign;
			LINE1+1:	LUT_DATA	<=	{5'h13,d4};
			LINE1+2:	LUT_DATA	<=	{5'h13,d3};
			LINE1+3:	LUT_DATA	<=	{5'h13,d2};
			LINE1+4:	LUT_DATA	<=	{5'h13,d1};
			LINE1+5:	LUT_DATA	<=	{5'h13,d0};
			default:		
				LUT_DATA	<=	9'h120 ;
		endcase
	end
	
	// LCD Setup (Fix for every project)
	///////////////////////////////////
	wire DLY_RST;
	Reset_Delay r0(	.iCLK(clk),.oRESET(DLY_RST) );
	
	reg	[5:0]	LUT_INDEX;
	reg	[8:0]	LUT_DATA;
	reg	[5:0]	mLCD_ST;
	reg	[17:0]	mDLY;
	reg	mLCD_Start;
	reg	[7:0]	mLCD_DATA;
	reg	mLCD_RS;
	wire	mLCD_Done;
	parameter LINE1 = 5;
	parameter LUT_SIZE = LINE1+10;
	assign	LCD_ON		=	1'b1;
	assign	LCD_BLON	=	1'b1;
		
	always@(posedge clk or negedge DLY_RST)
		begin	
			if(!DLY_RST)
			begin
				LUT_INDEX	<=	0;
				mLCD_ST		<=	0;
				mDLY		<=	0;
				mLCD_Start	<=	0;
				mLCD_DATA	<=	0;
				mLCD_RS		<=	0;
			end
			else
				begin
				case(mLCD_ST)
				0:	begin
						mLCD_DATA	<=	LUT_DATA[7:0];
						mLCD_RS		<=	LUT_DATA[8];
						mLCD_Start	<=	1;
						mLCD_ST		<=	1;
					end
				1:	begin
						if(mLCD_Done)
						begin
							mLCD_Start	<=	0;
							mLCD_ST		<=	2;					
						end
					end
				2:	begin
						if(mDLY<18'h3FFFE)
						mDLY	<=	mDLY + 1'b1;
						else
						begin
							mDLY	<=	0;
							mLCD_ST	<=	3;
						end
					end
				3:	begin				
						if (LUT_INDEX<LUT_SIZE) begin
							mLCD_ST <= 0;
							LUT_INDEX <= LUT_INDEX + 1'b1;
						end
						else begin
							mLCD_ST <= 0;
							LUT_INDEX <= 0;
						end
					end
				endcase
			end
		end


	LCD_Controller u0(
	.iDATA(mLCD_DATA),
	.iRS(mLCD_RS),
	.iStart(mLCD_Start),
	.oDone(mLCD_Done),
	.iCLK(clk),
	.iRST_N(DLY_RST),
	.LCD_DATA(LCD_DATA),
	.LCD_RW(LCD_RW),
	.LCD_EN(LCD_EN),
	.LCD_RS(LCD_RS));
	
	////////////////////////////////////
	
endmodule
