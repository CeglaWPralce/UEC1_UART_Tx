module top (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [7:0] din,
    output logic       tx_buf,
    output logic       tx_done_tick_buf
);

    logic overflow_s;
    logic overflow_tx;
    logic tx_done_tick;
    logic tx;
    logic tx_start_reg;

    logic [12:0] counter_s_value;
    logic [15:0] counter_tx_value;

    counter #(
        .MAX_VALUE(50), // 326
        .WIDTH(9)
    ) u_counter_s_tick (
        .clk(clk),
        .rst_n(rst_n),
        .enabled(1'b1),
        .value(counter_s_value),
        .overflow(overflow_s)
    );

    counter #(
        .MAX_VALUE(100), //  49999
        .WIDTH(16)
    ) u_counter_tx_start (
        .clk(clk),
        .rst_n(rst_n),
        .enabled(1'b1),
        .value(counter_tx_value),
        .overflow(overflow_tx)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            tx_start_reg <= 1'b0;
        else if (overflow_tx)
            tx_start_reg <= 1'b1;
        else if (tx_done_tick)
            tx_start_reg <= 1'b0;
    end

    uart_tx #(
        .DBIT(8),
        .SB_TICK(16)
    ) u_uart_tx (
        .clk(clk),
        .rst_n(rst_n),
        .tx_start(tx_start_reg),
        .s_tick(overflow_s),
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