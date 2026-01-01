`timescale 1us/1ns

module tb_happy_birthday;

    reg         i_clk;
    reg         i_rst;
    reg         i_tx_ena_n;
    wire [27:0] o_hit_count;
    wire        o_hit_count_valid;

    top_happy_birthday #(.NumDig(4)) dut (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_tx_ena_n(i_tx_ena_n),
        .o_hit_count(o_hit_count),
        .o_hit_count_valid(o_hit_count_valid)
    );

    // 10kHz clock → 100us period
    always #50 i_clk = ~i_clk;

    initial begin
        i_clk = 0;
        i_rst = 1;
        i_tx_ena_n = 1;

        #200;
        i_rst = 0;

        #200;
        i_tx_ena_n = 0;   // Enable TX

        #10_000_000;     // run ~10 sec
        $stop;
    end

    always @(posedge i_clk) begin
        if(o_hit_count_valid)
            $display("TIME=%0t us | 7SEG DATA = %b", $time, o_hit_count);
    end

    initial begin
        $dumpfile("happy_birthday.vcd");
        $dumpvars(0, tb_happy_birthday);
    end

endmodule
