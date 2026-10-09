`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2026 05:25:37 PM
// Design Name: 
// Module Name: Booth_Multiplier_8bit_tb
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


`timescale 1ns / 1ps

module tb_booth_multiplier;

    // Inputs
    reg signed [7:0] M;
    reg signed [7:0] Q;

    // Outputs
    wire signed [15:0] product;

    // Instantiate the Unit Under Test (UUT)
    booth_multiplier uut (
        .M(M), 
        .Q(Q), 
        .product(product)
    );

    integer i, j;
    integer pass_count = 0;
    integer fail_count = 0;
    
    // Golden reference calculation
    wire signed [15:0] expected;
    assign expected = M * Q;

    initial begin
        M = 0;
        Q = 0;
        
        #100;
        
        $display("Starting Exhaustive 8-bit Booth Multiplier Test...");
        
        // Loop through all 65,536 signed input combinations
        for (i = -128; i <= 127; i = i + 1) begin
            for (j = -128; j <= 127; j = j + 1) begin
                M = i[7:0];
                Q = j[7:0];
                #10; // Wait for combinational logic to settle
                
                if (product === expected) begin
                    pass_count = pass_count + 1;
                end else begin
                    fail_count = fail_count + 1;
                    $display("FAIL: M=%d, Q=%d | Expected=%d, Got=%d", M, Q, expected, product);
                end
            end
        end

        $display("\n----------------------------------");
        $display("Test Completed!");
        $display("Total Passed Cases: %d", pass_count);
        $display("Total Failed Cases: %d", fail_count);
        $display("----------------------------------");
        
        $finish;
    end
      
endmodule