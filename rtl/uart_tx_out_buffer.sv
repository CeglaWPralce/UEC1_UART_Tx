module uart_tx_out_buffer (
    input logic tx_done_tick_in,
    input logic tx_in,
    input logic rst_n,
    input logic clk,
    output logic tx_out,
    output logic tx_done_tick_out
);
always_ff @(posedge clk or negedge rst_n)  begin
    if (!rst_n) begin
        tx_out <= 1'b1;
        tx_done_tick_out <= 1'b0;
    end
    else begin
        tx_out <= tx_in;
        tx_done_tick_out <= tx_done_tick_in;
    end

end
/*
kiedy clk posedge, jeśli negedge rst_n
to gdy rst_n przyjmuje logiczne 0
do tx_out przypisywane są 1
do tx_done_tick_out przypisywane są 0
inaczej wartość tx_out to tx_in opóźnione  o 1clk
podobnie  z tx_done_tick_out (wyniesie 1 tylko jeżeli w stanie stop uart_tx s_tick było 1 i s osiągnęło SB_TICK-1)
*/

endmodule

