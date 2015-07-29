`timescale 1ns / 1ps
`include "ADDR_MAP.v"
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module decode_function(
    input byteclk,
    input bitclk,
    input sigIn,
    output reg LinkOut,
	 output reg [8:0] signal,
	 output reg out
    );
	 
reg [9:0] tenb;
reg [9:0] fifo[3:0];
reg [9:0] tenpos = 10'b1001111100;
reg [9:0] tenneg = 10'b0110000011;
wire [8:0] eghtb;
reg[31:0] test;
reg [3:0] count, cnt;
reg err;
reg dispin, link, rst;
wire dispout, code_err, disp_err;
integer i,j;

decode Decode(.datain(tenb), .dispin(dispin), .dataout(eghtb), .dispout(dispout), .code_err(code_err), .disp_err(disp_err));

always @(negedge bitclk) begin
	if(!link) begin
		for (i=1; i<10; i=i+1) fifo[0][i-1]<=fifo[0][i];
		fifo[0][9]<=sigIn;
		if (rst) begin
			j<=0;
			count<=0;
			end
		end
	else begin
		if (j<3) fifo[j+1][count]<=sigIn;
		else fifo[0][count]<=sigIn;
		if(count<9) count<=count+1;
		else begin 
			count<=0;
			if (j<3) j<=j+1;
			else j<=0;
			end
		end
	end

always @(posedge byteclk) begin
	if(link) begin
		tenb<=fifo[j];
		end
	end
	
always@(posedge bitclk) begin
	if(!link) begin
		if (fifo[0]==tenpos) link<=1;
		else if (fifo[0]==tenneg) link<=1;
		rst<=0;
		end
	if(err) begin
		link<=0;
		rst<=1;
		end
	LinkOut<=link;
	end

always@(posedge byteclk) begin
	if (link&&!(tenb==0)) begin
		if ((tenb==tenpos)||(tenb==tenneg))	begin
			if (tenb==tenpos) dispin<=1;
			else dispin<=0;
			out<=0;
			end			
		else if(!((disp_err)||(code_err))) begin
			signal <= eghtb;
			out<=1;
			dispin<=dispout;
			end
		else begin 
			err<=1;
			out<=0;
			end
		end	
	if (err) err<=0;
	end


endmodule
