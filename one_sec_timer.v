module one_sec_timer(
    input  wire i_clk,
    input  wire i_rst,
    output reg  o_sec_pulse
);
    reg [13:0] clk_cnt;

    always @(posedge i_clk) begin
        if (i_rst) begin
            clk_cnt <= 14'd0;
            o_sec_pulse <= 1'b0;
        end else begin
            if (clk_cnt == 14'd9999) begin  // if 10kHz clock for 1 second pulse (10,000 cycles) --> 0 to 9999
                clk_cnt <= 14'd0;
                o_sec_pulse <= 1'b1;        // generate 1 sec pulse and given to hit_counter
            end else begin
                clk_cnt <= clk_cnt + 14'd1;
                o_sec_pulse <= 1'b0;
            end
        end
    end

endmodule 