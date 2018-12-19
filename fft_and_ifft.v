module fft_and_ifft();
    input clk;
    input [15:0] audio_in;
    input sink_sop;
    input sink_eop;
    input sink_real;



    in_fft my_fft (
	.clk          (clk),          //    clk.clk
	.reset_n      (1),      //    rst.reset_n
	.sink_valid   (1),   //   sink.sink_valid
	.sink_ready   (sink_ready),   //       .sink_ready
	.sink_error   (sink_error),   //       .sink_error
	.sink_sop     (sink_sop),     //       .sink_sop
	.sink_eop     (sink_eop),     //       .sink_eop
	.sink_real    (sink_real),    //       .sink_real
	.sink_imag    (sink_imag),    //       .sink_imag
	.fftpts_in    (fftpts_in),    //       .fftpts_in
	.inverse      (0),      //       .inverse
	.source_valid (source_valid), // source.source_valid
	.source_ready (source_ready), //       .source_ready
	.source_error (source_error), //       .source_error
	.source_sop   (source_sop),   //       .source_sop
	.source_eop   (source_eop),   //       .source_eop
	.source_real  (source_real),  //       .source_real
	.source_imag  (source_imag),  //       .source_imag
	.fftpts_out   (fftpts_out)    //       .fftpts_out
	);

endmodule
