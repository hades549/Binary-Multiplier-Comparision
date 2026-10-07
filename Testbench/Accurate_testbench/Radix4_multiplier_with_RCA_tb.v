`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2026 04:42:14 PM
// Design Name: 
// Module Name: Radix4_multiplier_with_RCA_tb
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

module tb_Radix4_multiplier_with_RCA;

    // Inputs
    reg signed [7:0] M;
    reg signed [7:0] B;

    // Outputs
    wire signed [15:0] out;

    // Instantiate the Unit Under Test (UUT)
    Radix4_multiplier_with_RCA uut (
        .M(M), 
        .B(B), 
        .out(out)
    );

    integer i, j;
    integer pass_count = 0;
    integer fail_count = 0;
    wire signed [15:0] expected;

    assign expected = M * B;

    initial begin
        M = 0;
        B = 0;
        
        #100;
        
        $display("Starting Exhaustive RCA Multiplier Test...");
        
        // Loop through all possible 8-bit signed combinations
        for (i = -128; i <= 127; i = i + 1) begin
            for (j = -128; j <= 127; j = j + 1) begin
                M = i;
                B = j;
                #10; // Wait for combinational delay to settle
                
                if (out === expected) begin
                    pass_count = pass_count + 1;
                end else begin
                    fail_count = fail_count + 1;
                    $display("FAIL: M=%d, B=%d | Expected=%d, Got=%d", M, B, expected, out);
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