module counter #(
    parameter int LIMIT = 500000
)(
    input  logic clk,
    input  logic rst_n,
    input  logic enabled,
    output logic overflow
);

logic [31:0] value, value_nxt;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        value <= 'b0;
    else
        value <= value_nxt;
end

always_comb begin
    value_nxt = value;
    overflow  = 1'b0;

    if (enabled) begin
        if (value == LIMIT) begin
            value_nxt = 'b0;
            overflow  = 1'b1;
        end else begin
            value_nxt = value + 1;
        end
    end
end

endmodule