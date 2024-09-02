module conv2d_test(

);
	
	reg clk;

	Conv2D #(.KERNEL_SIZE(5), .KERNELS(10), .STRIDE(3), .INPUT_WIDTH(13), .INPUT_HEIGHT(13), .CHANNELS(3), .PADDING(2), .WEIGHT_BUFFER_ADDRESS_BITS(10), .INPUT_BUFFER_ADDRESS_BITS(9), .OUTPUT_BUFFER_ADDRESS_BITS(8)) conv (
		.clk(clk)
	);

	initial begin
		clk = 1'b0;
	end

	always begin
		#5 clk = ~clk;
	end


endmodule



