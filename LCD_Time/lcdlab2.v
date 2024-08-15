module lcdlab2(
  input CLOCK_50,	//	50 MHz clock
//	LCD Module 16X2
  output LCD_ON,	// LCD Power ON/OFF
  output LCD_BLON,	// LCD Back Light ON/OFF
  output LCD_RW,	// LCD Read/Write Select, 0 = Write, 1 = Read
  output LCD_EN,	// LCD Enable
  output LCD_RS,	// LCD Command/Data Select, 0 = Command, 1 = Data
  inout [7:0] LCD_DATA,	// LCD Data bus 8 bits
);


// reset delay gives some time for peripherals to initialize
wire DLY_RST;
Reset_Delay r0(	.iCLK(CLOCK_50),.oRESET(DLY_RST) );

//	Internal Wires/Registers
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

reg [31:0] counter = 32'd50000000;
reg [7:0] second = 8'd40;
reg [7:0] minuate = 8'd30;
reg [7:0] hour = 8'd12;
wire [3:0] hour_1, hour_0, minuate_1, minuate_0, second_1, second_0;
assign hour_1 = hour / 10;
assign hour_0 = hour - ((hour / 10)*10);
assign minuate_1 = minuate / 10;
assign minuate_0 = minuate - ((minuate / 10)*10);
assign second_1 = second / 10;
assign second_0 = second - ((second / 10)*10);
//reg [8:0] data = 9'h140;

always
begin
	case(LUT_INDEX)
	0:	LUT_DATA	<=	9'h038;
	1:	LUT_DATA	<=	9'h00C;
	2:	LUT_DATA	<=	9'h001;
	3:	LUT_DATA	<=	9'h006;
	4:	LUT_DATA	<=	9'h080;
	//	Line 1
	LINE1+0:	LUT_DATA	<=	{5'h13,hour_1};
	LINE1+1:	LUT_DATA	<=	{5'h13,hour_0};
	LINE1+2:	LUT_DATA	<=	{9'h13A};
	LINE1+3:	LUT_DATA	<=	{5'h13,minuate_1};
	LINE1+4:	LUT_DATA	<=	{5'h13,minuate_0};
	LINE1+5:	LUT_DATA	<=	{9'h13A};
	LINE1+6:	LUT_DATA	<=	{5'h13,second_1};
	LINE1+7:	LUT_DATA	<=	{5'h13,second_0};
	default:		
		LUT_DATA	<=	9'h120 ;
	endcase
end

// turn LCD ON
assign	LCD_ON		=	1'b1;
assign	LCD_BLON	=	1'b1;

always@(posedge CLOCK_50) begin
	
		counter = counter - 1;
		if (counter == 0) begin
			counter = 32'd50000000;
			second = second + 1;
			if (second == 60) begin
				minuate = minuate + 1;
				second = 0;
			end
			if (minuate == 60) begin
				hour = hour + 1;
				minuate = 0;
			end
			if (hour == 24) begin
				hour = 0;
			end
		end
	
	end

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