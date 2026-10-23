`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2026 12:15:44 PM
// Design Name: 
// Module Name: wallace_tree_reduction_32bit
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

module wallace_tree_reduction_32bit (input [31:0] pp1_temp, pp2_temp, pp3_temp, pp4_temp,
                                    output [31:0] sum, carry);

            wire [32:0] temp;
            assign temp[0] = 1'b0;

            genvar i;
            generate
                for (i = 0; i < 32; i = i + 1)
                    begin: compressor_4to2_32bit 
                    compressor_4to2 create (. pp1_temp(pp1_temp[i]), .pp2_temp(pp2_temp[i]), .pp3_temp(pp3_temp[i]), .pp4_temp(pp4_temp[i]), .Cin(temp[i]), .sum(sum[i]), .carry(carry[i]), .Cout(temp[i+1]));
                    end
            endgenerate

endmodule