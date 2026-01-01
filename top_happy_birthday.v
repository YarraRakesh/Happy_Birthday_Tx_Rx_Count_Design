module top_happy_birthday #(
    parameter integer NumDig = 4  
)(
    input  wire                   i_clk,           
    input  wire                   i_rst,           
    input  wire                   i_tx_ena_n,       
    output wire  [NumDig*7-1 : 0] o_hit_count,  //28    
    output wire                   o_hit_count_valid 
);

    wire [9:0]  count_data;
    wire        serial_wire;
    wire        tx_done;
    wire        hit_pulse;
    wire        sec_pulse;
    wire [13:0] hit_count_raw;
    reg  [13:0] hit_count_latched;

    //Counter 10-bit
    data_generator hb_counter (
        .i_clk (i_clk),
        .i_rst (i_rst),
        .i_en  (tx_done),
        .o_count (count_data)
    );

    //Tx
    transmitter hb_tx (
        .i_clk      (i_clk),
        .i_rst      (i_rst),
        .i_tx_ena_n (i_tx_ena_n),
        .i_data     (count_data),
        .o_serial   (serial_wire),
        .o_tx_done  (tx_done)
    );

    //Rx
    receiver hb_rx (
        .i_clk    (i_clk),
        .i_rst    (i_rst),
        .i_serial (serial_wire),
        .o_hit    (hit_pulse)
    );

    //One Sec Timer
    one_sec_timer hb_timer (
        .i_clk       (i_clk),
        .i_rst       (i_rst),
        .o_sec_pulse (sec_pulse)
    );

    //Hit Counter
    hit_counter hb_hit_counter (
        .i_clk       (i_clk),
        .i_rst       (i_rst),
        .i_hit       (hit_pulse),
        .i_sec_pulse (sec_pulse),
        .o_hit_count (hit_count_raw)
    );

    //Display Logic
    always @(posedge i_clk) begin
        if (i_rst) begin
            hit_count_latched <= 14'd0;
        end else if (sec_pulse) begin
            hit_count_latched <= hit_count_raw;
        end
    end
    
    assign o_hit_count = hit_count_latched;
    assign o_hit_count_valid = sec_pulse;

endmodule