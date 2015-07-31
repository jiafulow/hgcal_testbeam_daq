`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

module encode_function(
    input [63:0] signal,
    input bitclk,
    output reg sigOut,
    output reg clkOut,
    );

wire[9:0] ten_out;
wire [8:0] signal_in[7:0]	
reg[9:0] loop = 10'b0000000001;
reg[8:0] com_char = 9'b100111100;
reg[8:0] data;
integer o_cnt;
reg d_in, start;
wire d_out;
integer i,j;

assign {signal_in[7],signal_in[6],signal_in[5],signal_in[4],signal_in[3],signal_in[2],signal_in[1],signal_in[0]} = signal;

encode Encode(.datain(data), .dispin(d_in), .dataout(ten_out), .dispout(d_out));

always @(posedge loop[0]) begin
	if (o_cnt<7) o_cnt<=o_cnt+1;
	else o_cnt<=0;
	data[8:0]<=signal_in[o_cnt];
	d_in<=d_out;
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
	
endmodule
