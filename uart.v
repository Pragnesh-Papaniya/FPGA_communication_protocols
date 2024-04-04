module uart(
input clk,
input [7:0] data,
input transmit,
input reset,
output reg txd
);

reg [3:0] bit_counter;//to count 10 bits
reg [13:0] baudrate_counter;//cnt=clk/BR
reg [9:0] shiftright_register;
reg state, next_state;
reg shift;
reg load;
reg clear;

//uart transmission
always@(posedge clk)
if(reset)
begin
state<=0;
bit_counter<=0;
baudrate_counter<=0;
end
else begin
baudrate_counter<=baudrate_counter+1;
if(baudrate_counter==10415)
begin
state<=next_state;
baudrate_counter<=0;
if(load)
shiftright_register<={1'b1,data,1'b0};
if(clear)
bit_counter<=0;
if(shift)
shiftright_register<=shiftright_register>>1;
bit_counter<=bit_counter+1;
end
end

always@(posedge clk)
begin 
load<=0;
shift<=0;
clear<=0;
txd<=1;

case(state)
0:
begin
if(transmit)
begin
next_state<=1;
load<=1;
shift<=0;
clear<=0;
end
else begin
next_state<=0;
txd<=1;
end
end

1: begin
if(bit_counter==10)
begin
next_state<=0;
clear<=1;
end
else begin
next_state<=1;
txd<=shiftright_register[0];
shift<=1;
end
end

default: next_state<=0;
endcase

end

endmodule
