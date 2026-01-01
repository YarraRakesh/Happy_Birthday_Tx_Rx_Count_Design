module hit_counter(
    input  wire       i_clk,
    input  wire       i_rst,
    input  wire       i_hit,
    input  wire       i_sec_pulse,
    output reg [13:0] o_hit_count // 14bit counter  2^14 = 16384 > 100000
);
    always @(posedge i_clk) begin
        if (i_rst) begin
            o_hit_count <= 14'd0;
        end else if (i_sec_pulse) begin
            o_hit_count <= 14'd0; // reset every second
        end else if (i_hit) begin     // i_hit dectected from serial_detector(RX)
            o_hit_count <= o_hit_count + 14'd1;
        end
    end
endmodule