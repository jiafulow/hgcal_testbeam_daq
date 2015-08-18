module controlLinkSlave(output reg [31:0] dataOut,
			 output reg [15:0] 	   address,
			 output reg	   requestIsWrite,
			 output reg	   strobe,
			 input 		   reset,
			 input             ack,
			 input [31:0] dataIn,
			 output 	   clk_link_out,
			 output 	   data_link_out,
			 input 		   clk_link_in,
			 input 		   data_link_in,
			 output		   linkOk,
			 input           byte_clk,
			 input           bitclk
			);


   // payload outbound
   reg [7:0] outbound_payload [5:0];


    always @(posedge byte_clk) begin
      outbound_payload[0]<=8'h3c;
      outbound_payload[1]<={7'h0,ack};	
      outbound_payload[2]<=dataIn[7:0];
      outbound_payload[3]<=dataIn[15:8];
      outbound_payload[4]<=dataIn[23:16];
      outbound_payload[5]<=dataIn[31:24];
   end

   reg [2:0] outbound_ptr;

   always @(posedge byte_clk)
     if (outbound_ptr==3'd5) outbound_ptr<=3'd0;
     else outbound_ptr<=outbound_ptr+3'h1;

   reg [7:0] data_to_send;
   reg 	     k_to_send;

   always @(posedge byte_clk) begin
      data_to_send<=outbound_payload[outbound_ptr];
      //k_to_send<=(outbound_ptr==3'h0);    
      if (outbound_payload[outbound_ptr]==8'h3c) k_to_send <= 1;
      else k_to_send <= 0;  
   end

 
   encode_function encoder(.byteIn(data_to_send),.bitclk(bitclk), .isK(k_to_send),
			   .sigOut(data_link_out),.clkOut(clk_link_out),.idle(0),.byte_clk(byte_clk));

// receiver

   wire [7:0] data_recv;
   wire       k_recv;
   reg [7:0]  data_recv_dl;
      	      
   decode_function decode(.sigIn(data_link_in),.bitclk(clk_link_in),.byteclk(byte_clk),
			  .linkOk(linkOk),.byteOut(data_recv),.isK(k_recv));
   
   reg [2:0]  wptr;
   reg [7:0]  rdata [6:0];

   always @(posedge byte_clk)
     if (data_recv==8'h3c && k_recv) wptr<=3'h7;
     else wptr<=wptr+3'h1;

   always @(posedge byte_clk)
     data_recv_dl<=data_recv;
      
   always @(posedge byte_clk)
     if (linkOk && wptr!=3'h7) rdata[wptr]<=data_recv_dl;
   

   always @(posedge byte_clk)
     if (~linkOk || reset) begin
	strobe<=1'h0;
	dataOut<=32'h0;
	address<=16'h0;
	requestIsWrite<=1'h0;	
     end else if (linkOk && wptr!=3'h7 && data_recv==8'h3c && k_recv) begin
	dataOut<={rdata[6],rdata[5],rdata[4],rdata[3]};
	address<={rdata[2],rdata[1]};	
	strobe<=rdata[0][0];
	requestIsWrite<=rdata[0][1];	
     end else begin
	strobe<=strobe;
	dataOut<=dataOut;
	address<=address;
	requestIsWrite<=requestIsWrite;	
     end
      
       
   
endmodule
