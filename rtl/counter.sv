module counter #(
    parameter MAX_VALUE = 31,
	parameter WIDTH = 5
)(
    input  logic clk,
    input  logic rst_n,
    input  logic enabled,
    output logic [WIDTH-1:0] value,
    output logic overflow
);

    

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            value <= '0;
            overflow <= 1'b0;
        end else if (enabled) begin
            if (value == MAX_VALUE) begin
                value <= '0;
                overflow <= 1'b1;
            end else begin
                value <= value + 1;
                overflow <= 1'b0;
            end
        end
    end

endmodule