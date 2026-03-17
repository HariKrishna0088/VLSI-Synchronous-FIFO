//=============================================================================
// Testbench: fifo_tb
// Description: Comprehensive testbench for Synchronous FIFO
// Author: Daggolu Hari Krishna
//=============================================================================

`timescale 1ns / 1ps

module fifo_tb;

    parameter DATA_WIDTH = 8;
    parameter FIFO_DEPTH = 8;
    parameter ADDR_WIDTH = $clog2(FIFO_DEPTH);

    reg                    clk;
    reg                    rst_n;
    reg                    wr_en;
    reg                    rd_en;
    reg  [DATA_WIDTH-1:0]  wr_data;
    wire [DATA_WIDTH-1:0]  rd_data;
    wire                   full;
    wire                   empty;
    wire                   almost_full;
    wire                   almost_empty;
    wire [ADDR_WIDTH:0]    data_count;
    wire                   overflow;
    wire                   underflow;

    integer pass_count = 0;
    integer fail_count = 0;
    integer test_num   = 0;
    integer i;

    // Instantiate FIFO
    sync_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) uut (
        .clk         (clk),
        .rst_n       (rst_n),
        .wr_en       (wr_en),
        .rd_en       (rd_en),
        .wr_data     (wr_data),
        .rd_data     (rd_data),
        .full        (full),
        .empty       (empty),
        .almost_full (almost_full),
        .almost_empty(almost_empty),
        .data_count  (data_count),
        .overflow    (overflow),
        .underflow   (underflow)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    task check;
        input [79:0] test_name;
        input        condition;
    begin
        test_num = test_num + 1;
        if (condition) begin
            $display("[PASS] Test %0d: %s", test_num, test_name);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] Test %0d: %s", test_num, test_name);
            fail_count = fail_count + 1;
        end
    end
    endtask

    initial begin
        $dumpfile("fifo_tb.vcd");
        $dumpvars(0, fifo_tb);

        $display("============================================================");
        $display("   SYNCHRONOUS FIFO TESTBENCH - Daggolu Hari Krishna");
        $display("   Depth: %0d | Width: %0d bits", FIFO_DEPTH, DATA_WIDTH);
        $display("============================================================");
        $display("");

        // Reset
        rst_n   = 1'b0;
        wr_en   = 1'b0;
        rd_en   = 1'b0;
        wr_data = 8'd0;
        #20;
        rst_n = 1'b1;
        #10;

        // ---- Test 1: Empty flag after reset ----
        $display("--- Test: Reset State ---");
        check("Empty after reset ", empty === 1'b1);
        check("Not full on reset ", full === 1'b0);
        check("Count is 0       ", data_count === 0);

        // ---- Test 2: Write until full ----
        $display("");
        $display("--- Test: Fill FIFO ---");
        for (i = 0; i < FIFO_DEPTH; i = i + 1) begin
            @(posedge clk);
            wr_en   = 1'b1;
            wr_data = i + 1;
            @(posedge clk);
            wr_en = 1'b0;
        end
        @(posedge clk);
        check("Full flag set     ", full === 1'b1);
        check("Not empty         ", empty === 1'b0);
        check("Count equals depth", data_count === FIFO_DEPTH);

        // ---- Test 3: Overflow detection ----
        $display("");
        $display("--- Test: Overflow ---");
        @(posedge clk);
        wr_en   = 1'b1;
        wr_data = 8'hFF;
        @(posedge clk);
        wr_en = 1'b0;
        @(posedge clk);
        check("Overflow detected ", overflow === 1'b1);

        // ---- Test 4: Read all data (FIFO order) ----
        $display("");
        $display("--- Test: Read FIFO (verify order) ---");
        for (i = 0; i < FIFO_DEPTH; i = i + 1) begin
            @(posedge clk);
            rd_en = 1'b1;
            @(posedge clk);
            rd_en = 1'b0;
            @(posedge clk);
            check("FIFO data order   ", rd_data === i + 1);
        end

        // ---- Test 5: Empty after reading all ----
        @(posedge clk);
        check("Empty after drain ", empty === 1'b1);

        // ---- Test 6: Underflow detection ----
        $display("");
        $display("--- Test: Underflow ---");
        @(posedge clk);
        rd_en = 1'b1;
        @(posedge clk);
        rd_en = 1'b0;
        @(posedge clk);
        check("Underflow detected", underflow === 1'b1);

        // ---- Test 7: Simultaneous read/write ----
        $display("");
        $display("--- Test: Simultaneous R/W ---");
        // First write something
        @(posedge clk);
        wr_en = 1'b1; wr_data = 8'hAA;
        @(posedge clk);
        wr_en = 1'b0;
        @(posedge clk);

        // Now simultaneous read and write
        wr_en = 1'b1; rd_en = 1'b1; wr_data = 8'hBB;
        @(posedge clk);
        wr_en = 1'b0; rd_en = 1'b0;
        @(posedge clk);
        check("Simul R/W count=1", data_count === 1);

        // Summary
        $display("");
        $display("============================================================");
        $display("  TEST SUMMARY: %0d PASSED, %0d FAILED out of %0d tests",
                 pass_count, fail_count, test_num);
        $display("============================================================");
        if (fail_count == 0)
            $display("  >>> ALL TESTS PASSED! <<<");
        else
            $display("  >>> SOME TESTS FAILED! <<<");
        $display("");
        $finish;
    end

endmodule
