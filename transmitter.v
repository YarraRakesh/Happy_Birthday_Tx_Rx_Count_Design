//Tx module
module transmitter (
    input  wire        i_clk,        
    input  wire        i_rst,        
    input  wire        i_tx_ena_n,    
    input  wire [9:0]  i_data,       
    output reg         o_serial,     
    output reg         o_tx_done     
);

    reg [9:0] shift_reg;
    reg [3:0] bit_cnt;
    reg       busy;  

    always @(posedge i_clk) begin
        if (i_rst) begin
            shift_reg <= 10'd0;
            bit_cnt   <= 4'd0;
            o_serial  <= 1'b0;
            o_tx_done <= 1'b0;
            busy      <= 1'b0;  
        end else begin
            o_tx_done <= 1'b0; 

            if (!busy && !i_tx_ena_n) begin     // start transmission
                shift_reg <= i_data;
                bit_cnt   <= 4'd0;
                busy      <= 1'b1;
            end else if (busy) begin                // Transmitting bits
                o_serial  <= shift_reg[0];      // LSB sending first
                shift_reg <= shift_reg >> 1;
                bit_cnt   <= bit_cnt + 1'b1;

                if (bit_cnt == 4'd9) begin
                    busy      <= 1'b0;
                    o_tx_done <= 1'b1;          // transmission complete
                end
            end
        end
    end

endmodule