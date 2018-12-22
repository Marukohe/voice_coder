module mul_hanning(clk, data_in, data_out,index);
    input clk;
    input [15:0] data_in;
    output reg [15:0] data_out;
    input [9:0] index;

    reg [31:0] temp = 0; //为了方便浮点处理产生的中间变量

    
    wire [15:0] hann_out;

    hanning my_hann(.address(index), .clock(clk), .q(hann_out));

    always @ (posedge clk)
    begin
        temp = data_in * hann_out;
        data_out <= temp[31:16];
    end
endmodule 