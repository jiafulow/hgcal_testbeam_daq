-- ****************************************************************************
--	MODULE  	: MasterFSM.vhd
--	AUTHOR  	: Paull Rubinov and Cristian Gingu
--	VERSION 	: v1.00
--	DATE		: 12.16.2015
-- ****************************************************************************
--	REVISION HISTORY:
--	-----------------
-- ****************************************************************************
--	FUNCTION DESCRIPTION:
-------------------------------------------------------------------------------
-- Ports description:
-- ****************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.hgc_pck.all;

--library UNISIM;
--use UNISIM.VComponents.all;

entity MasterFSM is
	port ( 
	clk       : in std_logic; --40Mhz
	reset     : in std_logic; --system wide
    ZYNQ_IN   : in ZYNQ_MASTERFSM_INPUT;
    ZYNQ_OUT  : out ZYNQ_MASTERFSM_OUTPUT
	);
end MasterFSM;

architecture rtl of MasterFSM is
--
-- State Machine Type signals.
type state_type is (
	init, 
	sync_find, sync_stable, 
	idle_find, idle_stable,	idle, 
	send_trig, wait_trig_rcv, 
	send_data_start, send_data_body1, send_data_body2, send_data_body3, 
	send_data_body4, send_data_body5, send_data_body6, send_data_body7, 
	send_data_body8, send_data_end, 
	rcv_data_start, rcv_data_body1, rcv_data_body2, rcv_data_body3, 
	rcv_data_body4, rcv_data_body5, rcv_data_body6, rcv_data_body7, 
	rcv_data_body8, rcv_data_end,
	error_state); 
