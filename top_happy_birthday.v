module top_happy_birthday #(
    parameter integer NumDig = 4
)(
    input  wire                   i_clk,
    input  wire                   i_rst,
    input  wire                   i_tx_ena_n,
    output wire  [NumDig*7-1 : 0]  o_hit_count,
    output wire                   o_hit_count_valid
);

    wire [9:0]  count_data;
    wire        serial_wire;
    wire        tx_done;
    wire        hit_pulse;
    wire        sec_pulse;
    wire [13:0] hit_count_raw;
    reg  [13:0] hit_count_latched;

    // ---------------- Data Generator ----------------
    data_generator hb_counter (
        .i_clk   (i_clk),
        .i_rst   (i_rst),
        .i_en    (tx_done),
        .o_count (count_data)
    );

    // ---------------- Transmitter -------------------
    transmitter hb_tx (
        .i_clk      (i_clk),
        .i_rst      (i_rst),
        .i_tx_ena_n (i_tx_ena_n),
        .i_data     (count_data),
        .o_serial   (serial_wire),
        .o_tx_done  (tx_done)
    );

    // ---------------- Receiver ----------------------
    receiver hb_rx (
        .i_clk    (i_clk),
        .i_rst    (i_rst),
        .i_serial (serial_wire),
        .o_hit    (hit_pulse)
    );

    // ---------------- One Second Timer --------------
    one_sec_timer hb_timer (
        .i_clk       (i_clk),
        .i_rst       (i_rst),
        .o_sec_pulse (sec_pulse)
    );

    // ---------------- Hit Counter -------------------
    hit_counter hb_hit_counter (
        .i_clk       (i_clk),
        .i_rst       (i_rst),
        .i_hit       (hit_pulse),
        .i_sec_pulse (sec_pulse),
        .o_hit_count (hit_count_raw)
    );

    // -------- Latch hit count every 1 second --------
    always @(posedge i_clk) begin
        if (i_rst)
            hit_count_latched <= 14'd0;
        else if (sec_pulse)
            hit_count_latched <= hit_count_raw;
    end

    // ------------ Binary to BCD conversion ----------
    reg [3:0] d0, d1, d2, d3;
    integer temp;

    always @(*) begin
        temp = hit_count_latched;
        d0 = temp % 10; temp = temp / 10;
        d1 = temp % 10; temp = temp / 10;
        d2 = temp % 10; temp = temp / 10;
        d3 = temp % 10;
    end

    // ------------- 7-Segment Encoding --------------
    wire [6:0] seg0, seg1, seg2, seg3;

    bcd_to_7seg u0 (.bcd(d0), .seg(seg0));
    bcd_to_7seg u1 (.bcd(d1), .seg(seg1));
    bcd_to_7seg u2 (.bcd(d2), .seg(seg2));
    bcd_to_7seg u3 (.bcd(d3), .seg(seg3));

    // ------------- Final Display Output -------------
    assign o_hit_count = {seg3, seg2, seg1, seg0};
    assign o_hit_count_valid = sec_pulse;

endmodule