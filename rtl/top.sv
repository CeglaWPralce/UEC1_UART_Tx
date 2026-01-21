module top (
    input logic [7:0] din,
    input logic rst_n,
    input  logic clk,
    output logic tx,
    output logic tx_buf,
    output logic tx_done_tick_buf
);
// counter dut
counter #(
    .MAX_VALUE(100)
) counter_s (
    .clk(clk),
    .rst_n(rst_n),
    .enabled(1'b1),
    .value(),
    .overflow(overflow_s)
);
// counter dut
counter #(
    .MAX_VALUE(100)
) counter_tx (
    .clk(clk),
    .rst_n(rst_n),
    .enabled(1'b1),
    .value(),
    .overflow(overflow_tx)
);

// uart_tx  dut
uart_tx #(
    .DBIT(8),
    .SB_TICK(16)
) uart_tx_dut(
    .clk(clk),
    .rst_n(rst_n) ,
    .tx_start(overflow_tx),
    .s_tick(overflow_s),
    .din(din),
    .tx_done_tick(tx_done_tick),
    .tx(tx)
);
//   uart_..._buf dut

uart_tx_out_buffer uart_tx_out_buffer_dut (
    .tx_done_tick_in(tx_done_tick),
    .tx_in(tx),
    .rst_n(rst_n),
    .clk(clk),
    .tx_out(tx_buf),
    .tx_done_tick_out(tx_done_tick_buf)
);

endmodule