module debounce_signals #(parameter threshold=1000000)
(input clk,
input btn,
output reg transmit
);

reg button_ff1=0;//to count 10 bits
reg button_ff2=0;//to count 10 bitsreg [9:0] shiftright_register;
reg [30:0] count=0;

always@(posedge clk)
begin
button_ff1<=btn;
button_ff2<=button_ff1;
end

always@(posedge clk)
begin
if(button_ff2)
begin
if(~&count)
count<=count+1;
else begin
if(|count)
count<=count-1;
end
if(count>threshold)
transmit<=1;
else
transmit<=0;
end
end
endmodule