signal state                    : state_type;
--
-- ZYNQ_MASTERFSM_INPUT - State Machine Input signals.
signal cntrl                    : std_logic_vector (7 downto 0);              -- from software application
signal send_memb_not_empty      : std_logic;                                  -- from ctrl_send_mem.vhd
signal send_memb_rdata          : std_logic_vector(31 downto 0);              -- from ctrl_send_mem.vhd
signal send_memb_rdata_stb      : std_logic;                                  -- from ctrl_send_mem.vhd
signal rcv_memb_full            : std_logic;                                  -- from ctrl_rcv_mem.vhd
signal sym_recieved_type        : SYM_TYPE;                                   -- from mdec_nibble.vhd
signal sym_recieved             : std_logic_vector (3 downto 0);              -- from mdec_nibble.vhd
--
-- ZYNQ_MASTERFSM_OUTPUT - State Machine Output signals.
signal status                   : std_logic_vector(7 downto 0):=X"00";        -- to software application
signal send_memb_readnext       : std_logic:='0';                             -- to ctrl_send_mem.vhd
signal rcv_memb_rst_wpointer    : std_logic:='0';                             -- to ctrl_rcv_mem.vhd
signal rcv_memb_wdata           : std_logic_vector(31 downto 0):=X"00000000"; -- to ctrl_rcv_mem.vhd
signal rcv_memb_wdata_stb       : std_logic:='0';                             -- to ctrl_rcv_mem.vhd
signal sym_to_send_type         : SYM_TYPE:=TYPE_INVALID;                     -- to menc_nibble.vhd
signal sym_to_send              : std_logic_vector(3 downto 0):=X"0";         -- to menc_nibble.vhd
signal delay_cnt                : std_logic_vector(2 downto 0):="000";        -- to align_deser_data.vhd
--
-- Other State machine local signals.
signal time_out                 : std_logic_vector(11 downto 0):=X"000";
signal send_memb_not_empty_del1 : std_logic:='0';
signal wait_once                : std_logic:='0';
--
begin
--
-- ZYNQ_MASTERFSM_INPUT - State Machine Input signals assignment.
cntrl                 <= ZYNQ_IN.zCNTRL;
send_memb_not_empty   <= ZYNQ_IN.send_memb_not_empty;
send_memb_rdata       <= ZYNQ_IN.send_memb_rdata;
send_memb_rdata_stb   <= ZYNQ_IN.send_memb_rdata_stb;   -- not used
rcv_memb_full         <= ZYNQ_IN.rcv_memb_full;
sym_recieved_type     <= ZYNQ_IN.sym_recieved_type;
sym_recieved          <= ZYNQ_IN.sym_recieved;
--
-- ZYNQ_MASTERFSM_OUTPUT - State Machine Output signals assignment.
ZYNQ_OUT.zSTATUS                <= status;
ZYNQ_OUT.send_memb_readnext     <= send_memb_readnext;
ZYNQ_OUT.rcv_memb_rst_wpointer  <= rcv_memb_rst_wpointer;
ZYNQ_OUT.rcv_memb_wdata         <= rcv_memb_wdata;
ZYNQ_OUT.rcv_memb_wdata_stb     <= rcv_memb_wdata_stb;
ZYNQ_OUT.sym_to_send_type       <= sym_to_send_type;
ZYNQ_OUT.sym_to_send            <= sym_to_send;
ZYNQ_OUT.deser_data_offset      <= delay_cnt;
--
--
-- *****************************************************************************
-- Master state machine: Combinatorial AND Next State AND Output register process.
-- *****************************************************************************
process(clk) is
begin
    if rising_edge(clk) then
    	--
    	send_memb_not_empty_del1 <= send_memb_not_empty;
    	--
        if reset='1' then
            state <= init;
        else
            case (state) is
            --------------------------------------------------------------------
            when init =>
				status                  <= MFSMstatIDLE;
                send_memb_readnext      <= '0';
                rcv_memb_rst_wpointer   <= '0';
                rcv_memb_wdata          <= X"00000000";
                rcv_memb_wdata_stb      <='0';
                sym_to_send_type        <= TYPE_SYNC;
                sym_to_send             <= X"0";
                delay_cnt               <= "000";
                time_out                <= X"000";
                wait_once               <= '0';
                state                   <= sync_find;
			--------------------------------------------------------------------
			-- This branch executes a SEND_SYNC command:
			when sync_find =>
                sym_to_send_type        <= TYPE_SYNC;
                sym_to_send             <= X"0";

                if sym_recieved_type = TYPE_SYNC then
                	-- first TYPE_SYNC symbol detected; check if it is stable
                	time_out(3 downto 0)<= X"0";
                	status              <= status or MFSMstatBUSY;
                	state               <= sync_stable;
                else
					-- no TYPE_SYNC symbol detected; increment time_out counter;
					-- if time_out = X"0FF", assert MFSMstatTIMEOUT.
					time_out            <= time_out + 1;
					if time_out(3 downto 0) = X"F" then
						-- increment delay_cnt => ZYNQ_OUT.deser_data_offset
						-- every 16 clock periods.
						delay_cnt           <= delay_cnt + 1;
					end if;
                	if time_out = X"0FF" then
						status          <= status or MFSMstatTIMEOUT;
						state           <= error_state;
					else
						status          <= status or MFSMstatBUSY;
						state           <= sync_find;
					end if;
                end if;
			when sync_stable =>
				sym_to_send_type        <= TYPE_SYNC;
				sym_to_send             <= X"0";
				if sym_recieved_type = TYPE_SYNC then
					-- wait for a given number of consecutive TYPE_SYNC symbols
					-- received; any other symbol is not allowed (error)
					if time_out(3 downto 0) = X"F" then
                		if time_out(11 downto 4) = X"0F" then
                        	status      <= status or MFSMstatTIMEOUT;
							state       <= error_state;
						else
							-- TYPE_SYNC is stable; send TYPE_IDLE 
							-- and check if it's stable 
							wait_once   <= '0';
							status      <= status or MFSMstatBUSY;
							state       <= idle_find;
						end if;
					else
						status          <= status or MFSMstatBUSY;
						time_out        <= time_out + 1;
						state           <= sync_stable;
					end if;
				else
					-- TYPE_SYNC is lost, unstable; 
					-- try to re-sync again 
					status              <= status or MFSMstatBUSY;
					time_out(3 downto 0)<= X"0";
					delay_cnt           <= "000";
					state               <= sync_find;
				end if;
			when idle_find =>	
                sym_to_send_type        <= TYPE_IDLE;
				sym_to_send             <= X"0";
				if sym_recieved_type = TYPE_IDLE then
					-- first TYPE_IDLE symbol received; check if it is stable
					time_out(3 downto 0)<= X"0";
					status              <= status or MFSMstatBUSY;
					state               <= idle_stable;
				else
					if sym_recieved_type = TYPE_SYNC then
						-- no TYPE_IDLE symbol received; increment time_out counter;
						-- if time_out = X"0FF", assert MFSMstatTIMEOUT.
						time_out        <= time_out + 1;
						if time_out = X"0FF" then
							status      <= status or MFSMstatTIMEOUT;
							state       <= error_state;
						else
							status      <= status or MFSMstatBUSY;
							state       <= idle_find;
						end if;
					else
						-- symbol received is neither TYPE_IDLE nor TYPE_SYNC;
						-- assert error and goto error_state.
						wait_once <= not(wait_once);
						if wait_once = '0' then
							-- allow one time symbol error (see align_deser_data.vhd
							-- register deser_data_15to0_ff)
							status      <= status or MFSMstatBUSY;
							state       <= idle_find;
						else
							status      <= status or MFSMstatERROR;
							state       <= error_state;
						end if;					
					end if;
				end if;	
			when idle_stable =>
				sym_to_send_type        <= TYPE_IDLE;
				sym_to_send             <= X"0";
				wait_once               <= '0';
				if sym_recieved_type = TYPE_IDLE then
					-- wait for a given number of consecutive TYPE_IDLE symbols
					-- received; any other symbol is not allowed (error)
					if time_out(3 downto 0) = X"F" then
						if time_out(11 downto 4) = X"0F" then
							status      <= status or MFSMstatTIMEOUT;
							state       <= error_state;
						else
							-- TYPE_IDLE is (also) stable; sync process success; 
							-- safe to goto state=idle
							status      <= status or MFSMstatSYNC;
							time_out    <= X"000";
							state       <= idle;
						end if;
					else
						status          <= status or MFSMstatBUSY;
						time_out        <= time_out + 1;
						state           <= idle_stable;
					end if;
				else
					-- TYPE_IDLE is lost, unstable;
					-- assert error and goto error_state.
					status      <= status or MFSMstatTIMEOUT;
					state       <= error_state;
				end if;
            --------------------------------------------------------------------
            -- Decision state: jump to a MFSM branch loop based on:
            -- 1. the command issued: ctrl_CLEAR_ERR, ctrl_SEND_SYNC, 
            --    ctrl_SEND_TRIG, ctrl_SEND_DATA;
            -- 2. the sym_recieved_type: TYPE_INVALID, TYPE_DATA, TYPE_SYNC,
            --    TYPE_IDLE, TYPE_START, TYPE_TRIG;
            when idle =>
            	-- wait for a new command ZYNQ_IN.zCNTRL to execute
                sym_to_send_type        <= TYPE_IDLE;
                sym_to_send             <= X"0";
                --
                if cntrl = ctrl_CLEAR_ERR then
                	status              <= X"00";
                	state               <= idle;
                elsif cntrl = ctrl_SEND_SYNC then
                    state               <= init;
                elsif cntrl = ctrl_SEND_TRIG then
                	state               <= send_trig;
                elsif cntrl = ctrl_SEND_DATA then
                	if send_memb_not_empty = '1' then
                		state           <= send_data_start;
                	else
                		state           <= idle;
                	end if;
                else
                	if sym_recieved_type = TYPE_TRIG then
                		status          <= status or MFSMstatRCVTRIGGER;
                		state           <= idle;
                	elsif sym_recieved_type = TYPE_SYNC    or 
                		  sym_recieved_type = TYPE_INVALID then
                		state           <= init;
                	elsif sym_recieved_type = TYPE_START   or 
                		  sym_recieved_type = TYPE_DATA    then
                		state           <= error_state;
                	else
                		status          <= status or MFSMstatIDLE;
                		state           <= idle;
                	end if;
                end if;
            --------------------------------------------------------------------
            -- This branch executes a SEND_TRIG command: it send a trigger and 
            -- wait until it comes back.
            when send_trig =>
                status                  <= status or MFSMstatBUSY;
                sym_to_send_type        <= TYPE_TRIG;
                sym_to_send             <= X"0";
                time_out                <= X"000";
                state                   <= wait_trig_rcv;
            when wait_trig_rcv =>
                sym_to_send_type        <= TYPE_TRIG;
                sym_to_send             <= X"0";
                if sym_recieved_type = TYPE_TRIG then
                	status              <= status or MFSMstatRCVTRIGGER;
                    state               <= idle;
                else
                    if time_out = X"0FF" then
                        status          <= status or MFSMstatTIMEOUT;
                        state           <= error_state;
                    else
                    	time_out        <= time_out + 1;
                    	status          <= status or MFSMstatBUSY;
                        state           <= wait_trig_rcv;
                    end if;     
                end if;
            --------------------------------------------------------------------
            -- This branch SENDS a packet using 
            -- ctrl_send_mem.vhd and menc_nibble.vhd interface signals.
			when send_data_start =>
				status                  <= status or MFSMstatBUSY;
				sym_to_send_type        <= TYPE_START;
				sym_to_send             <= X"0";
				state                   <= send_data_body1;
			when send_data_body1 =>
				sym_to_send_type        <= TYPE_DATA;
				sym_to_send             <= send_memb_rdata(3 downto 0);
				state                   <= send_data_body2;
			when send_data_body2 =>
				sym_to_send_type        <= TYPE_DATA;
				sym_to_send             <= send_memb_rdata(7 downto 4);
				state                   <= send_data_body3;
			when send_data_body3 =>
				sym_to_send_type        <= TYPE_DATA;
				sym_to_send             <= send_memb_rdata(11 downto 8);
				state                   <= send_data_body4;
			when send_data_body4 =>
				sym_to_send_type        <= TYPE_DATA;
				sym_to_send             <= send_memb_rdata(15 downto 12);
				state                   <= send_data_body5;
			when send_data_body5 =>
				sym_to_send_type        <= TYPE_DATA;
				sym_to_send             <= send_memb_rdata(19 downto 16);
				if send_memb_not_empty = '1' then
					-- NOTE: The optional output register stage used adds an additional clock cycle 
					-- of latency to the Read operation.
					send_memb_readnext  <= '1';
				end if;
				state                   <= send_data_body6;
			when send_data_body6 =>
				sym_to_send_type        <= TYPE_DATA;
				sym_to_send             <= send_memb_rdata(23 downto 20);
				send_memb_readnext      <= '0';
				state                   <= send_data_body7;
			when send_data_body7 =>
				sym_to_send_type        <= TYPE_DATA;
				sym_to_send             <= send_memb_rdata(27 downto 24);
				state                   <= send_data_body8;
			when send_data_body8 =>
				sym_to_send_type        <= TYPE_DATA;
				sym_to_send             <= send_memb_rdata(31 downto 28);
				--
				if send_memb_not_empty = '1' then
					state               <= send_data_body1;
				else
					state               <= send_data_end;
				end if;
				--
            when send_data_end =>
            	sym_to_send_type        <= TYPE_IDLE;
            	sym_to_send             <= X"0";
            	time_out                <= X"000";
                state                   <= rcv_data_start;
            --------------------------------------------------------------------
            -- This branch RECEIVES a packet using 
            -- ctrl_rcv_mem.vhd and mdec_nibble.vhd interface signals.
            when rcv_data_start =>
            	status                          <= status or MFSMstatBUSY;
            	sym_to_send_type                <= TYPE_IDLE;
            	sym_to_send                     <= X"0";
            	rcv_memb_rst_wpointer           <= '1';
            	if sym_recieved_type = TYPE_START then
            		state                       <= rcv_data_body1;
            	else
            		if time_out = X"FFF" then
            		    status          <= status or MFSMstatTIMEOUT;
            		    state           <= error_state;
            		else
            			time_out        <= time_out + 1;
            			status          <= status or MFSMstatBUSY;
            		    state           <= rcv_data_start;
					end if;
            	end if;
			when rcv_data_body1 =>
				rcv_memb_rst_wpointer           <= '0';
				rcv_memb_wdata_stb              <= '0';
				if sym_recieved_type = TYPE_DATA and rcv_memb_full = '0' then
					rcv_memb_wdata(3 downto 0)  <= sym_recieved;
					state                       <= rcv_data_body2;
				elsif sym_recieved_type = TYPE_IDLE then
					status                      <= status or MFSMstatRCVPACKET;
					state                       <= rcv_data_end;
				else
					if rcv_memb_full = '1' then
						status                  <= status or MFSMstatRCVFULL;
					end if;
					state                       <= error_state;
				end if;
			when rcv_data_body2 =>
				if sym_recieved_type = TYPE_DATA then
					rcv_memb_wdata(7 downto 4)  <= sym_recieved;
					state                       <= rcv_data_body3;
				else
					state                       <= error_state;
				end if;
			when rcv_data_body3 =>
				if sym_recieved_type = TYPE_DATA then
					rcv_memb_wdata(11 downto 8) <= sym_recieved;
					state                       <= rcv_data_body4;
				else
					state                       <= error_state;
				end if;
			when rcv_data_body4 =>
				if sym_recieved_type = TYPE_DATA then
					rcv_memb_wdata(15 downto 12)<= sym_recieved;
					state                       <= rcv_data_body5;
				else
					state                       <= error_state;
				end if;
			when rcv_data_body5 =>
				if sym_recieved_type = TYPE_DATA then
					rcv_memb_wdata(19 downto 16)<= sym_recieved;
					state                       <= rcv_data_body6;
				else
					state                       <= error_state;
				end if;
			when rcv_data_body6 =>
				rcv_memb_wdata(23 downto 20)    <= sym_recieved;
				if sym_recieved_type = TYPE_DATA then
					state                       <= rcv_data_body7;
				else
					state                       <= error_state;
				end if;
			when rcv_data_body7 =>
				if sym_recieved_type = TYPE_DATA then
					rcv_memb_wdata(27 downto 24)<= sym_recieved;
					state                       <= rcv_data_body8;
				else
					state                       <= error_state;
				end if;
			when rcv_data_body8 =>
				if sym_recieved_type = TYPE_DATA then
					rcv_memb_wdata_stb          <= '1';
					rcv_memb_wdata(31 downto 28)<= sym_recieved;
					state                       <= rcv_data_body1;
				else
					state                       <= error_state;
				end if;	
			when rcv_data_end =>
				sym_to_send_type                <= TYPE_IDLE;
				sym_to_send                     <= X"0";
				state                           <= idle;
            --------------------------------------------------------------------
            when error_state =>
                if cntrl = ctrl_CLEAR_ERR then
                	status                      <= X"00";
                    state                       <= idle;
                else
                	status                      <= status or MFSMstatERROR;
                    state                       <= error_state;
                end if;                                            
            --------------------------------------------------------------------
            when others =>
                state                           <= init;
            end case;
        end if;
    end if;
end process;
--
--
end rtl;