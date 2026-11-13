`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2026 15:37:02
// Design Name: 
// Module Name: mult_float
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

module mult_float (
    input  logic        clock_i,
    input  logic        resetb_i,    
    input  logic        start_i,    
    input  logic [31:0] a_i,        
    input  logic [31:0] b_i,        
    output logic [31:0] result_o,   
    output logic        end_o      
);

    logic        res_valid_s;       
    logic [31:0] res_data_s;      

    floating_point_0 u_fp_mult (
        .aclk                 (clock_i),
        .s_axis_a_tvalid      (start_i),
        .s_axis_a_tdata       (a_i),
        .s_axis_b_tvalid      (start_i),
        .s_axis_b_tdata       (b_i),
        .m_axis_result_tvalid (res_valid_s),
        .m_axis_result_tdata  (res_data_s)
    );

    always_ff @(posedge clock_i, negedge resetb_i) begin
        if (!resetb_i) begin
            result_o <= 32'd0;
            end_o   <= 1'b0;
        end else if (res_valid_s) begin
            result_o <= res_data_s;
            end_o   <= 1'b1;
        end else if (start_i) begin
            end_o   <= 1'b0;
        end
    end

endmodule