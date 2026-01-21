module top_test;

logic clk;
logic rst_n;
logic [7:0] din;

logic tx;
logic tx_buf;
logic tx_done_tick_buf;

// topp
top dut (
    .clk(clk),
    .rst_n(rst_n),
    .din(din),
    .tx(tx),
    .tx_buf(tx_buf),
    .tx_done_tick_buf(tx_done_tick_buf)
);

// Clock
initial clk = 0;
always #5 clk = ~clk;

// Test sequence
initial begin
    
    $dumpfile("sim.vcd");
    $dumpvars(0, top_test);

    // Reset
    rst_n = 0;
    din = 8'h00;
    #20;
    rst_n = 1;

    
    din = 8'hA5;
    #1000;

    $finish;
end

endmodule