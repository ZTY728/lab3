`timescale 1ns/1ns
module tb_vmrf();
reg sys_clk;
reg sys_rst_n;
reg coin_one;
reg coin_half;
reg random_data;

wire cola;
wire change;
wire[3:0] refund;

 
initial sys_clk=1'b1;
initial sys_rst_n<=1'b0;




always #10 sys_clk=~sys_clk;
always #80 sys_rst_n=~sys_rst_n;

always@(posedge sys_clk or negedge sys_rst_n)
if(!sys_rst_n)
random_data<=1'b0;
else
random_data<={$random}%2;

always@(posedge sys_clk or negedge sys_rst_n)
if(!sys_rst_n)
coin_one<=1'b0;
else
coin_one<=random_data;

always@(posedge sys_clk or negedge sys_rst_n)
if(!sys_rst_n)
coin_half<=1'b0;
else
coin_half=~random_data;

wire[3:0] state=vmrf_inst.state;
wire[3:0] state_past=vmrf_inst.state_past;
wire[1:0] coin=vmrf_inst.coin;
wire[1:0] coin_past=vmrf_inst.coin_past;
initial begin
$timeformat(-9,0,"ns",6);
$monitor("@time %t:coin_one=%b coin_half=%b coin=%b state=%b cola=%b change=%b refund=%b state_past=%b coin_past=%b",
$time,coin_one,coin_half,coin,state,state_past,cola,change,refund,coin_past);
end
vmrf vmrf_inst(
.sys_clk(sys_clk),
.sys_rst_n(sys_rst_n),
.coin_one(coin_one),
.coin_half(coin_half),

.cola(cola),
.change(change),
.refund(refund)
);
endmodule