`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2026 05:09:08 PM
// Design Name: 
// Module Name: Booth_Multiplier_8bit
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


module booth_multiplier(input signed [7:0] M, Q,
                        output signed [15:0] product);
                        
                integer i;

                reg signed [8:0] neg_M;
                reg signed [17:0] raw_product;
                wire signed [8:0] M_temp = {M[7], M};
                always @(*) begin
                        

                        neg_M = ~M_temp + 1'b1;

                        raw_product = {{9{1'b0}}, Q, 1'b0};

                        for ( i=0; i<8; i=i+1 ) begin
                                
                                case(raw_product[1:0])
                                        
                                        2'b01: raw_product[17:9] = $signed (raw_product[17:9]) + M; //add M
                                        
                                        2'b10: raw_product[17:9] = $signed (raw_product[17:9]) + neg_M; //sub M
                                        
                                        default: raw_product = raw_product;
                                endcase
                                
                                raw_product = raw_product >>> 1;
                        end
                end
                assign product = raw_product[16:1];        
                        
endmodule
