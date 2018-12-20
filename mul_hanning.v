module mul_hanning(clk, data_in, data_out);
    input clk;
    input [15:0] data_in;
    output reg [15:0] data_out;

    reg [31:0] temp; //为了方便浮点处理产生的中间变量

    reg [9:0] index;
    wire [15:0] hann_out;

    hanning my_hann(.address(index), .clock(clk), .q(hann_out));

    initial
    begin
       index = 0;
       temp = 0;
    end 

    always @ (posedge clk)
    begin
        if(index == 512) index <= 0;
        else index <= index + 1'b1;
        temp <= data_in * hann_out;
        data_out <= (temp >> 16);
    end
endmodule 