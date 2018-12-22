module freq_change(
    input clk,
    input [15:0] source_real_fft,
    input [15:0] source_imag_fft,
    input source_valid_fft, //fft输出开始信号
    input sink_ready_ifft, //ifft能够接收信号
    output reg [15:0] sink_real_ifft = 15'b0,
    output reg [15:0] sink_imag_ifft = 15'b0,
	output reg fc_is_output = 0
);

    parameter dis = 20;
    parameter size = 511;
    parameter middle = 256;

    reg [9:0] cnt = 10'b0;
    reg wren = 1'b1;
    reg rden = 1'b1;
    reg [8:0] raddr = 8'b0;
    reg [8:0] waddr = 8'b0;
    //reg [15:0] real_to_output = 8'b0;
    //reg [15:0] imag_to_output = 8'b0;

    wire [15:0] real_q;
    wire [15:0] imag_q;

    initial
    begin
        sink_real_ifft = 0;
        sink_imag_ifft = 0;
        cnt = 0;
    end

    ram512 real_ram(
	.clock(clk),
	.data(source_real_fft),
	.rdaddress(raddr),
	.rden(rden),
	.wraddress(waddr),
	.wren(wren),
	.q(real_q));

    ram512 imag_ram(
	.clock(clk),
	.data(source_imag_fft),
	.rdaddress(raddr),
	.rden(rden),
	.wraddress(waddr),
	.wren(wren),
	.q(imag_q));

    always @ (posedge clk)
    begin
        if(source_valid_fft) //当fft开始输出时
        begin
            wren <= 1; //写使能有效
            waddr <= waddr + 1;//写指针递增
        end
        else 
        begin 
            wren <= 0; //否则禁止写入
            waddr <= -1; 
        end
    end

    always @ (posedge clk)
    begin
        if(sink_ready_ifft) 
        begin
		  cnt <= cnt + 1; //cnt变化范围：0~size+dis*2
            if(cnt < dis + dis) fc_is_output <= 0;
            else
            begin
                fc_is_output <= 1;
                if(cnt - dis <= dis + dis || cnt - dis >= size + dis) //经过dis*2个时钟周期之后再开始
                begin
                    sink_imag_ifft <= 16'b0;
                    sink_real_ifft <= 16'b0;
                    rden <= 0;
                    raddr <= -1; 
                end
                else
                begin
                    rden <= 1;
                    sink_real_ifft <= real_q;
                    sink_imag_ifft <= imag_q;
                    if(raddr == middle - dis)
                    begin
                        raddr <= middle + dis; 
                    end
                    else raddr <= raddr + 1;
                end
            end    
        end
        else 
        begin
            cnt <= 0;
            fc_is_output <= 0;
        end
    end


    

endmodule
