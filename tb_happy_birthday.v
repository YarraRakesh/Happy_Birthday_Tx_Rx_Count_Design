`timescale 1us/1ns
module tb_happy_birthday;
    reg         i_clk;
    reg         i_rst;
    reg         i_tx_ena_n;
    wire [27:0] o_hit_count;
    wire        o_hit_count_valid;

    top_happy_birthday #(
        .NumDig(4)
    ) dut (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_tx_ena_n(i_tx_ena_n),
        .o_hit_count(o_hit_count),
        .o_hit_count_valid(o_hit_count_valid)
    );

    always #50 i_clk = ~i_clk;   // 10 kHz clock ---> 100 us period

    initial begin
        i_clk      = 0;
        i_rst      = 1;
        i_tx_ena_n = 1;    // transmission disabled
        #300;            
        i_rst = 0;
        #200;
        i_tx_ena_n = 0;   // transmission ENABLED
        #10000000;         // run ~10 seconds
        $stop;
    end

    always @(posedge i_clk) begin  // Print only when data is valid
        if (o_hit_count_valid) begin
            $display("TIME=%0t us | HIT_COUNT=%0d", $time, o_hit_count);
        end
    end

    initial begin
        $dumpfile("happy_birthday.vcd");
        $dumpvars(0, tb_happy_birthday);
    end
endmodule
 