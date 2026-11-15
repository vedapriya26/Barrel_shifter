`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.10.2026 19:02:12
// Design Name: 
// Module Name: barrel_tb
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

module barrel_tb;

    parameter n = 8;
    parameter s = 3;

    wire [n-1:0] dataout;

    reg [n-1:0] datain;
    reg [s-1:0] shift;
    reg cntrl;
    reg [1:0] op;

    barrel_shifter #(
        .n(n),
        .s(s)
    ) dut (
        .dataout(dataout),
        .datain(datain),
        .shift(shift),
        .cntrl(cntrl),
        .op(op)
    );
    function [n-1:0] calculate_expected;

        input [n-1:0] data;
        input [s-1:0] shamt;
        input ctrl;
        input [1:0] operation;

        reg signed [n-1:0] signed_data;
        integer k;

        begin

            k = shamt;
            signed_data = data;

            case (operation)
                2'b00:
                begin
                    if (ctrl == 1'b1)
                        calculate_expected = data >> k;
                    else
                        calculate_expected = data << k;
                end
                2'b01:
                begin
                    if (ctrl == 1'b1)
                        calculate_expected = signed_data >>> k;
                    else
                        calculate_expected = data << k;
                end

                2'b10:
                begin
                    if (k == 0)
                        calculate_expected = data;

                    else if (ctrl == 1'b1)
                        // Right rotate
                        calculate_expected =
                            (data >> k) |
                            (data << (n-k));

                    else
                        // Left rotate
                        calculate_expected =
                            (data << k) |
                            (data >> (n-k));
                end
                default:
                begin
                    calculate_expected = data;
                end

            endcase

        end

    endfunction

    task check_operation;

        input [n-1:0] test_data;
        input [s-1:0] test_shift;
        input test_ctrl;
        input [1:0] test_op;

        reg [n-1:0] expected;

        begin

            datain = test_data;
            shift  = test_shift;
            cntrl  = test_ctrl;
            op     = test_op;

            #5;

            expected = calculate_expected(
                            test_data,
                            test_shift,
                            test_ctrl,
                            test_op
                       );

            if (dataout === expected)

                $display(
                    "[PASS] Time=%0t | Data=%b | Shift=%0d | Ctrl=%b | Op=%b | Expected=%b | Actual=%b",
                    $time,
                    test_data,
                    test_shift,
                    test_ctrl,
                    test_op,
                    expected,
                    dataout
                );

            else

                $display(
                    "[FAIL] Time=%0t | Data=%b | Shift=%0d | Ctrl=%b | Op=%b | Expected=%b | Actual=%b",
                    $time,
                    test_data,
                    test_shift,
                    test_ctrl,
                    test_op,
                    expected,
                    dataout
                );

        end

    endtask

    initial begin

        $monitor(
            "Time=%0t | Data=%b | Shift=%0d | Ctrl=%b | Op=%b | Output=%b",
            $time,
            datain,
            shift,
            cntrl,
            op,
            dataout
        );

    end

    initial begin

        // Logical right shift
        check_operation(8'b10000001, 3'd5, 1'b1, 2'b00);

        // Arithmetic right shift
        check_operation(8'b10000001, 3'd5, 1'b1, 2'b01);

        // Right rotate
        check_operation(8'b10000001, 3'd5, 1'b1, 2'b10);

        // Hold
        check_operation(8'b10000001, 3'd5, 1'b1, 2'b11);


        // Logical left shift
        check_operation(8'b10000001, 3'd5, 1'b0, 2'b00);

        // Arithmetic left shift
        check_operation(8'b10000001, 3'd5, 1'b0, 2'b01);

        // Left rotate
        check_operation(8'b10000001, 3'd5, 1'b0, 2'b10);

        // Hold
        check_operation(8'b10000001, 3'd5, 1'b0, 2'b11);


        // Additional tests
        check_operation(8'b10110110, 3'd1, 1'b1, 2'b00);
        check_operation(8'b10110110, 3'd2, 1'b0, 2'b00);
        check_operation(8'b11001100, 3'd3, 1'b1, 2'b10);
        check_operation(8'b01010101, 3'd2, 1'b0, 2'b10);


        $display("---------------------------------------------");
        $display("     BARREL SHIFTER TEST COMPLETED");
        $display("---------------------------------------------");

        $finish;

    end

endmodule
