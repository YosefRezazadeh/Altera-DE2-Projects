module conv1d_multiple_kernel_test(

);
	
	reg clk;

	Conv1D_MultipleKernel #(.KERNEL_SIZE(3), .KERNELS(4), .STRIDE(3), .INPUT_SIZE(27), .W_BUFFER_ADDRESS_BITS(4), .INPUT_BUFFER_ADDRESS_BITS(5), .OUTPUT_BUFFER_ADDRESS_BITS(7)) conv (
		.clk(clk)
	);

	initial begin
		clk = 1'b0;
	end

	always begin
		#5 clk = ~clk;
	end


endmodule


