-------------------------------------------------------------------------------
-- Title      : ipbus module with xwrf interface
-- Project    :
-------------------------------------------------------------------------------
-- File       : xwrf_gmii.vhd
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
use work.gencores_pkg.all;

library unisim;
use unisim.vcomponents.all;

entity xwrf_gmii is
port (
    clk_sys_i           : in std_logic;
    rst_sys_n_i         : in std_logic;

    wrf_snk_i           : in  t_wrf_sink_in;
    wrf_snk_o           : out t_wrf_sink_out;
    wrf_src_i           : in  t_wrf_source_in;
    wrf_src_o           : out t_wrf_source_out;
    
    gmii_rx_rst_n_i     : in  std_logic;
    gmii_rx_125m_i      : in  std_logic;
    gmii_rxd_i          : in  std_logic_vector(7 downto 0);
    gmii_rxdv_i         : in  std_logic;
    gmii_rx_er          : in  std_logic;

    gmii_tx_125m_i      : in  std_logic;
    gmii_tx_rst_n_i     : in  std_logic;
    gmii_txdata_o       : out std_logic_vector(7 downto 0);
    gmii_txen_o         : out std_logic;
    gmii_tx_er_o        : out std_logic
);
end entity;

architecture rtl of xwrf_gmii is

begin  -- rtl

    u_wrf2mac : entity work.wrfsnk2gmii
    port map(
        clk_sys_i      => clk_sys_i,
        rst_sys_n_i    => rst_sys_n_i,
        gmii_snk_i     => wrf_snk_i,
        gmii_snk_o     => wrf_snk_o,
        clk_125m_i     => gmii_tx_125m_i,
        reset_125m_n_i => gmii_tx_rst_n_i,
        gmii_txdata_o  => gmii_txdata_o,
        gmii_txen_o    => gmii_txen_o,
        gmii_tx_er_o   => gmii_tx_er_o
    );

    u_mac2wrf : entity work.gmii2wrfsrc
    port map (
        rst_sys_n_i    => rst_sys_n_i,
        clk_sys_i      => clk_sys_i,
        gmii_src_o     => wrf_src_o,
        gmii_src_i     => wrf_src_i,
        reset_125m_n_i => gmii_rx_rst_n_i,
        clk_125m_i     => gmii_rx_125m_i,
        gmii_rxd_i     => gmii_rxd_i,
        gmii_rxdv_i    => gmii_rxdv_i,
        gmii_rx_er     => gmii_rx_er
    );

end rtl;
