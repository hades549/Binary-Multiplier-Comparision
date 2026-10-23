`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2026 03:47:59 PM
// Design Name: 
// Module Name: grey_and_black_cell
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


module grey_cell(input g1, p1, g2,
                 output gout);
                 
                 assign gout = g1 | (p1 & g2);
                 
endmodule

module black_cell(input g1, p1, g2, p2,
                  output gout, pout);
                  
                  assign gout = g1 | (p1 & g2);
                  assign pout = p1 & p2;
                  
endmodule
