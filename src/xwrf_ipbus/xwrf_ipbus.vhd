-------------------------------------------------------------------------------
-- Title      : ipbus module with xwrf interface
-- Project    :
-------------------------------------------------------------------------------
-- File       : xwrf_ipbus.vhd
-- Author     : lihm
-- Company    : Tsinghua
-- Created    : 2021-04-26
-- Last update: 2021-04-26
-- Platform   : Xilinx Artix 7
-- Standard   : VHDL'93
-------------------------------------------------------------------------------
-- Description: 
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
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.endpoint_pkg.all;
use work.wishbone_pkg.all;
use work.wr_fabric_pkg.all;
use work.ipbus.all;
use work.gencores_pkg.all;

library unisim;
use unisim.vcomponents.all;

entity xwrf_ipbus is
generic (
    CLK_AUX_FREQ: real := 40.0; -- Default: 40 MHz clock - LHC
    -- Number of address bits within each buffer in UDP I/F
    -- Size of each buffer is 2**ADDRWIDTH
    ADDRWIDTH: natural := 9
    );
port (
    clk_sys_i           : in std_logic;
    rst_sys_n_i         : in std_logic;
    cfg_slave_i         : in  t_wishbone_slave_in;
    cfg_slave_o         : out t_wishbone_slave_out;

    wrf_snk_i           : in  t_wrf_sink_in;
    wrf_snk_o           : out t_wrf_sink_out;
    wrf_src_i           : in  t_wrf_source_in;
    wrf_src_o           : out t_wrf_source_out;
    
    ipb_clk_o           : out std_logic;
    ipb_rst_o           : out std_logic;
    aux_clk_o           : out std_logic;
    aux_rst_o           : out std_logic;

    pkt_o               : out std_logic;
    ipb_out             : out ipb_wbus;
    ipb_in              : in  ipb_rbus

);
end entity;

architecture rtl of xwrf_ipbus is

    signal wb_cfg_my_mac_addr   : std_logic_vector(47 downto 0);
	signal wb_cfg_my_ip_addr    : std_logic_vector(31 downto 0);

    signal pllrst               : std_logic;
    signal dcm_locked           : std_logic;
    signal rst                  : std_logic;
    signal clkfb                : std_logic;
    signal rst_ipb_clk          : std_logic;
    signal rst_mac_clk          : std_logic;
    signal rst_aux_clk          : std_logic;
    signal clk_125M             : std_logic;
    signal clk_31M25            : std_logic;
    signal clk_aux              : std_logic;
    
    signal mac_clk              : std_logic;
    signal ipb_clk              : std_logic;
    signal aux_clk              : std_logic;
    signal mac_tx_data          : std_logic_vector(7 downto 0);
    signal mac_rx_data          : std_logic_vector(7 downto 0);
    signal mac_tx_valid         : std_logic;
    signal mac_tx_last          : std_logic;
    signal mac_tx_error         : std_logic;
    signal mac_tx_ready         : std_logic;
    signal mac_rx_valid         : std_logic;
    signal mac_rx_last          : std_logic;
    signal mac_rx_error         : std_logic;

