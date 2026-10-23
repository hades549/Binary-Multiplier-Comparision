`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2026 03:03:59 PM
// Design Name: 
// Module Name: brent_kung_adder32bit
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


module brent_kung_adder32bit(input [31:0] pp1_red1, pp2_red2,
                             input Cin,
                             output [31:0] out,
                             output Cout);
                             
                             wire [31:0] p, g, g_temp;
                             
                             assign p = pp1_red1 ^ pp2_red2;
                             assign g = pp1_red1 & pp2_red2;
                             assign g_temp = {g[31:1], g[0] | (p[0] & Cin)};
                             
                             //number of rows = 2 x log32(base 2) - 1, so 9
                             
                             wire [31:0] p_tree[9:0];
                             wire [31:0] g_tree[9:0];
                             
                             assign p_tree[0] = p; //the 1st stage is p
                             assign g_tree[0] = g_temp; //the 1st stage is g
                             
                             genvar i,j;
                             generate
                                for(j=1; j<=5; j = j+1) begin
                                    localparam integer stride = 1 << j;
                                    localparam integer half_stride = 1 << (j - 1);
                                    
                                    for (i = 0; i<32 ; i = i+1) begin
                                        if (i >= half_stride && (i + 1) % stride == 0) 
                                            black_cell bc(.g1(g_tree[j-1][i]), .p1(p_tree[j-1][i]), .g2(g_tree[j-1][i - half_stride]), .p2(p_tree[j-1][i - half_stride]), .gout(g_tree[j][i]), .pout(p_tree[j][i]));
                                        
                                        else begin
                                            assign g_tree[j][i] = g_tree[j - 1][i];
                                            assign p_tree[j][i] = p_tree[j - 1][i];
                                        end
                                    end
                                end
                             endgenerate 
                             
                             generate
                                for(j=6; j<=9; j = j+1) begin
                                    localparam integer stride = 1 << (10 -  j);
                                    localparam integer half_stride = stride >> 1;
                                    
                                    for (i=0; i<32; i = i+1) begin
                                        if (i >= stride && (i + 1) % stride == half_stride)begin
                                            grey_cell gc(.g1(g_tree[j-1][i]), .p1(p_tree[j-1][i]), .g2(g_tree[j-1][i - half_stride]), .gout(g_tree[j][i]));
                                            assign p_tree[j][i] = p_tree[j-1][i];
                                        end
                                             
                                        else begin
                                            assign g_tree[j][i] = g_tree[j - 1][i];
                                            assign p_tree[j][i] = p_tree[j - 1][i];
                                        end
                                    end
                                end
                             endgenerate    
                             
                             assign out[0] = p[0] ^ Cin;
                             assign out[31:1] = p[31:1] ^ g_tree[9][30:0];
                             assign Cout = g_tree[9][31]; 
endmodule
