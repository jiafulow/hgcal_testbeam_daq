`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module decodeman(
    input bitclk_in,
    output bitclk_out,
    output reg byteclk_out
    );

reg[9:0] loop = 10'b0000100001;
integer i;

always @(posedge bitclk_in) begin
	for (i=1; i<10; i=i+1) loop[i]<=loop[i-1];
	loop[0]<=loop[9];
	if (loop[0]) byteclk_out<=!(byteclk_out);
	end

assign bitclk_out = bitclk_in;
	
endmodule
