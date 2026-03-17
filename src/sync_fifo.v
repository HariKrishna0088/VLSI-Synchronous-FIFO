//=============================================================================
// Module: sync_fifo
// Description: Parameterized Synchronous FIFO
// Author: Daggolu Hari Krishna
//
// Parameters:
//   DATA_WIDTH - Width of data bus (default 8)
//   FIFO_DEPTH - Number of entries (default 16, must be power of 2)
//
// Features:
//   - Configurable depth and width
//   - Full and Empty flags
//   - Almost Full and Almost Empty flags
//   - Data count output
//   - Overflow and Underflow error flags
//=============================================================================

module sync_fifo #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(FIFO_DEPTH)
)(
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    wr_en,      // Write enable
    input  wire                    rd_en,      // Read enable
    input  wire [DATA_WIDTH-1:0]   wr_data,    // Write data
    output reg  [DATA_WIDTH-1:0]   rd_data,    // Read data
    output wire                    full,       // FIFO full
    output wire                    empty,      // FIFO empty
    output wire                    almost_full,  // One slot remaining
    output wire                    almost_empty, // One entry remaining
    output reg  [ADDR_WIDTH:0]     data_count,   // Number of valid entries
    output reg                     overflow,     // Write to full FIFO
    output reg                     underflow     // Read from empty FIFO
);

    // Memory array
    reg [DATA_WIDTH-1:0] mem [0:FIFO_DEPTH-1];

    // Pointers
    reg [ADDR_WIDTH-1:0] wr_ptr;
    reg [ADDR_WIDTH-1:0] rd_ptr;

    // Status flags
    assign full         = (data_count == FIFO_DEPTH);
    assign empty        = (data_count == 0);
    assign almost_full  = (data_count == FIFO_DEPTH - 1);
    assign almost_empty = (data_count == 1);

    // FIFO logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr     <= {ADDR_WIDTH{1'b0}};
            rd_ptr     <= {ADDR_WIDTH{1'b0}};
            data_count <= {(ADDR_WIDTH+1){1'b0}};
            rd_data    <= {DATA_WIDTH{1'b0}};
            overflow   <= 1'b0;
            underflow  <= 1'b0;
        end else begin
            overflow  <= 1'b0;
            underflow <= 1'b0;

            case ({wr_en, rd_en})
                2'b01: begin // Read only
                    if (!empty) begin
                        rd_data    <= mem[rd_ptr];
                        rd_ptr     <= rd_ptr + 1;
                        data_count <= data_count - 1;
                    end else begin
                        underflow <= 1'b1;
                    end
                end

                2'b10: begin // Write only
                    if (!full) begin
                        mem[wr_ptr] <= wr_data;
                        wr_ptr      <= wr_ptr + 1;
                        data_count  <= data_count + 1;
                    end else begin
                        overflow <= 1'b1;
                    end
                end

                2'b11: begin // Simultaneous read and write
                    if (empty) begin
                        // FIFO empty: only write
                        mem[wr_ptr] <= wr_data;
                        wr_ptr      <= wr_ptr + 1;
                        data_count  <= data_count + 1;
                    end else if (full) begin
                        // FIFO full: only read
                        rd_data    <= mem[rd_ptr];
                        rd_ptr     <= rd_ptr + 1;
                        data_count <= data_count - 1;
                    end else begin
                        // Normal: both read and write
                        mem[wr_ptr] <= wr_data;
                        wr_ptr      <= wr_ptr + 1;
                        rd_data     <= mem[rd_ptr];
                        rd_ptr      <= rd_ptr + 1;
                        // data_count stays the same
                    end
                end

                default: begin
                    // No operation
                end
            endcase
        end
    end

endmodule
