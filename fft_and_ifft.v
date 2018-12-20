module fft_and_ifft(
    input clk;
    //input [15:0] audio_in;
    input sink_sop_fft;
    input sink_eop_fft;
    input [15:0] sink_real_fft;
	output wire sink_ready_fft;
	output wire source_sop_fft;
	output wire source_sop_fft;
	output wire [15:0] source_real_ifft;
);

	
	wire source_valid_fft;
	wire source_error_fft;
	wire [15:0] source_real_fft;
	wire [15:0] source_imag_fft;
	wire sink_ready_ifft;
	wire source_ready_ifft;
	wire [15:0] source_imag_fft;

	reg [9:0] cnt;
	reg reach512;

	initial 
	begin
		cnt <= 0;
	end

	always @ (posedge clk) 
	begin
		cnt <= cnt + 1;
		if(cnt == 512) begin reach512 <= 1; cnt <= 0; end
		else reach512 <= 0;
	end

    in_fft my_fft (
	.clk          (clk),          //    clk.clk
	.reset_n      (1'b1),      	  //    rst.reset_n
	.sink_valid   (1'b1),   		  //   sink.sink_valid
	.sink_ready   (sink_ready_fft),   //       .sink_ready
	.sink_error   (1'b0),   //       .sink_error
	.sink_sop     (1'b1),     //       .sink_sop
	.sink_eop     (reach512),     //       .sink_eop
	.sink_real    (sink_real_fft),    //       .sink_real
	.sink_imag    (15'b0),    //       .sink_imag
	.fftpts_in    (512),    //       .fftpts_in
	.inverse      (1'b0),      //       .inverse
	.source_valid (source_valid_fft), // source.source_valid
	.source_ready (sink_ready_ifft), //       .source_ready
	.source_error (source_error_fft), //       .source_error
	.source_sop   (source_sop_fft),   //       .source_sop
	.source_eop   (source_eop_fft),   //       .source_eop
	.source_real  (source_real_fft),  //       .source_real
	.source_imag  (source_imag_fft),  //       .source_imag
	.fftpts_out   (512)    //       .fftpts_out
	);


in_fft_fft_ii_0 my_ifft (
		.clk          (clk),          //    clk.clk
		.reset_n      (1'b1),      //    rst.reset_n
		.sink_valid   (1'b1),   //   sink.sink_valid
		.sink_ready   (sink_ready_ifft),   //       .sink_ready
		.sink_error   (1'b0),   //       .sink_error
		.sink_sop     (source_sop_fft),  //       .sink_sop
		.sink_eop     (source_eop_fft),     //       .sink_eop
		.sink_real    (source_eop_fft),    //       .sink_real
		.sink_imag    (source_imag_fft),    //       .sink_imag
		.fftpts_in    (512),    //       .fftpts_in
		.inverse      (1'b1),      //       .inverse
		.source_valid (source_valid_ifft), // source.source_valid
		.source_ready (source_ready_ifft), //       .source_ready
		.source_error (source_error_ifft), //       .source_error
		.source_sop   (source_sop_ifft),   //       .source_sop
		.source_eop   (source_eop_ifft),   //       .source_eop
		.source_real  (source_real_ifft),  //       .source_real
		.source_imag  (source_imag_ifft),  //       .source_imag
		.fftpts_out   (512)    //       .fftpts_out
	);
endmodule
