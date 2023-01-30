-------------------------------------------------------------------------------
-- Title      : MAC Rx module
-- Project    :
-------------------------------------------------------------------------------
-- File       : mac2wrf.vhd
-- Author     : lihm
-- Company    : Tsinghua
-- Created    : 2015-01-26
-- Last update: 2016-01-26
-- Platform   : Xilinx Virtex 6
-- Standard   : VHDL'93
-------------------------------------------------------------------------------
-- Description: Rx path, data goes from MAC(WRPC) to UDP RX module.
-------------------------------------------------------------------------------
--
-- Copyright (c) 2011 CERN
--
-- This source file is free software; you can redistribute it
-- and/or modify it under the terms of the GNU Lesser General
-- Public License as published by the Free Software Foundation;
-- either version 2.1 of the License, or (at your option) any
-- later version.
--
-- This source is distributed in the hope that it will be
-- useful, but WITHOUT ANY WARRANTY; without even the implied
-- warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
-- PURPOSE.  See the GNU Lesser General Public License for more
-- details.
--
-- You should have received a copy of the GNU Lesser General
-- Public License along with this source; if not, download it
-- from http://www.gnu.org/licenses/lgpl-2.1.html
--
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2015-01-26  1.0      lihm            Created
-- 2016-01-26  2.0      lihm            Add more annotation
-- 2016-03-09  3.0      lihm            Rewrite
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.gencores_pkg.all;
use work.genram_pkg.all;
use work.endpoint_pkg.all;
use work.wr_fabric_pkg.all;

entity mac2wrf is
port (
    clk_sys_i           : in std_logic;
    rst_sys_n_i         : in std_logic;
    mac_clk             : in std_logic;
    rst_mac_clk         : in std_logic;
    snk_i               : in  t_wrf_sink_in;
    snk_o               : out t_wrf_sink_out;
    -- AXI4 style MAC signals
    mac_rx_data         : out std_logic_vector(7 downto 0);
    mac_rx_valid        : out std_logic;
    mac_rx_last         : out std_logic;
    mac_rx_error        : out std_logic
);
end entity;

architecture rtl of mac2wrf is

    constant C_FIFO_WIDTH : integer := 16 + 1;

    signal fifo_wr_almost_full, fifo_wrreq, fifo_rdreq,fifo_rdempty: std_logic;
    signal fifo_wrdata, fifo_rddata   : std_logic_vector(c_fifo_width-1 downto 0);

    signal dvalid :std_logic;
    signal pre_data: std_logic_vector(15 downto 0);
    signal pre_sel:std_logic;

    signal snk_out: t_wrf_sink_out;

    signal post_data: std_logic_vector(15 downto 0);
    signal post_sel:std_logic;

    -- signal mac_rx_sof   :std_logic;
    signal bytesel:std_logic;

    type t_state is(T_IDLE,T_DATA);
    signal state : t_state;

    type rx_state is (S_IDLE,S_WT_START,S_START,S_ODD,S_EVEN,S_END);
    signal mac_rx_state: rx_state;

    function f_b2s (x : boolean)
        return std_logic is
    begin
        if(x) then
            return '1';
        else
            return '0';
        end if;
    end function;

