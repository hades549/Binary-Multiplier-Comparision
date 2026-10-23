module compressor_4to2 (input pp1_temp, pp2_temp, pp3_temp, pp4_temp,
                                    input Cin,
                                    output sum, carry, Cout);

            wire s1, c1;

            assign s1 = pp1_temp ^ pp2_temp ^ pp3_temp;
            assign c1 = (pp1_temp & pp2_temp) | (pp2_temp & pp3_temp) | (pp1_temp & pp3_temp);
            
            assign sum = s1 ^ pp4_temp ^ Cin;
            assign carry = (s1 & pp4_temp) | (pp4_temp & Cin) | (s1 & Cin);
            
            assign Cout = c1;
            
endmodule