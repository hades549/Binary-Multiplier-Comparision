`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2026 10:51:48 PM
// Design Name: 
// Module Name: ApproximateMultiplier
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


module ApproximateMultiplier(input signed [7:0] M, B,
                             output signed [15:0] out);
                             
                             parameter case0 = 3'b000;
                             parameter case1 = 3'b001;
                             parameter case2 = 3'b010;
                             parameter case3 = 3'b011;
                             parameter case4 = 3'b100;
                             parameter case5 = 3'b101;
                             parameter case6 = 3'b110;
                             parameter case7 = 3'b111;
                             
                             
                             reg signed [31:0] pp1 = 16'b0;
                             reg signed [31:0] pp2 = 16'b0;
                             reg signed [31:0] pp3 = 16'b0;
                             reg signed [31:0] pp4 = 16'b0;
                             
                             wire signed [31:0] M_temp = {{24{M[7]}}, M};
                             
                             wire signed [31:0] posM = M_temp;
                             wire signed [31:0] negM = ~M_temp + 1'b1;
                             wire signed [31:0] posMx2 = M_temp<<1;
                             wire signed [31:0] negMx2 = ~posMx2 + 1'b1;
                             
                             wire [8:0] b_temp = {B, 1'b0};
                             
                             wire [2:0] a = b_temp[2:0];
                             wire [2:0] b = b_temp[4:2];
                             wire [2:0] c = b_temp[6:4];
                             wire [2:0] d = b_temp[8:6];
                             
                             always @(*) begin
                                
                                case(a)
                                    case0: pp1 = 16'b0; // 0
                                    case1: pp1 = posM; // +1
                                    case2: pp1 = posM; // +1
                                    case3: pp1 = posMx2; // +2
                                    case4: pp1 = negMx2; // -2
                                    case5: pp1 = negM; // -1
                                    case6: pp1 = negM; // -1 
                                    case7: pp1 = 16'b0; // 0
                                    default: pp1 = 16'b0;
                                endcase
                                
                                case(b)// pp2 is left shifted by 2
                                    case0: pp2 = 16'b0; // 0
                                    case1: pp2 = posM <<< 2; // +1
                                    case2: pp2 = posM <<< 2; // +1
                                    case3: pp2 = (posMx2) <<< 2; // +2
                                    case4: pp2 = negMx2 <<< 2; // -2
                                    case5: pp2 = negM <<< 2; // -1
                                    case6: pp2 = negM <<< 2; // -1 
                                    case7: pp2 = 16'b0; // 0
                                    default: pp2 = 16'b0;
                                endcase
                                
                                case(c)// pp3 is left shifted by 4
                                    case0: pp3 = 16'b0; // 0
                                    case1: pp3 = posM <<< 4; // +1
                                    case2: pp3 = posM <<< 4; // +1
                                    case3: pp3 = (posMx2) <<< 4; // +2
                                    case4: pp3 = negMx2 <<< 4; // -2
                                    case5: pp3 = negM <<< 4; // -1
                                    case6: pp3 = negM <<< 4; // -1 
                                    case7: pp3 = 16'b0; // 0
                                    default: pp3 = 16'b0;
                                endcase
                                
                                case(d)// pp4 is left shifted by 6
                                    case0: pp4 = 16'b0; // 0
                                    case1: pp4 = posM <<< 6; // +1
                                    case2: pp4 = posM <<< 6; // +1
                                    case3: pp4 = (posMx2) <<< 6;// +2
                                    case4: pp4 = negMx2 <<< 6; // -2
                                    case5: pp4 = negM <<< 6; // -1
                                    case6: pp4 = negM <<< 6; // -1 
                                    case7: pp4 = 16'b0; // 0
                                    default: pp4 = 16'b0;
                                endcase
                             end   
                             
                             wire signed [31:0] out_temp = pp1 + pp2 + pp3 + pp4;
                             assign out = out_temp[15:0];
                                    
endmodule
