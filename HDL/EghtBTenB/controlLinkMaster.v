module controlLinkMaster(input [31:0] dataOut,
			 input [15:0] 	   address,
			 input 		   requestIsWrite,
			 input 		   initiateRequest,
			 input 		   reset,
			 output 	   busy,
			 output            done, 	   
			 output 	   error,
			 output reg [31:0] dataIn,
			 output 	   clk_link_out,
			 output 	   data_link_out,
			 input 		   clk_link_in,
			 input 		   data_link_in);


   wire 			       ack;
      
   // state machine for the link
   reg [2:0] 			       state;
   parameter ST_IDLE = 3'h0;
   parameter ST_BEGIN_REQ = 3'h1;
   parameter ST_REQ_ACTIVE = 3'h2;
   parameter ST_WAIT_NOACK = 3'h3;   
   parameter ST_DONE = 3'h4;

   always @(posedge clk)
     if (reset) state<=ST_IDLE;
     else if (state==ST_IDLE && initiateRequest) 
       state<=ST_BEGIN_REQ;
     else if (state==ST_BEGIN_REQ)
       state<=ST_REQ_ACTIVE;
     else if (state==ST_REQ_ACTIVE && ack)
       state<=ST_WAIT_NOACK;
     else if (state==ST_WAIT_NOACK && ~ack)
       state<=ST_DONE;
     else if (state==ST_DONE && ~initiateRequest)
       state<=ST_IDLE;
     else state<=state;
   
   assign busy=(state!=ST_IDLE && state!=ST_DONE);
   assign done=(state==ST_DONE);
   
   
   // payload outbound
   reg [7:0] outbound_payload [7:0];

   always @(posedge clk)
     if (state==ST_BEGIN_REQ) begin
	outbound_payload[0]<=8'hbc;
	outbound_payload[1]<={6'h0,requestIsWrite,1'h1};	
	outbound_payload[2]<=address[7:0];
	outbound_payload[3]<=address[15:8];
	outbound_payload[4]<=dataOut[7:0];
	outbound_payload[5]<=dataOut[15:8];
	outbound_payload[6]<=dataOut[23:16];
	outbound_payload[7]<=dataOut[31:24];
     end else if (state==ST_IDLE || state==ST_WAIT_NOACK || state==ST_DONE) begin
	outbound_payload[1]<={6'h0,1'h0,1'h0};	
     end

   reg [2:0] outbound_ptr;

   always @(posedge byte_clk)
     outbound_ptr<=outbound_ptr+3'h1;

   reg [7:0] data_to_send;
   reg 	     k_to_send;

   always @(posedge byte_clk) begin
      data_to_send<=outbound_payload[outbound_ptr];
      k_to_send<=(outbound_ptr==3'h0);      
   end

   encode_function encoder(.byteIn(data_to_send),.isK(k_to_send),
			   .sigOut(data_link_out),.clkOut(clk_link_out));

// receiver

   wire [7:0] data_recv;
   wire       k_recv;
   wire       linkOk;
   reg [7:0]  data_recv_dl;
   
   
   
	      
   decode_function decode(.sigIn(data_link_in),.bitclk(clk_link_in),.byteclk(byte_clk),
			  .linkOk(linkOk),.byteOut(data_recv),.isK(k_recv));
   
   assign error=~linkOk;

   reg [2:0]  wptr;
   reg [7:0]  rdata [4:0];

   always @(posedge byte_clk)
     if (data_recv==8'hbc && k_recv) wptr<=3'h7;
     else wptr<=wptr+3'h1;

   always @(posedge byte_clk)
     data_recv_dl<=data_recv;
      
   always @(posedge byte_clk)
     if (linkOk && wptr!=3'h7) rdata[wptr]<=data_recv_dl;
   

   always @(posedge byte_clk)
     if (~linkOk || reset) begin
	ack<=1'h0;
	dataIn<=32'h0;
     end else if (linkOk && wptr!=3'h7 && data_recv==8'hbc && k_recv) begin
	dataIn<={rdata[4],rdata[3],rdata[2],rdata[1]};
	ack<=rdata[0][0];
     end else begin
	dataIn<=dataIn;
	ack<=ack;
     end
      
       
   
endmodule
