`timescale 1ns / 1ps
`include "ADDR_MAP.v"
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

module encode_function(
    input bitclk,
    output reg sigOut,
    output reg clkOut,
	 input reset_IPbus_clk,
    input IPbus_clk,
    input IPbus_strobe,
    input IPbus_write,
    output IPbus_ack,
    input [`MSB_Encode:0] IPbus_addr,
    input [31:0] IPbus_DataIn,
    output [31:0] IPbus_DataOut
    );

wire[9:0] ten_out;	
reg[9:0] loop = 10'b0000000001;
reg[8:0] com_char = 9'b100111100;
reg[8:0] signal_in[8:0];
reg[8:0] data;
reg[4:0] d_cnt;
integer o_cnt;
reg d_in, start;
wire d_out;
integer i,j;

encode Encode(.datain(data), .dispin(d_in), .dataout(ten_out), .dispout(d_out));

always @(posedge loop[0]) begin
	if (d_cnt==8) begin
		d_cnt<=0;
		data[8:0]<=com_char;
		d_in<=d_out;
		end
	else begin
		d_cnt<=d_cnt+1;
		if (o_cnt<7) o_cnt<=o_cnt+1;
		else o_cnt<=0;
		data[8:0]<=signal_in[o_cnt];
		d_in<=d_out;
		end
	end
	
always @(bitclk)
	clkOut<=bitclk;

always @(posedge bitclk) begin
	for (i=1; i<10; i=i+1) loop[i]<=loop[i-1];
	loop[0]<=loop[9];
	end

always @(posedge bitclk) begin
	for (j=0; j<10; j=j+1) begin
		if (loop[j]) sigOut<=ten_out[j];
		end
	end
	
wire write;
wire [31:0] data_out;

IPbus_local 
     #(.ADDR_MSB(`MSB_Encode), 
       .WAIT_STATES(`WAIT_Encode),
       .WRITE_PULSE_TICKS(`WTICKS_Encode))
	 IPbus_local_sensor 
   (.reset(reset_IPbus_clk),
    .clk_local(IPbus_clk),
    .write_local(write),
    .DataOut_local(data_out),
    .IPbus_clk(IPbus_clk),
    .IPbus_strobe(IPbus_strobe),
    .IPbus_write(IPbus_write),
    .IPbus_ack(IPbus_ack),
    .IPbus_DataOut(IPbus_DataOut));

genvar j1;

generate for (j1=0; j1<9; j1=j1+1) begin: gen_j1
      always @(posedge IPbus_clk) begin
	 if (reset_IPbus_clk == 1) signal_in[j1]<=32'h0;
	 else if ((write==1)&&(IPbus_addr==(j1))) signal_in[j1] <= IPbus_DataIn;
	 else signal_in[j1]<=signal_in[j1];
      end
   end endgenerate

assign data_out = (IPbus_addr[3:0]<9)?(signal_in[IPbus_addr]):32'h0;

endmodule
