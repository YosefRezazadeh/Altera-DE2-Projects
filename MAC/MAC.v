module MAC(
  input CLOCK_50,	//	50 MHz clock
//	LCD Module 16X2
  output LCD_ON,	// LCD Power ON/OFF
  output LCD_BLON,	// LCD Back Light ON/OFF
  output LCD_RW,	// LCD Read/Write Select, 0 = Write, 1 = Read
  output LCD_EN,	// LCD Enable
  output LCD_RS,	// LCD Command/Data Select, 0 = Command, 1 = Data
  inout [7:0] LCD_DATA	// LCD Data bus 8 bits
);


// LCD setup
wire DLY_RST;
Reset_Delay r0(	.iCLK(CLOCK_50),.oRESET(DLY_RST) );
reg	[5:0]	LUT_INDEX;
reg	[8:0]	LUT_DATA;
reg	[5:0]	mLCD_ST;
reg	[17:0]	mDLY;
reg		mLCD_Start;
reg	[7:0]	mLCD_DATA;
reg		mLCD_RS;
wire		mLCD_Done;
parameter LINE1 = 5;
parameter LUT_SIZE = LINE1+10;

wire signed [31:0] number;
wire [3:0] d4, d3, d2, d1, d0, neg;
wire [8:0] sign;
assign sign = (neg == 0)? 9'h120 : 9'h12D;
// Input buffer
reg signed [7:0] weights [0:7];
reg signed [7:0] inputs [0:7];
reg [2:0] buffer_index = 3'd0;
parameter BUFFER_SIZE = 7;
reg signed [7:0] w_in, x_in;
reg signed [15:0] psum_in, bias;
wire clear;
assign clear = 1'b0;
reg valid = 1'b0;
reg mac_end = 1'b0;
reg add_bias = 1'b0;

initial begin

	weights[0] = 8'd1;
	weights[1] = 8'd2;
	weights[2] = 8'd1;
	weights[3] = 8'd2;
	weights[4] = 8'd3;
	weights[5] = 8'd4;
	weights[6] = 8'd3;
	weights[7] = 8'd4;

	inputs[0] = -8'd1;
	inputs[1] = -8'd2;
	inputs[2] = 8'd1;
	inputs[3] = 8'd2;
	inputs[4] = 8'd4;
	inputs[5] = 8'd3;
	inputs[6] = -8'd4;
	inputs[7] = -8'd3;
	
	bias = 16'd10;
	
end


mac_unit m(
	.clk(CLOCK_50),
	.clear(clear),
	.valid(valid),
	.w(w_in),
	.x(x_in),
	.psum_in(psum_in),
	.psum_out(number)
);

digit_16bit d(
	.number_in(number),
	.digit_4(d4),
	.digit_3(d3),
	.digit_2(d2),
	.digit_1(d1),
	.digit_0(d0),
	.negative(neg));
	
always @ (posedge CLOCK_50) begin
			
		if (mac_end == 1) begin
			w_in = 0;
			x_in = 0;
			psum_in = 0;
			valid = 0;
		end
		else begin
			if (buffer_index == 0 && add_bias == 1) begin
				psum_in = bias;
				valid = 1;
				mac_end = 1;
			end
			else begin
				valid = 0;
				w_in = weights[buffer_index];
				x_in = inputs[buffer_index];
			end
			
			buffer_index = buffer_index + 1;
			
			if (buffer_index == BUFFER_SIZE) begin
				add_bias = 1;
			end
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

// turn LCD ON
assign	LCD_ON		=	1'b1;
assign	LCD_BLON	=	1'b1;


always@(posedge CLOCK_50 or negedge DLY_RST)
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
//    Host Side
.iDATA(mLCD_DATA),
.iRS(mLCD_RS),
.iStart(mLCD_Start),
.oDone(mLCD_Done),
.iCLK(CLOCK_50),
.iRST_N(DLY_RST),
//    LCD Interface
.LCD_DATA(LCD_DATA),
.LCD_RW(LCD_RW),
.LCD_EN(LCD_EN),
.LCD_RS(LCD_RS)    );
endmodule