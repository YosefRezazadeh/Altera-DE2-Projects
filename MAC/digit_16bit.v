module digit_16bit(
	input [15:0] number_in,
	output reg [3:0] digit_4,
	output reg [3:0] digit_3,
	output reg [3:0] digit_2,
	output reg [3:0] digit_1,
	output reg [3:0] digit_0,
	output negative
);

	assign negative = number_in[15];
	reg [15:0] processing_number;
	
	always @ (number_in) begin
		
		if (number_in[15] == 0)
			processing_number = number_in;
		else
			processing_number = ~(number_in-1);
			
		digit_4 = processing_number / 10000;
		processing_number = processing_number-(digit_4*10000);
		digit_3 = processing_number/1000;
		processing_number = processing_number-(digit_3*1000);
		digit_2 = processing_number/100;
		processing_number = processing_number-(digit_2*100);
		digit_1 = processing_number/10;
		processing_number = processing_number-(digit_1*10);
		digit_0 = processing_number;
				
	end
	

endmodule