begin  -- rtl

    pllrst    <= not rst_sys_n_i;
    rst       <= not dcm_locked;
    ipb_clk_o <= ipb_clk;
    ipb_rst_o <= rst_ipb_clk;
    aux_clk_o <= aux_clk;
    aux_rst_o <= rst_aux_clk;

    u_ip_config: entity work.ip_config_wb
    port map(
        rst_n_i            => rst_sys_n_i,
        clk_sys_i          => clk_sys_i,
        cfg_slave_i        => cfg_slave_i,
        cfg_slave_o        => cfg_slave_o,
        wb_cfg_my_mac_addr => wb_cfg_my_mac_addr,
        wb_cfg_my_ip_addr  => wb_cfg_my_ip_addr
    );

    u_wrf2mac : entity work.wrf2mac
    port map(
        rst_sys_n_i      => rst_sys_n_i,
        clk_sys_i        => clk_sys_i,
        src_o            => wrf_src_o,
        src_i            => wrf_src_i,
        rst_mac_clk      => rst_mac_clk,
        mac_clk          => mac_clk,
        mac_tx_data      => mac_tx_data,
        mac_tx_valid     => mac_tx_valid,
        mac_tx_last      => mac_tx_last,
        mac_tx_error     => mac_tx_error,
        mac_tx_ready     => mac_tx_ready
    );

    u_mac2wrf : entity work.mac2wrf
    port map (
        rst_sys_n_i      => rst_sys_n_i,
        clk_sys_i        => clk_sys_i,
        snk_i            => wrf_snk_i,
        snk_o            => wrf_snk_o,
        mac_clk          => mac_clk,
        rst_mac_clk      => rst_mac_clk,
        mac_rx_data      => mac_rx_data,
        mac_rx_valid     => mac_rx_valid,
        mac_rx_last      => mac_rx_last,
        mac_rx_error     => mac_rx_error
    );

    mmcm: MMCME2_BASE
    generic map(
        clkin1_period   => 16.0,
        clkfbout_mult_f => 16.0,
        clkout1_divide  => integer(1000.0 / 125.00),
        clkout2_divide  => integer(1000.0 / 31.25),
        clkout3_divide  => integer(1000.0 / CLK_AUX_FREQ)
    )
    port map(
        clkin1   => clk_sys_i,
        clkfbin  => clkfb,
        clkfbout => clkfb,
        clkout1  => clk_125M,
        clkout2  => clk_31M25,
        clkout3  => clk_aux,
        locked   => dcm_locked,
        rst      => pllrst,
        pwrdwn   => '0'
    );

    bufgmacclk: BUFG port map(
        i => clk_125M,
        o => mac_clk
    );
        
    U_sync_reset_mac_clk : gc_sync_ffs
    generic map (
        g_sync_edge => "positive")
    port map (
        clk_i    => mac_clk,
        rst_n_i  => '1',
        data_i   => rst,
        synced_o => rst_mac_clk
    );

    bufgipb: BUFG port map(
        i => clk_31M25,
        o => ipb_clk
    );

    U_sync_reset_ipb_clk : gc_sync_ffs
    generic map (
        g_sync_edge => "positive")
    port map (
        clk_i    => ipb_clk,
        rst_n_i  => '1',
        data_i   => rst,
        synced_o => rst_ipb_clk
    );
    
    bufgaux: BUFG port map(
        i => clk_aux,
        o => aux_clk
    );

    U_sync_reset_aux_clk : gc_sync_ffs
    generic map (
        g_sync_edge => "positive")
    port map (
        clk_i    => aux_clk,
        rst_n_i  => '1',
        data_i   => rst,
        synced_o => rst_aux_clk
    );

    u_ipbus: entity work.ipbus_ctrl
    generic map(
        ADDRWIDTH        => ADDRWIDTH
    )
    port map(
        mac_addr         => wb_cfg_my_mac_addr,
        ip_addr          => wb_cfg_my_ip_addr,
        mac_clk          => mac_clk,
        rst_macclk       => rst_mac_clk,
        mac_rx_data      => mac_rx_data,
        mac_rx_valid     => mac_rx_valid,
        mac_rx_last      => mac_rx_last,
        mac_rx_error     => mac_rx_error,
        mac_tx_data      => mac_tx_data,
        mac_tx_valid     => mac_tx_valid,
        mac_tx_last      => mac_tx_last,
        mac_tx_error     => mac_tx_error,
        mac_tx_ready     => mac_tx_ready,
        ipb_clk          => ipb_clk,
        rst_ipb          => rst_ipb_clk,
        ipb_out          => ipb_out,
        ipb_in           => ipb_in,
        pkt              => pkt_o
    );

end rtl;
