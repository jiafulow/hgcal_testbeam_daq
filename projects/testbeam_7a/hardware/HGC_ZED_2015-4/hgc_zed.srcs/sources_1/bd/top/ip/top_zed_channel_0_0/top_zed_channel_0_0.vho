-- (c) Copyright 1995-2016 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: fnal.gov:ip:zed_channel:1.0
-- IP Revision: 4

-- The following code must appear in the VHDL architecture header.

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT top_zed_channel_0_0
  PORT (
    CLK_320 : IN STD_LOGIC;
    CLK_40 : IN STD_LOGIC;
    S00_AXI_araddr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S00_AXI_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    S00_AXI_arready : OUT STD_LOGIC;
    S00_AXI_arvalid : IN STD_LOGIC;
    S00_AXI_awaddr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S00_AXI_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    S00_AXI_awready : OUT STD_LOGIC;
    S00_AXI_awvalid : IN STD_LOGIC;
    S00_AXI_bready : IN STD_LOGIC;
    S00_AXI_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    S00_AXI_bvalid : OUT STD_LOGIC;
    S00_AXI_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    S00_AXI_rready : IN STD_LOGIC;
    S00_AXI_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    S00_AXI_rvalid : OUT STD_LOGIC;
    S00_AXI_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    S00_AXI_wready : OUT STD_LOGIC;
    S00_AXI_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S00_AXI_wvalid : IN STD_LOGIC;
    data_in_from_pins_n : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    data_in_from_pins_p : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    data_out_to_pins_n : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    data_out_to_pins_p : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    s00_axi_aclk : IN STD_LOGIC;
    s00_axi_aresetn : IN STD_LOGIC
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : top_zed_channel_0_0
  PORT MAP (
    CLK_320 => CLK_320,
    CLK_40 => CLK_40,
    S00_AXI_araddr => S00_AXI_araddr,
    S00_AXI_arprot => S00_AXI_arprot,
    S00_AXI_arready => S00_AXI_arready,
    S00_AXI_arvalid => S00_AXI_arvalid,
    S00_AXI_awaddr => S00_AXI_awaddr,
    S00_AXI_awprot => S00_AXI_awprot,
    S00_AXI_awready => S00_AXI_awready,
    S00_AXI_awvalid => S00_AXI_awvalid,
    S00_AXI_bready => S00_AXI_bready,
    S00_AXI_bresp => S00_AXI_bresp,
    S00_AXI_bvalid => S00_AXI_bvalid,
    S00_AXI_rdata => S00_AXI_rdata,
    S00_AXI_rready => S00_AXI_rready,
    S00_AXI_rresp => S00_AXI_rresp,
    S00_AXI_rvalid => S00_AXI_rvalid,
    S00_AXI_wdata => S00_AXI_wdata,
    S00_AXI_wready => S00_AXI_wready,
    S00_AXI_wstrb => S00_AXI_wstrb,
    S00_AXI_wvalid => S00_AXI_wvalid,
    data_in_from_pins_n => data_in_from_pins_n,
    data_in_from_pins_p => data_in_from_pins_p,
    data_out_to_pins_n => data_out_to_pins_n,
    data_out_to_pins_p => data_out_to_pins_p,
    s00_axi_aclk => s00_axi_aclk,
    s00_axi_aresetn => s00_axi_aresetn
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------

