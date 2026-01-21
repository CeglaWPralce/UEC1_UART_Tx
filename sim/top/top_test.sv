
module top_test;

    logic clk;
    logic rst_n;
    logic [7:0] din;
    logic tx_buf;
    logic tx_done_tick_buf;
    logic tx;


    // instancja top modułu
    top uut (
        .clk(clk),
        .rst_n(rst_n),
        .din(din),
        .tx_buf(tx_buf),
        .tx_done_tick_buf(tx_done_tick_buf),
        .tx(tx)
    );

    // Generacja zegara 50 MHz
    initial clk = 0;
    always #10 clk = ~clk;  // 20 ns okres -> 50 MHz

    // Reset
    initial begin
        rst_n = 0;
        din = 8'h00;
        #100;
        rst_n = 1;
    end

    // Test transmisji wielu bajtów
    initial begin
        wait(rst_n == 1);
        #100;

        // Wysyłamy kilka bajtów po kolei
        din = 8'b10111011; 
        wait(tx_done_tick_buf);
        #1000;

        din = 8'b11100111; 
        wait(tx_done_tick_buf);
        #1000;

        din = 8'hFF; 
        wait(tx_done_tick_buf);
        #1000;

        din = 8'h00; 
        wait(tx_done_tick_buf);
        #1000;

        $display("Test zakończony");
        $stop;
    end

    // Monitorowanie sygnałów
    initial begin
        $display("Time\tclk\trst_n\tdin\ttx_buf\ttx");
        $monitor("%0t\t%b\t%b\t%02h\t%b\t%b", $time, clk, rst_n, din, tx_buf, tx);
    end

endmodule