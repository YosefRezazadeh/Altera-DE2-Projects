module ledBlinkControl(
	input wire clk,
	output reg led_status);
	
	reg [31:0] counter;
	
	initial begin
		counter = 32'd50000000;
		led_status = 1'b0;
	end
	
	always @ (posedge clk) begin
		counter = counter-1;
		
		if (counter == 0) begin
			led_status = ~led_status;
			counter = 32'd50000000;
		end
	end


endmodule