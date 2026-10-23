`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2026 02:43:10 PM
// Design Name: 
// Module Name: radix_4_multiplier_with_wallace_tree_and_RCA
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


module radix_4_multiplier_with_wallace_tree_and_RCA(input [7:0] M, B,
                                                    output [15:0] out);
       
       wire [31:0] pp1_temp1, pp2_temp2, pp3_temp3, pp4_temp4, sum, carry, out_temp;
            
       radix4_multiplier_no_output block1(.M(M), .B(B), .pp1(pp1_temp1), .pp2(pp2_temp2), .pp3(pp3_temp3), .pp4(pp4_temp4));

       wallace_tree_reduction_32bit block2(.pp1_temp(pp1_temp1), .pp2_temp(pp2_temp2), .pp3_temp(pp3_temp3), .pp4_temp(pp4_temp4), .sum(sum), .carry(carry));
       RCA_32bit block3(.pp1_red1(sum), .pp2_red2({carry[30:0], 1'b0}), .Cin(1'b0), .out(out_temp), .Cout());
            
       assign out = out_temp [15:0];
         
endmodule
