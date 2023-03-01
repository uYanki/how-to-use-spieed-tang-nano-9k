module main(
    input clk_in, // sys clk
    output wire clk_out,
    output wire pll_out
  );

  assign clk_out = clk_in;

  Gowin_rPLL ppl_inst(
               .clkout(pll_out), //output clkout
               .clkin(clk_in) //input clkin
             );

endmodule

