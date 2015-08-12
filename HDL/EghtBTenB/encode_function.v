`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

module encode_function (
	 input [7:0] byteIn,
    input bitclk,
	 input isK,
	 input idle,
    output reg sigOut,
    output clkOut
    );

wire[9:0] ten_out;	
reg[3:0] count;
reg[8:0] com_char = 9'b100111100;
reg[8:0] data;
reg d_in;
wire d_out;
reg i;
reg[9:0] outp[1:0];
integer k;
reg b_clk;

enc Encode(.datain(data), .dispin(d_in), .dataout(ten_out), .dispout(d_out));

always @(posedge bitclk) begin
	for (k=1; k<10; k=k+1) loop[k]<=loop[k-1];
	loop[0]<=loop[9];
	if (loop[0]) b_clk<=!(b_clk);
	else b_clk<=b_clk;
	end

assign clkOut = bitclk;

always @(posedge b_clk) begin
	if (idle) begin
		data<=com_char;
		d_in<=d_out;
		end
	else begin
		data[7:0]<=byteIn;
		data[8]<=isK;
		d_in<=d_out;
		end
	end
	
always @(posedge b_clk) begin
	if(!(i)) outp[1] <= ten_out;
	else outp[0]<=ten_out;
	end

always @(posedge bitclk) begin
	if (count<9) count<=count+1;
	else count <=0;
	sigOut <= outp[i][count];
	end

always @(posedge bitclk) begin
	if (i==0) i<=1;
	else i<=0;
	end
	
endmodule
