--Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2015.4 (lin64) Build 1412921 Wed Nov 18 09:44:32 MST 2015
--Date        : Fri Jan 29 06:34:29 2016
--Host        : athena running 64-bit Ubuntu 14.04.3 LTS
--Command     : generate_target zed_channel.bd
--Design      : zed_channel
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity zed_channel is
  port (
    CLK_320 : in STD_LOGIC;
    CLK_40 : in STD_LOGIC;
    S00_AXI_araddr : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S00_AXI_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S00_AXI_arready : out STD_LOGIC;
    S00_AXI_arvalid : in STD_LOGIC;
    S00_AXI_awaddr : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S00_AXI_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S00_AXI_awready : out STD_LOGIC;
    S00_AXI_awvalid : in STD_LOGIC;
    S00_AXI_bready : in STD_LOGIC;
    S00_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S00_AXI_bvalid : out STD_LOGIC;
    S00_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S00_AXI_rready : in STD_LOGIC;
    S00_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S00_AXI_rvalid : out STD_LOGIC;
    S00_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S00_AXI_wready : out STD_LOGIC;
    S00_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S00_AXI_wvalid : in STD_LOGIC;
    data_in_from_pins_n : in STD_LOGIC_VECTOR ( 0 to 0 );
    data_in_from_pins_p : in STD_LOGIC_VECTOR ( 0 to 0 );
    data_out_to_pins_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    data_out_to_pins_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC
  );
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of zed_channel : entity is "zed_channel.hwdef";
  attribute core_generation_info : string;
  attribute core_generation_info of zed_channel : entity is "zed_channel,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=zed_channel,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=3,numReposBlks=3,numNonXlnxBlks=1,numHierBlks=0,maxHierDepth=0,synth_mode=Global}";
end zed_channel;

