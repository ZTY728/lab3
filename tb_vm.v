`timescale 1ns/1ns
module tb_vm();
reg sys_clk;
reg sys_rst_n;
reg coin_one;
reg coin_half;
reg random_data;

wire cola;
wire change;

initial begin
sys_clk=1'b1;
sys_rst_n<=1'b0;
#20
sys_rst_n<=1'b1;
end

always #10 sys_clk=~sys_clk;

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

wire[4:0] state=vm_inst.state;
wire[1:0] coin=vm_inst.coin;

initial begin
$timeformat(-9,0,"ns",6);
$monitor("@time %t:coin_one=%b coin_half=%b coin=%b state=%b cola=%b change=%b",
$time,coin_one,coin_half,coin,state,cola,change);
end
vm vm_inst(
.sys_clk(sys_clk),
.sys_rst_n(sys_rst_n),
.coin_one(coin_one),
.coin_half(coin_half),

.cola(cola),
.change(change)
);
endmodule