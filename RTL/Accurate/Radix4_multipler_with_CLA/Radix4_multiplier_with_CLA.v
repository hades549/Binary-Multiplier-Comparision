`timescale 1ns / 1ps

//region Header / Initial Comments
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2026 10:51:48 PM
// Design Name: 
// Module Name: Radix4_multiplier_with_CLA
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
////////////////////////////////////////////////////////////////////////////////
//#endregion


module Radix4_multiplier_with_CLA(
    input signed [7:0] M, 
    input signed [7:0] B,
    output signed [15:0] out
);
    parameter case0 = 3'b000;
    parameter case1 = 3'b001;
    parameter case2 = 3'b010;
    parameter case3 = 3'b011;
    parameter case4 = 3'b100;
    parameter case5 = 3'b101;
    parameter case6 = 3'b110;
    parameter case7 = 3'b111;
    
    reg signed [15:0] pp1, pp2, pp3, pp4;
    
    wire signed [15:0] M_ext = {{8{M[7]}}, M};
    wire signed [15:0] posM = M_ext;
    wire signed [15:0] negM = ~M_ext + 1'b1;
    wire signed [15:0] posMx2 = M_ext <<< 1;
    wire signed [15:0] negMx2 = ~posMx2 + 1'b1;
    
    wire [8:0] b_temp = {B, 1'b0};
    wire [2:0] a = b_temp[2:0];
    wire [2:0] b = b_temp[4:2];
    wire [2:0] c = b_temp[6:4];
    wire [2:0] d = b_temp[8:6];
    
    always @(*) begin
        // Group A (Weight x1)
        case(a)
            case0: pp1 = 16'b0; // 0
            case1: pp1 = posM; // +1
            case2: pp1 = posM; // +1
            case3: pp1 = posMx2; //+2
            case4: pp1 = negMx2; // -2
            case5: pp1 = negM; // -1
            case6: pp1 = negM; // -1
            case7: pp1 = 16'b0; // 0
            default: pp1 = 16'b0;
        endcase
        
        //shifted by 2
        case(b)
            case0: pp2 = 16'b0;
            case1: pp2 = posM <<< 2;
            case2: pp2 = posM <<< 2;
            case3: pp2 = posMx2 <<< 2;
            case4: pp2 = negMx2 <<< 2;
            case5: pp2 = negM <<< 2;
            case6: pp2 = negM <<< 2;
            case7: pp2 = 16'b0;
            default: pp2 = 16'b0;
        endcase
        
        //shifted by 4
        case(c)
            case0: pp3 = 16'b0;
            case1: pp3 = posM <<< 4;
            case2: pp3 = posM <<< 4;
            case3: pp3 = posMx2 <<< 4;
            case4: pp3 = negMx2 <<< 4;
            case5: pp3 = negM <<< 4;
            case6: pp3 = negM <<< 4;
            case7: pp3 = 16'b0;
            default: pp3 = 16'b0;
        endcase
        
        //shifted by 6
        case(d)
            case0: pp4 = 16'b0;
            case1: pp4 = posM <<< 6;
            case2: pp4 = posM <<< 6;
            case3: pp4 = posMx2 <<< 6;
            case4: pp4 = negMx2 <<< 6;
            case5: pp4 = negM <<< 6;
            case6: pp4 = negM <<< 6;
            case7: pp4 = 16'b0;
            default: pp4 = 16'b0;
        endcase
    end   
    
    // Explicit 32-bit sign extension wires to prevent strict-port truncation warnings
    wire [31:0] pp1_temp = {{16{pp1[15]}}, pp1};
    wire [31:0] pp2_temp = {{16{pp2[15]}}, pp2};
    wire [31:0] pp3_temp = {{16{pp3[15]}}, pp3};
    wire [31:0] pp4_temp = {{16{pp4[15]}}, pp4};

    wire [31:0] temp_partial1, temp_partial2, out_temp;
    
    CLA_32bit CLA_pp12 ( .pp1_red1(pp1_temp), .pp2_red2(pp2_temp), .Cin(1'b0), .out(temp_partial1), .Cout() );
    CLA_32bit CLA_pp34 ( .pp1_red1(pp3_temp), .pp2_red2(pp4_temp), .Cin(1'b0), .out(temp_partial2), .Cout() );
    CLA_32bit CLA_pp1234 ( .pp1_red1(temp_partial1), .pp2_red2(temp_partial2), .Cin(1'b0), .out(out_temp), .Cout() );
          
    assign out = out_temp[15:0];
    
endmodule