begin  -- rtl

    fifo_wrdata <= pre_sel & pre_data;

    snk_o         <= snk_out;
    snk_out.stall <= fifo_wr_almost_full;
    snk_out.err   <= '0';
    snk_out.rty   <= '0';

    p_gen_ack : process(clk_sys_i)
    begin
    if rising_edge(clk_sys_i) then
        if rst_sys_n_i = '0' then
            snk_out.ack <= '0';
        else
            snk_out.ack <= snk_i.cyc and snk_i.stb and snk_i.we and not snk_out.stall;
        end if;
    end if;
    end process;

    dvalid <= f_b2s(snk_i.adr=C_WRF_DATA) and snk_i.cyc and snk_i.stb; -- data valid

    p_snk_fsm: process (clk_sys_i)
    begin
    if rising_edge(clk_sys_i) then
        if rst_sys_n_i = '0' then
            pre_sel <= '0';
            pre_data <= (others=>'0');
            fifo_wrreq <= '0';
        else
            case( state ) is
                when T_IDLE =>
                    pre_sel <= '0';
                    pre_data <= (others=>'0');
                    fifo_wrreq <= '0';
                    if dvalid = '1' then
                        pre_data <= snk_i.dat;
                        fifo_wrreq <= '1';
                        state <= T_DATA;
                        if (snk_i.sel = "11") then
                            pre_sel <= '0';
                        else
                            pre_sel <= '1';
                        end if;
                    end if ;

                when T_DATA =>
                    pre_data <= snk_i.dat;
                    if (snk_i.sel = "11") then
                        pre_sel <= '0';
                    else
                        pre_sel <= '1';
                    end if;
                    fifo_wrreq <= '1';

                    if (dvalid = '0') then
                        pre_data <= (others=>'0');
                        pre_sel <= '0';
                        fifo_wrreq <= '0';
                        state <= T_IDLE;
                    end if ;

                when others =>
                    state <= T_IDLE;
            end case ;
        end if ;
    end if ;
    end process;

    U_tcp_rx_fifo : entity work.generic_async_fifo
    generic map (
        g_data_width             => c_fifo_width,
        g_size                   => 16,
        g_with_rd_empty          => true,
        g_with_rd_almost_empty   => false,
        g_with_rd_count          => false,
        g_with_wr_almost_full    => true,
        g_almost_empty_threshold => 4,
        g_almost_full_threshold  => 15
    )
    port map (
        clk_wr_i                 => clk_sys_i,
        d_i                      => fifo_wrdata,
        we_i                     => fifo_wrreq,
        wr_empty_o               => open,
        wr_full_o                => open,
        wr_almost_empty_o        => open,
        wr_almost_full_o         => fifo_wr_almost_full,
        wr_count_o               => open,
        clk_rd_i                 => mac_clk,
        q_o                      => fifo_rddata,
        rd_i                     => fifo_rdreq,
        rd_empty_o               => fifo_rdempty,
        rd_full_o                => open,
        rd_almost_empty_o        => open,
        rd_almost_full_o         => open,
        rd_count_o               => open
    );

    post_data <= fifo_rddata(15 downto 0);
    post_sel <=fifo_rddata(16);

    p_rd_fsm:process(mac_clk)
    begin
    if rising_edge(mac_clk) then
        if rst_mac_clk = '1' then
            -- mac_rx_sof <= '0';
            mac_rx_data  <= (others=>'0');
            mac_rx_last  <= '0';
            mac_rx_valid <= '0';
            fifo_rdreq   <= '0';
        else
            case (mac_rx_state) is
                when S_IDLE =>
                    -- mac_rx_sof <= '0';
                    mac_rx_data  <= (others=>'0');
                    mac_rx_last  <= '0';
                    mac_rx_valid <= '0';
                    fifo_rdreq   <= '0';
                    if fifo_rdempty = '0' then
                        fifo_rdreq <= '1';
                        mac_rx_state <= S_WT_START;
                    end if;

                when S_WT_START=>
                    mac_rx_state <= S_START;
                    fifo_rdreq   <= '0';

                when S_START=>
                    -- mac_rx_sof <= '1';
                    mac_rx_data  <= post_data(15 downto 8);
                    mac_rx_valid <= '1';
                    mac_rx_last  <= '0';
                    fifo_rdreq   <= '1';
                    mac_rx_state <= S_ODD;

                when S_EVEN=>
                    -- mac_rx_sof <= '0';
                    mac_rx_data  <= post_data(15 downto 8);
                    mac_rx_last  <= '0';
                    mac_rx_valid <= '1';
                    fifo_rdreq   <= '1';
                    mac_rx_state <= S_ODD;
                    if fifo_rdempty = '1' then
                        fifo_rdreq <= '0';
                        if post_sel='1' then
                            mac_rx_state <= S_END;
                            mac_rx_last <= '1';
                        else
                            mac_rx_state <= S_ODD;
                        end if;
                    end if;

                    when S_ODD=>
                        -- mac_rx_sof <= '0';
                        mac_rx_data  <= post_data(7 downto 0);
                        mac_rx_last  <= '0';
                        mac_rx_valid <= '1';
                        fifo_rdreq   <= '0';
                        mac_rx_state <= S_EVEN;
                        if fifo_rdempty = '1' then
                            mac_rx_state <= S_END;
                            mac_rx_last  <= '1';
                            fifo_rdreq   <= '0';
                        end if;

                    when S_END =>
                        -- mac_rx_sof <= '0';
                        mac_rx_data  <= (others=>'0');
                        mac_rx_last  <= '0';
                        mac_rx_valid <= '0';
                        fifo_rdreq   <= '0';
                        mac_rx_state <= S_IDLE;
                    when others=>
                        mac_rx_state <= S_IDLE;
                end case;
            end if;
        end if;
    end process;

    mac_rx_error <= '0';

end rtl;
