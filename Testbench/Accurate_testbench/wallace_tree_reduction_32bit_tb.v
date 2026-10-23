`timescale 1ns / 1ps
module tb_wallace_tree_reduction_32bit();
    reg  [31:0] pp1_temp, pp2_temp, pp3_temp, pp4_temp;
    wire [31:0] sum, carry;                 // CHANGED: was [33:0], now matches the DUT
    integer errors = 0, n;                  // CHANGED: count errors instead of $finish on the first one

    wallace_tree_reduction_32bit uut (
        .pp1_temp(pp1_temp), .pp2_temp(pp2_temp),
        .pp3_temp(pp3_temp), .pp4_temp(pp4_temp),
        .sum(sum), .carry(carry));

    task check;                             // CHANGED: no argument, the reference is computed inside
        reg [31:0] actual, expected;
        begin
            #1;
            actual   = sum + {carry[30:0], 1'b0};                   // CHANGED: carry[i] has weight 2^(i+1)
            expected = pp1_temp + pp2_temp + pp3_temp + pp4_temp;   // CHANGED: 32-bit, so mod 2^32
            if ((^actual === 1'bx) || (actual !== expected)) begin  // CHANGED: explicit x check
                errors = errors + 1;
                $display("MISMATCH %h %h %h %h exp=%h got=%h",
                         pp1_temp, pp2_temp, pp3_temp, pp4_temp, expected, actual);
            end
        end
    endtask

    initial begin
        {pp1_temp, pp2_temp, pp3_temp, pp4_temp} = 0;                 check;
        pp1_temp = 10; pp2_temp = 20; pp3_temp = 30; pp4_temp = 40;   check;
        pp1_temp = 32'hFFFFFFFF; pp2_temp = 32'hFFFFFFFF;
        pp3_temp = 32'hFFFFFFFF; pp4_temp = 32'hFFFFFFFF;             check;
        for (n = 0; n < 100000; n = n + 1) begin                      // CHANGED: 100k vectors, $urandom
            pp1_temp = $urandom; pp2_temp = $urandom;
            pp3_temp = $urandom; pp4_temp = $urandom;                 check;
        end
        if (errors == 0) $display("PASS"); else $display("FAIL errors=%0d", errors);
        $finish;
    end
endmodule