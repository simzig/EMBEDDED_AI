`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2026 15:55:39
// Design Name: 
// Module Name: mult_float_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module mult_float_tb;

    logic        clock_s;
    logic        resetb_s;
    logic        start_s;
    logic [31:0] a_s;
    logic [31:0] b_s;
    logic [31:0] result_s;
    logic        end_s;

    mult_float DUT (
        .clock_i  (clock_s),
        .resetb_i (resetb_s),
        .start_i  (start_s),
        .a_i      (a_s),
        .b_i      (b_s),
        .result_o (result_s),
        .end_o    (end_s)
    );

    // Horloge 100 MHz 
    initial clock_s = 1'b0;
    always #5 clock_s = ~clock_s;

    initial begin
        resetb_s = 1'b0;
        start_s  = 1'b0;
        a_s      = 32'd0;
        b_s      = 32'd0;
        #30;
        resetb_s = 1'b1;
        #20;

        // 2.0 x 3.0 = 6.0          
        a_s = 32'h40000000; b_s = 32'h40400000;
        start_s = 1'b1; #10; start_s = 1'b0;
        #200;

        // 1.5 x -4.0 = -6.0      
        a_s = 32'h3FC00000; b_s = 32'hC0800000;
        start_s = 1'b1; #10; start_s = 1'b0;
        #200;

        // -0.5 x -0.25 = 0.125      
        a_s = 32'hBF000000; b_s = 32'hBE800000;
        start_s = 1'b1; #10; start_s = 1'b0;

       
    end

endmodule