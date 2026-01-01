//Receiver module
module receiver #(
    parameter [8:0] BIRTHDAY_PATTERN = 9'b010101010  //  MAY(0101) 10(01010)  ---> 010101010
)(
    input  wire i_clk,       
    input  wire i_rst,       
    input  wire i_serial,    
    output reg  o_hit         
);
    reg [8:0] shift_reg;    // month + date

    always @(posedge i_clk) begin
        if (i_rst) begin
            shift_reg <= 9'd0;
            o_hit     <= 1'b0;
        end else begin
            // Shift in new serial bit (LSB first stream)
            shift_reg <= {i_serial, shift_reg[8:1]};
            /* shift_reg = 000000000
            Clock 1 -> i_serial =1 -> shift_reg = 100000000
            Clock 2 -> i_serial =0 -> shift_reg = 010000000
            ...
            Clock 9 -> i_serial =0 -> shift_reg = 000000001
            */

            // Pattern comparison
            if (shift_reg == BIRTHDAY_PATTERN)
                o_hit <= 1'b1;
            else
                o_hit <= 1'b0;
        end
    end

endmodule
