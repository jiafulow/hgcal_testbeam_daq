
`timescale 1 ns / 1 ps

	module daq_link_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 5
	)
	(
		// Users to add ports here
        output wire daq_buffer_we,
        output reg [31:0] daq_buffer_dataOut,
        output wire [12:0] daq_buffer_addr,
        output wire daq_buffer_en, daq_buffer_clk, daq_buffer_reset,
        /*input SIG_IN_1_N, SIG_IN_1_P,
        input SIG_IN_2_N, SIG_IN_2_P,
        input SIG_IN_3_N, SIG_IN_3_P,
        input SIG_IN_4_N, SIG_IN_4_P,
        input CLK_IN_N, CLK_IN_P,*/
        input SIG_IN_1,
        input SIG_IN_2, 
        input SIG_IN_3,
        input SIG_IN_4,
        input CLK_IN,
        output linkOk_1, linkOk_2, linkOk_3, linkOk_4,
        output reg active_LED,
        output reg trig_LED_1, trig_LED_2, trig_LED_3, trig_LED_4,
		// User ports ends
		// Do not modify the ports beyond this line

		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready
	);
// Instantiation of Axi Bus Interface S00_AXI
	daq_link_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) daq_link_v1_0_S00_AXI_inst (
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready)
	);

	// Add user logic here
	assign daq_buffer_clk = bit_clk;
	assign daq_buffer_we = 1;
	assign daq_buffer_en = 1;
	wire[7:0] data_recv_1;
	wire[7:0] data_recv_2;
	wire[7:0] data_recv_3;
	wire[7:0] data_recv_4;
	reg ptr_1, ptr_2, ptr_3, ptr_4;
	reg[7:0] fifo_1[2:0];
	reg[7:0] fifo_2[2:0];
	reg[7:0] fifo_3[2:0];
	reg[7:0] fifo_4[2:0];
	reg[12:0] num_words;
	reg[12:0] lst_evnt_wrds;
	wire trig_1, trig_2, trig_3, trig_4;
    reg[12:0] address_ptr = 0;
    wire evnt, error;
    reg [1:0] state;
    reg k1, k2, k3, k4;
    parameter ST_ACTIVE = 2'b10;
    parameter ST_IDLE = 2'b00;
    parameter ST_ERROR = 2'b11;
    parameter ST_START = 2'b01;
    
    assign evnt = trig_1 || trig_2 || trig_3 || trig_4;
    assign error = !(linkOk_1) || !(linkOk_2) || !(linkOk_3) || !(linkOk_4);

    assign trig_1 = ((!(fifo_1[0]==8'h3c && k1)) && (linkOk_1));
    assign trig_2 = ((!(fifo_2[0]==8'h3c && k2)) && (linkOk_2));
    assign trig_3 = ((!(fifo_3[0]==8'h3c && k3)) && (linkOk_3));
    assign trig_4 = ((!(fifo_4[0]==8'h3c && k4)) && (linkOk_4));
    
    always @(posedge byte_clk) begin
        if (trig_1) trig_LED_1 <= 1;
        else trig_LED_1 <= 0;
        end
        
    always @(posedge byte_clk) begin
        if (trig_2) trig_LED_2 <= 1;
        else trig_LED_2 <= 0;
        end
            
    always @(posedge byte_clk) begin
        if (trig_3) trig_LED_3 <= 1;
        else trig_LED_3 <= 0;
        end
                
    always @(posedge byte_clk) begin
        if (trig_4) trig_LED_4 <= 1;
        else trig_LED_4 <= 0;
        end                            
    
    always @(posedge byte_clk) begin 
	if (error) state <= ST_ERROR;
	else if (state == ST_ERROR) state <= ST_IDLE;
        else if (state == ST_IDLE && evnt) state <= ST_START;
	else if (state == ST_START) state <= ST_ACTIVE;
        else if ((state == ST_ACTIVE) && !evnt) state <= ST_IDLE;
        else state <= state;
        end
      
    always @(posedge byte_clk) begin
        if (state == ST_ACTIVE) active_LED <= 1;
        else if (state == ST_IDLE) active_LED <= 0;
        else active_LED <= active_LED;
        end
             
    always @(posedge byte_clk) begin
        if (!evnt) begin
            ptr_1 <= 0;
            ptr_2 <= 0;
            ptr_3 <= 0;
            ptr_4 <= 0;
            end
        else if (evnt && (state == ST_IDLE)) begin
            if (trig_1) ptr_1 <= 1;
            else ptr_1 <= ptr_1; 
            if (trig_2) ptr_2 <= 1;
            else ptr_2 <= ptr_2;  
            if (trig_3) ptr_3 <= 1;
            else ptr_3 <= ptr_3;  
            if (trig_4) ptr_4 <= 1;
            else ptr_4 <= ptr_4; 
            end
        else begin
            ptr_1 <= ptr_1;
            ptr_2 <= ptr_2;
            ptr_3 <= ptr_3;
            ptr_4 <= ptr_4;
            end
        end   
                   
    always @(posedge byte_clk) begin
        if ((state == ST_ACTIVE) && evnt) begin
            daq_buffer_dataOut[7:0] <= fifo_1[ptr_1];
            daq_buffer_dataOut[15:8] <= fifo_2[ptr_2];
            daq_buffer_dataOut[23:16] <= fifo_3[ptr_3];
            daq_buffer_dataOut[31:24] <= fifo_4[ptr_4];
            num_words <= num_words + 1;
            address_ptr <= address_ptr + 4;
            lst_evnt_wrds <= num_words + 1;
            end
        else begin
            num_words <= 0;
            address_ptr <= address_ptr; 
            daq_buffer_dataOut <= daq_buffer_dataOut;
            end
        end                         
            
       
        
    assign daq_buffer_addr = address_ptr;
    
    //BUFG bufr_inst(.O(CLK_IN), .I(CLK_IN_TMP));
    
    /*IBUFDS #(.IOSTANDARD("LVDS_25")) buf_clk_in (.I(CLK_IN_P),.IB(CLK_IN_N),.O(CLK_IN));
    
    IBUFDS #(.IOSTANDARD("LVDS_25")) buf_sig_in_1 (.I(SIG_IN_1_P),.IB(SIG_IN_1_N),.O(SIG_IN_1)); 
    IBUFDS #(.IOSTANDARD("LVDS_25")) buf_sig_in_2 (.I(SIG_IN_2_P),.IB(SIG_IN_2_N),.O(SIG_IN_2));
    IBUFDS #(.IOSTANDARD("LVDS_25")) buf_sig_in_3 (.I(SIG_IN_3_P),.IB(SIG_IN_3_N),.O(SIG_IN_3));
    IBUFDS #(.IOSTANDARD("LVDS_25")) buf_sig_in_4 (.I(SIG_IN_4_P),.IB(SIG_IN_4_N),.O(SIG_IN_4));*/
    
    decode_function decode_1(.sigIn(SIG_IN_1),.bitclk(bit_clk),.byteclk(byte_clk),
        .linkOk(linkOk_1),.byteOut(data_recv_1),.isK(k_recv_1));

    decode_function decode_2(.sigIn(SIG_IN_2),.bitclk(bit_clk),.byteclk(byte_clk),
        .linkOk(linkOk_2),.byteOut(data_recv_2),.isK(k_recv_2));
        
    decode_function decode_3(.sigIn(SIG_IN_3),.bitclk(bit_clk),.byteclk(byte_clk),
            .linkOk(linkOk_3),.byteOut(data_recv_3),.isK(k_recv_3));
            
    decode_function decode_4(.sigIn(SIG_IN_4),.bitclk(bit_clk),.byteclk(byte_clk),
                .linkOk(linkOk_4),.byteOut(data_recv_4),.isK(k_recv_4));	
                
    always @(posedge byte_clk) begin
        fifo_1[0] <= data_recv_1;
        fifo_1[1] <= fifo_1[0];
        k1 <= k_recv_1;
        end            
        
    always @(posedge byte_clk) begin
            fifo_2[0] <= data_recv_2;
            fifo_2[1] <= fifo_2[0];
            k2 <= k_recv_2;
            end  
            
    always @(posedge byte_clk) begin
                fifo_3[0] <= data_recv_3;
                fifo_3[1] <= fifo_3[0];
                k3 <= k_recv_3;
                end  
                
    always @(posedge byte_clk) begin
                    fifo_4[0] <= data_recv_4;
                    fifo_4[1] <= fifo_4[0];
                    k4 <= k_recv_4;
                    end             
                    
 wire pll_clk, bit_clk_lcl, byte_clk_lcl;
                       
                          PLLE2_BASE #(
                             .BANDWIDTH("OPTIMIZED"),  // OPTIMIZED, HIGH, LOW
                             .CLKFBOUT_MULT(10),        // Multiply value for all CLKOUT, (2-64)
                             .CLKFBOUT_PHASE(0.0),     // Phase offset in degrees of CLKFB, (-360.000-360.000).
                             .CLKIN1_PERIOD(8.0),      // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
                             // CLKOUT0_DIVIDE - CLKOUT5_DIVIDE: Divide amount for each CLKOUT (1-128)
                             .CLKOUT0_DIVIDE(10),
                             .CLKOUT1_DIVIDE(100),
                             .CLKOUT2_DIVIDE(1),
                             .CLKOUT3_DIVIDE(1),
                             .CLKOUT4_DIVIDE(1),
                             .CLKOUT5_DIVIDE(1),
                             // CLKOUT0_DUTY_CYCLE - CLKOUT5_DUTY_CYCLE: Duty cycle for each CLKOUT (0.001-0.999).
                             .CLKOUT0_DUTY_CYCLE(0.5),
                             .CLKOUT1_DUTY_CYCLE(0.5),
                             .CLKOUT2_DUTY_CYCLE(0.5),
                             .CLKOUT3_DUTY_CYCLE(0.5),
                             .CLKOUT4_DUTY_CYCLE(0.5),
                             .CLKOUT5_DUTY_CYCLE(0.5),
                             // CLKOUT0_PHASE - CLKOUT5_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
                             .CLKOUT0_PHASE(0.0),
                             .CLKOUT1_PHASE(0.0),
                             .CLKOUT2_PHASE(0.0),
                             .CLKOUT3_PHASE(0.0),
                             .CLKOUT4_PHASE(0.0),
                             .CLKOUT5_PHASE(0.0),
                             .DIVCLK_DIVIDE(1),        // Master division value, (1-56)
                             .REF_JITTER1(0.0),        // Reference input jitter in UI, (0.000-0.999).
                             .STARTUP_WAIT("FALSE")    // Delay DONE until PLL Locks, ("TRUE"/"FALSE")
                          )
                          PLLE2_BASE_inst (
                             // Clock Outputs: 1-bit (each) output: User configurable clock outputs
                             .CLKOUT0(bit_clk_lcl),   // 1-bit output: CLKOUT0
                             .CLKOUT1(byte_clk_lcl),   // 1-bit output: CLKOUT1
                       //      .CLKOUT2(CLKOUT2),   // 1-bit output: CLKOUT2
                       //      .CLKOUT3(CLKOUT3),   // 1-bit output: CLKOUT3
                       //      .CLKOUT4(CLKOUT4),   // 1-bit output: CLKOUT4
                       //      .CLKOUT4(CLKOUT4),   // 1-bit output: CLKOUT4
                       //      .CLKOUT5(CLKOUT5),   // 1-bit output: CLKOUT5
                             // Feedback Clocks: 1-bit (each) output: Clock feedback ports
                             .CLKFBOUT(pll_clk), // 1-bit output: Feedback clock
                       //      .LOCKED(LOCKED),     // 1-bit output: LOCK
                             .CLKIN1(CLK_IN),     // 1-bit input: Input clock
                             // Control Ports: 1-bit (each) input: PLL control ports
                             .PWRDWN(1'h0),     // 1-bit input: Power-down
                             .RST(1'h0),           // 1-bit input: Reset
                             // Feedback Clocks: 1-bit (each) input: Clock feedback ports
                             .CLKFBIN(pll_clk)    // 1-bit input: Feedback clock
                          );
                       
                       BUFG bufr_inst_byte(.O(byte_clk), .I(byte_clk_lcl));
                       BUFG bufr_inst_bit(.O(bit_clk), .I(bit_clk_lcl));                            
    // User logic ends
	

	

	endmodule
