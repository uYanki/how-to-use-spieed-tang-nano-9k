// Crystal oscillator frequency is 27MHz, so it takes 0.5s to count from 0 to 13499999 (13.5MHz)
`define target 24'd1349_9999

module led(
        input clk_in, // sys clk
        input btn_rst,
        output reg [5:0] led
    );

    /* 24 bit counter */
    reg [23:0] counter;

    /* clock rising edge or button falling edge */
    always @(posedge clk_in or negedge btn_rst)
    begin
        /* ① reset button is pressed
         * ② counter reaches target value */
        if((!btn_rst) || (counter == `target))
            counter <= 24'd0; // reset counter
        /* counter less than target value */
        else
            counter <= counter + 1'd1; // increase 1
    end

    /* clock rising edge or button falling edge */
    always @(posedge clk_in or negedge btn_rst)
    begin
        /* reset button is pressed */
        if(!btn_rst)
            led <= 6'b111110;
        /* counter reaches target value */
        else if (counter == `target)
            led[5:0] <= {led[4:0],led[5]}; // 循环左移
    end

endmodule

