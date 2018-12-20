module freq_change(
    //input clk,
    input [15:0] source_real_fft,
    input [15:0] source_imag_fft,
    output [15:0] new_real,
    output [15:0] new_imag
);

    assign new_real = source_real_fft >> 1;
    assign new_imag = source_imag_fft >> 1;

endmodule
