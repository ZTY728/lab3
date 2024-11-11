module vm
#(parameter idle=5'b00001,
parameter half=5'b00010,
parameter one=5'b00100,
parameter one_half=5'b01000,
parameter two=5'b10000
)
(
input wire sys_clk,
input wire sys_rst_n,
input wire coin_one,
input wire coin_half,

output reg cola,
output reg change
);
reg[4:0] state;
wire[1:0] coin;
assign coin={coin_one,coin_half};

always@(posedge sys_clk or negedge sys_rst_n)
if(!sys_rst_n)
state<=idle;
else case(state)
	idle:if(coin==2'b01)
			state<=half;
		  else if(coin==2'b10)
			state<=one;
			else
			state<=idle;
	half:if(coin==2'b01)
			state<=one;
		  else if(coin==2'b10)
			state<=one_half;
			else
			state<=half;
	one:if(coin==2'b01)
			state<=one_half;
		  else if(coin==2'b10)
			state<=two;
			else
			state<=one;
	one_half:if(coin==2'b01)
			state<=two;
		  else if(coin==2'b10)
			state<=idle;
			else
			state<=one_half;
	two:if((coin==2'b01)||(coin==2'b10))
			state<=idle;
		 else
			state<=two;
	default:state<=idle;
endcase
always@(posedge sys_clk or negedge sys_rst_n)
if(!sys_rst_n)
cola<=1'b0;
else if((state==two && coin==2'b01)||(state==two&&coin==2'b10)||(state==one_half &&coin==2'b10))
cola<=1'b1;
else
cola<=1'b0;

always@(posedge sys_clk or negedge sys_rst_n)
if(!sys_rst_n)
change<=1'b0;
else if((state==two)&&(coin==2'b10))
change<=1'b1;
else
change<=1'b0;
endmodule