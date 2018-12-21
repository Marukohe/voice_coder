module fft_and_ifft(
    input clk,
    input isready, //输入缓冲队列读取信号
	input [15:0] audio_input,
	output source_valid_ifft, //ifft输出开始信号
	output [15:0] source_real_ifft //ifft输出数据信号
);

	//====================================
	//Send to freq_change
	//====================================
	wire source_valid_fft; //fft输出开始信号
	wire [15:0] source_real_fft; //fft输出实部
	wire [15:0] source_imag_fft; //fft输出虚部
	wire sink_ready_ifft; //ifft能够接收信号

	//====================================
	//receive from freq_change
	//==================================
	wire fc_is_output;
	wire [15:0] sink_real_ifft;
	wire [15:0] sink_imag_ifft;

	//=====================================
	//Don't care
	//======================================
	wire sink_ready_fft;
	wire source_error_fft;
	wire source_sop_fft;
	wire source_eop_fft;

	wire sink_error_ifft;
	wire source_error_ifft;
	wire source_sop_ifft;
	wire source_eop_ifft;
	wire [15:0] source_imag_ifft;

	//=================================
	//中间变量
	//=================================
	reg reach512_fft;
	reg [8:0] cnt_fft;
	reg reach512_ifft;
	reg [8:0] cnt_ifft;
	always @ (posedge clk)
	begin
		if(isready) 
			begin
				if(cnt_fft == 511) begin reach512_fft <= 1;cnt_fft <= 0; end
				else begin reach512_fft <= 0; cnt_fft <= cnt_fft + 1; end
			end
	    else begin cnt_fft <= 0; reach512_fft <= 0; end
	end

    in_fft my_fft (
	.clk          (clk),       
	.reset_n      (1'b1), 
	.sink_valid   (1'b1),   
	.sink_ready   (sink_ready_fft),
	.sink_error   (1'b0),
	.sink_sop     (isready),     
	.sink_eop     (reach512_fft),    
	.sink_real    (audio_input), 
	.sink_imag    (16'b0),  
	.fftpts_in    (512), 
	.inverse      (1'b1), 
	.source_valid (source_valid_fft), 
	.source_ready (1'b1), 
	.source_error (source_error_fft),
	.source_sop   (source_sop_fft), 
	.source_eop   (source_eop_fft), 
	.source_real  (source_real_fft),
	.source_imag  (source_imag_fft), 
	.fftpts_out   (512) 
	);

	freq_change my_fc(
    .clk(clk),
    .source_real_fft(source_real_fft),
    .source_imag_fft(source_imag_fft),
    .source_valid_fft(source_valid_fft), //fft输出开始信号
    .sink_ready_ifft(sink_ready_ifft), //ifft能够接收信号
    .sink_real_ifft(sink_real_ifft),
    .sink_imag_ifft(sink_imag_ifft),
	.fc_is_output(fc_is_output)
);

	always @ (posedge clk)
	begin
		if(fc_is_output) 
			begin
				if(cnt_ifft == 511) begin reach512_ifft <= 1;cnt_ifft <= 0; end
				else begin reach512_ifft <= 0; cnt_ifft <= cnt_ifft + 1; end
			end
	    else begin cnt_ifft <= 0; reach512_ifft <= 0; end
	end


	in_fft my_ifft (
		.clk          (clk), 
		.reset_n      (1'b1),  
		.sink_valid   (1'b1), 
		.sink_ready   (sink_ready_ifft),
		.sink_error   (sink_error_ifft), 
		.sink_sop     (fc_is_output), 
		.sink_eop     (reach512_ifft), 
		.sink_real    (sink_real_ifft), 
		.sink_imag    (sink_imag_ifft), 
		.fftpts_in    (512),  
		.inverse      (1'b1),
		.source_valid (source_valid_ifft),
		.source_ready (1'b1), 
		.source_error (source_error_ifft),
		.source_sop   (source_sop_ifft),
		.source_eop   (source_eop_ifft), 
		.source_real  (source_real_ifft), 
		.source_imag  (source_imag_ifft), 
		.fftpts_out   (512)
	);
endmodule
