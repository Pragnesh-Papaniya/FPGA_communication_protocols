module uart_receiver(
input clk_fpga,
input reset,
input rxd,
output [7:0]rxdata
);
reg shift;
reg state,nextstate;
reg [3:0] bit_counter;
reg [1:0] sample_counter;
reg [13:0] baudrate_counter;
reg [9:0] rxshift_reg;
reg clear_bitcounter, inc_bitcounter, inc_sample_counter, clear_samplecounter;

parameter clk_freq=50_000_000;
parameter baud_rate=9600;
parameter div_sample=4;
parameter div_counter=clk_freq/(baud_rate*div_sample);
parameter mid_sample=div_sample/2;
parameter div_bit=10;

assign rxdata=rxshift_reg[8:1];

always@(posedge clk_fpga)
begin
if(reset)begin
state<=0;
bit_counter<=0;
baudrate_counter<=0;
sample_counter<=0;
end
else begin
baudrate_counter<=baudrate_counter+1;
state<=nextstate;
if(shift)rxshift_reg<={rxd,rxshift_reg[9:1]};
if(clear_samplecounter)sample_counter<=0;
if(inc_sample_counter)sample_counter<=sample_counter+1;
if(clear_bitcounter)bit_counter<=0;
if(inc_bitcounter)bit_counter<=bit_counter+1;
end
end

always@(posedge clk_fpga)
begin
shift<=0;
clear_samplecounter<=0;
inc_sample_counter<=0;
clear_bitcounter<=0;
inc_bitcounter<=0;
nextstate<=0;
case(state)
0:begin 
if(rxd)
begin
nextstate<=0;
end
else begin
nextstate<=1;
clear_bitcounter<=1;
clear_samplecounter<=1;
end
end
1: begin
nextstate<=1;
if(sample_counter==mid_sample-1)shift<=1;
if(sample_counter==div_sample-1)begin
if(bit_counter==div_bit-1)begin
nextstate<=0;
end
inc_bitcounter<=1;
clear_samplecounter<=1;
end else inc_sample_counter<=1;
end
default:nextstate<=0;
endcase
end

endmodule
