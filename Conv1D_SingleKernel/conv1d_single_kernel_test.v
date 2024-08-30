module conv1d_single_kernel_test(

);
	
	reg clk;

	Conv1D_SingleKernel #(.KERNEL_SIZE(3), .STRIDE(3), .INPUT_SIZE(27), .W_BUFFER_ADDRESS_BITS(2), .INPUT_BUFFER_ADDRESS_BITS(5)) conv (
		.clk(clk)
	);

	initial begin
		clk = 1'b0;
	end

	always begin
		#5 clk = ~clk;
	end


endmodule

