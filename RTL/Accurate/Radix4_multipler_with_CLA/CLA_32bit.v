`timescale 1ns / 1ps

module CLA_32bit(input [31:0] pp1_red1, pp2_red2,
                 input Cin,
                 output [31:0] out,
                 output Cout);

        wire c1;

        CLA_16bit CLA1(.in1(pp1_red1[15:0]), .in2(pp2_red2[15:0]), .Cin(Cin), .out(out[15:0]), .Cout(c1));
        CLA_16bit CLA2(.in1(pp1_red1[31:16]), .in2(pp2_red2[31:16]), .Cin(c1), .out(out[31:16]), .Cout(Cout));
endmodule

module CLA_16bit(input [15:0] in1, in2, 
                 input Cin,
                 output [15:0] out,
                 output Cout);

        wire [3:0] Pg, Gg, cin;

        CLA_4bit CLA_temp1( .A(in1[3:0]), .B(in2[3:0]), .Cin(cin[0]), .sum(out[3:0]), .Pg(Pg[0]), .Gg(Gg[0]) );
        CLA_4bit CLA_temp2( .A(in1[7:4]), .B(in2[7:4]), .Cin(cin[1]), .sum(out[7:4]), .Pg(Pg[1]), .Gg(Gg[1]) );
        CLA_4bit CLA_temp3( .A(in1[11:8]), .B(in2[11:8]), .Cin(cin[2]), .sum(out[11:8]), .Pg(Pg[2]), .Gg(Gg[2]) );
        CLA_4bit CLA_temp4( .A(in1[15:12]), .B(in2[15:12]), .Cin(cin[3]), .sum(out[15:12]), .Pg(Pg[3]), .Gg(Gg[3]) );

        LCU_4bit LCU1 (.Pg(Pg), .Gg(Gg), .Cin(Cin), .C(cin), .Cout(Cout));
endmodule


module CLA_4bit(input [3:0] A, B,
                input Cin,
                output [3:0] sum,
                output Pg, Gg);
                
    wire [3:0] P, G, C;
    assign P = A ^ B;
    assign G = A & B;

    wire p10, p21, p210, p32, p321, p3210;
    assign p10 = P[1] & P[0];
    assign p21 = P[2] & P[1];
    assign p32 = P[3] & P[2];

    assign p210 = P[2] & P[1] & P[0];
    assign p321 = P[3] & P[2] & P[1];

    assign p3210 = P[3] & P[2] & p10;

    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | ( (P[1] & G[0]) | p10 & C[0] );
    assign C[3] = G[2] | (P[2] & G[1]) | ((p21 & G[0]) | (p210 & C[0]) );

    assign sum = P ^ C;
    wire cout_temp1 = G[3] | (P[3] & G[2]) | (p32 & G[1]);
    wire cout_temp2 = (p321 & G[0]) | (p3210 & C[0]);
    //assign cout = cout_temp1 | cout_temp2;
    
    assign Pg = p3210;
    assign Gg = G[3] | (P[3] & G[2]) | (p32 & G[1]) | (p321 & G[0]);

endmodule

module LCU_4bit(input [3:0] Pg, Gg,
                  input Cin,
                  output [3:0] C,
                  output Cout);

        assign C[0] = Cin;
        
        wire pg10, pg21, pg32, pg210, pg321, pg3210;
        assign pg10 = Pg[1] & Pg[0];
        assign pg21 = Pg[2] & Pg[1];
        assign pg32 = Pg[3] & Pg[2];

        assign pg210 = Pg[2] & Pg[1] & Pg[0];
        assign pg321 = Pg[3] & Pg[2] & Pg[1];

        assign pg3210 = Pg[3] & Pg[2] & pg10;

        wire c3_temp1 = Gg[2] | (Pg[2] & Gg[1]);
        wire c3_temp2 = (pg21 & Gg[0]) | (pg210 & C[0]);

        wire Cout_temp1 = Gg[3] | (Pg[3] & Gg[2]) | (pg32 & Gg[1]);
        wire Cout_temp2 = (pg321 & Gg[0]) | (pg3210 & C[0]);

        assign C[1] = Gg[0] | (Pg[0] & C[0]);
        assign C[2] = Gg[1] | (Pg[1] & Gg[0]) | (pg10 & C[0]);
        assign C[3] = c3_temp1 | c3_temp2;
        assign Cout = Cout_temp1 | Cout_temp2;
endmodule
