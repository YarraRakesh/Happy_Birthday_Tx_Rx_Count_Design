module data_generator (
    input  wire       i_clk,     
    input  wire       i_rst,     
    input  wire       i_en,               // enable is high when, Tx after sending serially data to Rx
    output reg  [9:0] o_count    
);

    always @(posedge i_clk) begin
        if (i_rst) begin
            o_count <= 10'd0;
        end else if (i_en) begin
            if (o_count == 10'd1023)
                o_count <= 10'd0;
            else
                o_count <= o_count + 10'd1;
        end
    end

endmodule