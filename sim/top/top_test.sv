
module top_test;

    logic clk;
    logic rst_n;
    logic [7:0] din;
    logic tx_buf;
    logic tx_done_tick_buf;

     initial begin
        // zapis do pliku waveform
        $dumpfile("top_test.vcd");
        $dumpvars(0, top_test);
     end

    // instancja top modułu
    top uut (
        .clk(clk),
        .rst_n(rst_n),
        .din(din),
        .tx_buf(tx_buf),
        .tx_done_tick_buf(tx_done_tick_buf)
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
        din = 8'h55; // 01010101
        wait(tx_done_tick_buf == 1);
        #50;

        din = 8'hAA; // 10101010
        wait(tx_done_tick_buf == 1);
        #50;

        din = 8'hFF; // 11111111
        wait(tx_done_tick_buf == 1);
        #50;

        din = 8'h00; // 00000000
        wait(tx_done_tick_buf == 1);
        #50;

        $display("Test zakończony");
        $stop;
    end

    // Monitorowanie sygnałów
    initial begin
        $display("Time\tclk\trst_n\tdin\ttx_buf\ttx_done_tick_buf");
        $monitor("%0t\t%b\t%b\t%02h\t%b\t%b", $time, clk, rst_n, din, tx_buf, tx_done_tick_buf);
    end

endmodule