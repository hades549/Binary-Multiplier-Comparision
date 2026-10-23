module tb_radix4_multiplier_with_wallace_tree_and_BKA;

    parameter STRICT = 1;

    reg  signed [7:0]  M, B;
    wire signed [15:0] out;

    radix_4_multiplier_with_wallace_tree_and_BKA dut (.M(M), .B(B), .out(out));

    integer i, j;
    integer vectors = 0, errors = 0, xcount = 0;
    integer err, abs_err, max_err = 0;
    real    sum_abs = 0.0, sum_sq = 0.0;
    reg signed [15:0] expected;

    task check;
        begin
            #1;                                   // let combinational logic settle
            expected = $signed(M) * $signed(B);   // independent reference
            vectors  = vectors + 1;
            if (^out === 1'bx) begin              // x/z can never pass
                xcount = xcount + 1;
                errors = errors + 1;
                if (errors <= 10)
                    $display("X/Z   M=%0d B=%0d exp=%0d got=%b", M, B, expected, out);
            end else if (out !== expected) begin
                errors  = errors + 1;
                err     = out - expected;
                abs_err = (err < 0) ? -err : err;
                sum_abs = sum_abs + abs_err;
                sum_sq  = sum_sq + (abs_err * 1.0) * abs_err;
                if (abs_err > max_err) max_err = abs_err;
                if (errors <= 10)
                    $display("MISMATCH M=%0d B=%0d exp=%0d got=%0d", M, B, expected, out);
            end
        end
    endtask

    initial begin
        // Directed corners first, so a failure is easy to read
        M = 0;    B = 0;    check;
        M = 1;    B = 1;    check;
        M = -1;   B = -1;   check;
        M = -128; B = -128; check;   // largest positive product (16384)
        M = -128; B = 127;  check;   // most negative product
        M = 127;  B = 127;  check;
        M = 127;  B = -128; check;

        // Exhaustive sweep: all 65,536 signed pairs
        for (i = -128; i < 128; i = i + 1)
            for (j = -128; j < 128; j = j + 1) begin
                M = i; B = j; check;
            end

        $display("-------------------------------------------");
        $display("Vectors : %0d", vectors);
        $display("Errors  : %0d  (X/Z: %0d)", errors, xcount);
        if (errors > 0 && xcount < errors) begin   // error metrics over the whole input space
            $display("Error rate : %f", errors * 1.0 / vectors);
            $display("MAE        : %f", sum_abs / vectors);
            $display("MSE        : %f", sum_sq  / vectors);
            $display("Max |err|  : %0d", max_err);
        end
        if (xcount > 0)                     $display("FAIL: X/Z on output");
        else if (STRICT && errors > 0)      $display("FAIL: %0d mismatches", errors);
        else if (STRICT)                    $display("PASS: all %0d vectors exact", vectors);
        else                                $display("DONE (stats only, STRICT=0)");
        $finish;
    end

endmodule