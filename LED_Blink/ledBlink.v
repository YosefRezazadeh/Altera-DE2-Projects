module ledBlink(
	input clk,
	input next,
	output led_1,
	output led_2,
	output led_3,
	output led_4,
	output led_5,
	output led_6,
	output led_7,
	output led_8
);

	wire led_status;
	reg [2:0] select_signal;
	

	ledBlinkControl controler(.clk(clk), .led_status(led_status));
	
	demux3x8 dmux(
		.data(led_status),
		.select(select_signal),
		.out_1(led_1),
		.out_2(led_2),
		.out_3(led_3),
		.out_4(led_4),
		.out_5(led_5),
		.out_6(led_6),
		.out_7(led_7),
		.out_8(led_8)
	);
	
	always @(posedge next) begin
		
		select_signal = select_signal + 1;
		
		if (select_signal >= 8) begin
			select_signal = 3'b000;
		end
		
	end



endmodule