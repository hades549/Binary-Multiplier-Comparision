`timescale 1ns / 1ps

module tb_ApproximateMultiplier;

    reg signed [7:0] M;
    reg signed [7:0] B;
    wire signed [15:0] out;

    // Testbench variables
    reg signed [15:0] expected_out;
    integer i;
    integer pass_count;
    integer fail_count;

    // Instantiate the Unit Under Test (UUT)
    ApproximateMultiplier uut ( .M(M), .B(B), .out(out) );

    initial begin
        // Initialize Counters
        pass_count = 0;
        fail_count = 0;
        
        $display("--------------------------------------------------");
        $display("Starting Radix-4 Multiplier Verification Suite");
        $display("--------------------------------------------------");

        // =========================================================
        // 1. SPECIFIC CORNER & EDGE CASES
        // =========================================================
        
        // Corner Case 1: Zero multiplication
        test_vector(8'sd0, 8'sd0);
        test_vector(8'sd0, 8'sd25);
        test_vector(-8'sd50, 8'sd0);

        // Corner Case 2: Max / Min Signed Bounds
        test_vector(-8'sd128, -8'sd128); // (-128) * (-128) = 16384
        test_vector(-8'sd128, 8'sd127);  // (-128) * (127)  = -16256
        test_vector(8'sd127, 8'sd127);   // (127)  * (127)  = 16129

        // Corner Case 3: Identity & Sign Inversion
        test_vector(8'sd42, 8'sd1);
        test_vector(8'sd42, -8'sd1);
        test_vector(-8'sd85, 8'sd1);
        test_vector(-8'sd85, -8'sd1);

        // =========================================================
        // 2. RANDOMIZED TEST VECTORS (1,000 Iterations)
        // =========================================================
        for (i = 0; i < 1000; i = i + 1) begin
            // Generate random signed 8-bit integers (-128 to +127)
            M = $signed($urandom_range(0, 255));
            B = $signed($urandom_range(0, 255));
            
            #5; // Wait for combinational propagation
            
            expected_out = M * B;
            
            if (out === expected_out) begin
                pass_count = pass_count + 1;
            end else begin
                fail_count = fail_count + 1;
                $display("[FAIL] M = %d (%h), B = %d (%h) | Expected: %d (%h), Got: %d (%h)", 
                         M, M, B, B, expected_out, expected_out, out, out);
            end
        end

        // =========================================================
        // 3. FINAL SUMMARY
        // =========================================================
        $display("--------------------------------------------------");
        $display("Test Completed!");
        $display("Total Passed: %0d", pass_count);
        $display("Total Failed: %0d", fail_count);
        
        if (fail_count == 0) begin
            $display("SUCCESS: All test vectors passed perfectly!");
        end else begin
            $display("ERROR: Design failed %0d test cases.", fail_count);
        end
        $display("--------------------------------------------------");
        
        $finish;
    end

    // Task for explicit checking of targeted corner cases
    task test_vector(input signed [7:0] in_M, input signed [7:0] in_B);
        begin
            M = in_M;
            B = in_B;
            #5;
            expected_out = in_M * in_B;
            
            if (out === expected_out) begin
                pass_count = pass_count + 1;
            end else begin
                fail_count = fail_count + 1;
                $display("[FAIL CORNER] M = %d, B = %d | Expected: %d, Got: %d", 
                         in_M, in_B, expected_out, out);
            end
        end
    endtask

endmodule