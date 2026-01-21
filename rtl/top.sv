module top (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [7:0] din,
    output logic       tx_buf,
    output logic       tx_done_tick_buf,
    output logic       tx
);

    logic s_tick;
    logic tx_start;
    logic tx_done_tick;

    // generator s_tick
    counter #(
        .LIMIT(64)
    ) u_counter_s_tick (
        .clk(clk),
        .rst_n(rst_n),
        .enabled(1'b1),
        .overflow(s_tick)
    );

    // generator tx_start (impuls)
    counter #(
        .LIMIT(512)
    ) u_counter_tx_start (
        .clk(clk),
        .rst_n(rst_n),
        .enabled(~tx_done_tick), // nie startuj gdy UART zajęty
        .overflow(tx_start)
    );

    uart_tx #(
        .DBIT(8),
        .SB_TICK(8)
    ) u_uart_tx (
        .clk(clk),
        .rst_n(rst_n),
        .tx_start(tx_start),
        .s_tick(s_tick),
        .din(din),
        .tx_done_tick(tx_done_tick),
        .tx(tx)
    );

    uart_tx_out_buffer u_uart_tx_out_buffer (
        .tx_done_tick_in(tx_done_tick),
        .tx_in(tx),
        .rst_n(rst_n),
        .clk(clk),
        .tx_out(tx_buf),
        .tx_done_tick_out(tx_done_tick_buf)
    );

endmodule
