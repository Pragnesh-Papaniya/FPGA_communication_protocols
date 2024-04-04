module top_module
(input clk,
input [7:0] data,
input btn,
input transmit,
output  txd,
output  txd_debug,
output  transmit_debug,
output  btn_debug,
output  clk_debug
);

wire transmit_out;
assign txd_debug=txd;
assign transmit_debug=transmit_out;
assign btn_debug=btn;
assign clk_debug=clk;

debounce_signals(clk,btn,transmit_out);
uart u1(clk,transmit,transmit_out,data,txd);


endmodule
