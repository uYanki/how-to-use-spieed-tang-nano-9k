module decoder24 (
        input in_b,in_a,
        output reg [3:0] out
    );

    always @(in_b,in_a) begin

    case ({in_b,in_a})
`ifndef DECODER_MODE_NOT
        2'b00: out = 4'b0001;
        2'b01: out = 4'b0010;
        2'b10: out = 4'b0100;
        2'b11: out = 4'b1000;
`else 
        2'b00: out = 4'b1110;
        2'b01: out = 4'b1101;
        2'b10: out = 4'b1011;
        2'b11: out = 4'b0111;
`endif
    endcase

    end

endmodule

