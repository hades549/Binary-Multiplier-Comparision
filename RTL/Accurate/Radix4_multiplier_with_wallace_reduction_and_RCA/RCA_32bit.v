`timescale 1ns / 1ps

module RCA_32bit(input [31:0] pp1_red1, pp2_red2,
                 input Cin,
                 output [31:0] out,
                 output Cout);

            wire c1;

            RCA_16bit RCA1(.in1(pp1_red1[15:0]), .in2(pp2_red2[15:0]), .Cin(Cin), .out(out[15:0]), .Cout(c1));
            RCA_16bit RCA2(.in1(pp1_red1[31:16]), .in2(pp2_red2[31:16]), .Cin(c1), .out(out[31:16]), .Cout(Cout));
                
endmodule

module RCA_16bit(input [15:0] in1, in2, 
                 input Cin,
                 output [15:0] out,
                 output Cout);

            wire c1, c2, c3;

            RCA_4bit RCA1(.A(in1[3:0]), .B(in2[3:0]), .Cin(Cin), .sum(out[3:0]), .Cout(c1));
            RCA_4bit RCA2(.A(in1[7:4]), .B(in2[7:4]), .Cin(c1), .sum(out[7:4]), .Cout(c2));
            RCA_4bit RCA3(.A(in1[11:8]), .B(in2[11:8]), .Cin(c2), .sum(out[11:8]), .Cout(c3)); 
            RCA_4bit RCA4(.A(in1[15:12]), .B(in2[15:12]), .Cin(c3), .sum(out[15:12]), .Cout(Cout));

endmodule

module RCA_4bit(input [3:0] A, B,
                input Cin,
                output [3:0] sum,
                output Cout);

            wire c1, c2, c3;

            FA_1bit FA1(.A(A[0]), .B(B[0]), .Cin(Cin), .sum(sum[0]), .Cout(c1));
            FA_1bit FA2(.A(A[1]), .B(B[1]), .Cin(c1), .sum(sum[1]), .Cout(c2));
            FA_1bit FA3(.A(A[2]), .B(B[2]), .Cin(c2), .sum(sum[2]), .Cout(c3)); 
            FA_1bit FA4(.A(A[3]), .B(B[3]), .Cin(c3), .sum(sum[3]), .Cout(Cout));

endmodule

module FA_1bit( input A, B, Cin,
           output sum, Cout);

        wire ab, bc, ac;

        assign ab = A & B;
        assign bc = B & Cin;
        assign ac = A & Cin;

        assign sum = A ^ B ^ Cin;
        assign Cout = ab | bc | ac;

endmodule
