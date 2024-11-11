module vmrf
#(parameter idle=4'b0000,
parameter half=4'b0001,
parameter one=4'b0010,
parameter one_half=4'b0100,
parameter two=4'b1000
)
(
input wire sys_clk,
input wire sys_rst_n,
input wire coin_one,
input wire coin_half,

output reg cola,
output reg[4:0] refund,
output reg change
);
reg[3:0] state;
reg[3:0] state_past;
wire[1:0] coin;
reg[1:0] coin_past;
assign coin={coin_one,coin_half};

always@(posedge sys_clk or negedge sys_rst_n)
if(!sys_rst_n)begin
state<=idle;
state_past<=idle;
end

else case(state)
	idle:if(coin==2'b01)begin
			state<=half;
			state_past<=idle;
			end
		  else if(coin==2'b10)begin
			state<=one;
			state_past<=idle;
			end
			else begin
			state<=idle;
			state_past<=state_past;
			end
	half:if(coin==2'b01)begin
			state<=one;
			state_past<=half;
			end
		  else if(coin==2'b10)begin
			state<=one_half;
			state_past<=half;
			end
			else begin
			state<=half;
			state_past<=state_past;
			end
	one:if(coin==2'b01)begin
			state<=one_half;
			state_past<=one;
			end
		  else if(coin==2'b10)begin
			state<=two;
			state_past<=one;
			end
			else begin
			state<=one;
			state_past<=state_past;
			end
	one_half:if(coin==2'b01)begin
			state<=two;
			state_past<=one_half;
			end
		  else if(coin==2'b10)begin
			state<=idle;
			state_past<=one_half;
			end
			else begin
			state<=one_half;
			state_past<=state_past;
			end
	two:if((coin==2'b01)||(coin==2'b10))begin
			state<=idle;
			state_past<=idle;
			end
		 else begin
			state<=two;
			state_past<=idle;
			end
	default:state<=idle;
endcase

always@(posedge sys_clk)
begin
    if(sys_rst_n == 1'b1)begin
        coin_past<= coin;
		  end
	 else if(coin==2'b00)begin
			coin_past<=2'b00;
			end
	 else 
			coin_past<=2'b00;
end

always@(posedge sys_clk or negedge sys_rst_n)
if(!sys_rst_n)begin
cola<=1'b0;
end
else if((state==two && coin==2'b01)||(state==two&&coin==2'b10)||(state==one_half&&coin==2'b10))begin
cola<=1'b1;
end
else 
cola<=1'b0;


always@(posedge sys_clk or negedge sys_rst_n)
if(!sys_rst_n)
change<=1'b0;
else if((state==two)&&(coin==2'b10))
change<=1'b1;
else
change<=1'b0;

always@(posedge sys_clk or negedge sys_rst_n)
if(!sys_rst_n)begin
refund=state_past+coin+coin_past;
end
else if((state_past==two && coin_past==2'b01)||(state_past==two&&coin_past==2'b10)||(state_past==one_half&&coin_past==2'b10))begin
refund=coin;
end
else
refund=5'b00000;
endmodule