architecture STRUCTURE of zed_channel is
  component zed_channel_selectio_wiz_0_0 is
  port (
    data_out_to_pins_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    data_out_to_pins_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    clk_in : in STD_LOGIC;
    clk_div_in : in STD_LOGIC;
    data_out_from_device : in STD_LOGIC_VECTOR ( 7 downto 0 );
    io_reset : in STD_LOGIC
  );
  end component zed_channel_selectio_wiz_0_0;
  component zed_channel_selectio_wiz_0_1 is
  port (
    data_in_from_pins_p : in STD_LOGIC_VECTOR ( 0 to 0 );
    data_in_from_pins_n : in STD_LOGIC_VECTOR ( 0 to 0 );
    clk_in : in STD_LOGIC;
    clk_div_in : in STD_LOGIC;
    io_reset : in STD_LOGIC;
    bitslip : in STD_LOGIC_VECTOR ( 0 to 0 );
    data_in_to_device : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  end component zed_channel_selectio_wiz_0_1;
  component zed_channel_hgc_zed_ip_channel_0_0 is
  port (
    CLK_40 : in STD_LOGIC;
    RX_DATA : in STD_LOGIC_VECTOR ( 7 downto 0 );
    TX_DATA : out STD_LOGIC_VECTOR ( 7 downto 0 );
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC;
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_awready : out STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wready : out STD_LOGIC;
    s00_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_arready : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_rready : in STD_LOGIC
  );
  end component zed_channel_hgc_zed_ip_channel_0_0;
  signal CLK_320_1 : STD_LOGIC;
  signal CLK_40_1 : STD_LOGIC;
  signal S00_AXI_1_ARADDR : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal S00_AXI_1_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal S00_AXI_1_ARREADY : STD_LOGIC;
  signal S00_AXI_1_ARVALID : STD_LOGIC;
  signal S00_AXI_1_AWADDR : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal S00_AXI_1_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal S00_AXI_1_AWREADY : STD_LOGIC;
  signal S00_AXI_1_AWVALID : STD_LOGIC;
  signal S00_AXI_1_BREADY : STD_LOGIC;
  signal S00_AXI_1_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal S00_AXI_1_BVALID : STD_LOGIC;
  signal S00_AXI_1_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal S00_AXI_1_RREADY : STD_LOGIC;
  signal S00_AXI_1_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal S00_AXI_1_RVALID : STD_LOGIC;
  signal S00_AXI_1_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal S00_AXI_1_WREADY : STD_LOGIC;
  signal S00_AXI_1_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal S00_AXI_1_WVALID : STD_LOGIC;
  signal data_in_from_pins_n_1 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal data_in_from_pins_p_1 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal hgc_zed_ip_channel_0_TX_DATA : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal s00_axi_aclk_1 : STD_LOGIC;
  signal s00_axi_aresetn_1 : STD_LOGIC;
  signal selectio_deserializer_data_in_to_device : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal selectio_serializer_data_out_to_pins_n : STD_LOGIC_VECTOR ( 0 to 0 );
  signal selectio_serializer_data_out_to_pins_p : STD_LOGIC_VECTOR ( 0 to 0 );
begin
  CLK_320_1 <= CLK_320;
  CLK_40_1 <= CLK_40;
  S00_AXI_1_ARADDR(3 downto 0) <= S00_AXI_araddr(3 downto 0);
  S00_AXI_1_ARPROT(2 downto 0) <= S00_AXI_arprot(2 downto 0);
  S00_AXI_1_ARVALID <= S00_AXI_arvalid;
  S00_AXI_1_AWADDR(3 downto 0) <= S00_AXI_awaddr(3 downto 0);
  S00_AXI_1_AWPROT(2 downto 0) <= S00_AXI_awprot(2 downto 0);
  S00_AXI_1_AWVALID <= S00_AXI_awvalid;
  S00_AXI_1_BREADY <= S00_AXI_bready;
  S00_AXI_1_RREADY <= S00_AXI_rready;
  S00_AXI_1_WDATA(31 downto 0) <= S00_AXI_wdata(31 downto 0);
  S00_AXI_1_WSTRB(3 downto 0) <= S00_AXI_wstrb(3 downto 0);
  S00_AXI_1_WVALID <= S00_AXI_wvalid;
  S00_AXI_arready <= S00_AXI_1_ARREADY;
  S00_AXI_awready <= S00_AXI_1_AWREADY;
  S00_AXI_bresp(1 downto 0) <= S00_AXI_1_BRESP(1 downto 0);
  S00_AXI_bvalid <= S00_AXI_1_BVALID;
  S00_AXI_rdata(31 downto 0) <= S00_AXI_1_RDATA(31 downto 0);
  S00_AXI_rresp(1 downto 0) <= S00_AXI_1_RRESP(1 downto 0);
  S00_AXI_rvalid <= S00_AXI_1_RVALID;
  S00_AXI_wready <= S00_AXI_1_WREADY;
  data_in_from_pins_n_1(0) <= data_in_from_pins_n(0);
  data_in_from_pins_p_1(0) <= data_in_from_pins_p(0);
  data_out_to_pins_n(0) <= selectio_serializer_data_out_to_pins_n(0);
  data_out_to_pins_p(0) <= selectio_serializer_data_out_to_pins_p(0);
  s00_axi_aclk_1 <= s00_axi_aclk;
  s00_axi_aresetn_1 <= s00_axi_aresetn;
hgc_zed_ip_channel_0: component zed_channel_hgc_zed_ip_channel_0_0
     port map (
      CLK_40 => CLK_40_1,
      RX_DATA(7 downto 0) => selectio_deserializer_data_in_to_device(7 downto 0),
      TX_DATA(7 downto 0) => hgc_zed_ip_channel_0_TX_DATA(7 downto 0),
      s00_axi_aclk => s00_axi_aclk_1,
      s00_axi_araddr(3 downto 0) => S00_AXI_1_ARADDR(3 downto 0),
      s00_axi_aresetn => s00_axi_aresetn_1,
      s00_axi_arprot(2 downto 0) => S00_AXI_1_ARPROT(2 downto 0),
      s00_axi_arready => S00_AXI_1_ARREADY,
      s00_axi_arvalid => S00_AXI_1_ARVALID,
      s00_axi_awaddr(3 downto 0) => S00_AXI_1_AWADDR(3 downto 0),
      s00_axi_awprot(2 downto 0) => S00_AXI_1_AWPROT(2 downto 0),
      s00_axi_awready => S00_AXI_1_AWREADY,
      s00_axi_awvalid => S00_AXI_1_AWVALID,
      s00_axi_bready => S00_AXI_1_BREADY,
      s00_axi_bresp(1 downto 0) => S00_AXI_1_BRESP(1 downto 0),
      s00_axi_bvalid => S00_AXI_1_BVALID,
      s00_axi_rdata(31 downto 0) => S00_AXI_1_RDATA(31 downto 0),
      s00_axi_rready => S00_AXI_1_RREADY,
      s00_axi_rresp(1 downto 0) => S00_AXI_1_RRESP(1 downto 0),
      s00_axi_rvalid => S00_AXI_1_RVALID,
      s00_axi_wdata(31 downto 0) => S00_AXI_1_WDATA(31 downto 0),
      s00_axi_wready => S00_AXI_1_WREADY,
      s00_axi_wstrb(3 downto 0) => S00_AXI_1_WSTRB(3 downto 0),
      s00_axi_wvalid => S00_AXI_1_WVALID
    );
selectio_deserializer: component zed_channel_selectio_wiz_0_1
     port map (
      bitslip(0) => '0',
      clk_div_in => CLK_40_1,
      clk_in => CLK_320_1,
      data_in_from_pins_n(0) => data_in_from_pins_n_1(0),
      data_in_from_pins_p(0) => data_in_from_pins_p_1(0),
      data_in_to_device(7 downto 0) => selectio_deserializer_data_in_to_device(7 downto 0),
      io_reset => '0'
    );
selectio_serializer: component zed_channel_selectio_wiz_0_0
     port map (
      clk_div_in => CLK_40_1,
      clk_in => CLK_320_1,
      data_out_from_device(7 downto 0) => hgc_zed_ip_channel_0_TX_DATA(7 downto 0),
      data_out_to_pins_n(0) => selectio_serializer_data_out_to_pins_n(0),
      data_out_to_pins_p(0) => selectio_serializer_data_out_to_pins_p(0),
      io_reset => '0'
    );
end STRUCTURE;
