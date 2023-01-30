-------------------------------------------------------------------------------
-- Title      : tcpip module to MAC / Tx
-- Project    :
-------------------------------------------------------------------------------
-- File       : wrf2mac.vhd
-- Author     : lihm
-- Company    : Tsinghua
-- Created    : 2015-01-26
-- Last update: 2016-01-26
-- Platform   : Xilinx Spartan 6
-- Standard   : VHDL'93
-------------------------------------------------------------------------------
-- Description: Tx path, data goes from tcpip module to MAC(WRPC).
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
-- 2016-01-26  2.0      lihm            Add more annotation and error handling
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

library work;
use work.gencores_pkg.all;
use work.genram_pkg.all;
use work.endpoint_pkg.all;
use work.wr_fabric_pkg.all;
use work.endpoint_private_pkg.all;

entity wrf2mac is
port(
    rst_sys_n_i         : in  std_logic;
    rst_mac_clk         : in  std_logic;
    clk_sys_i           : in  std_logic;
    src_o               : out t_wrf_source_out;
    src_i               : in  t_wrf_source_in;
    mac_clk             : in  std_logic;
    mac_tx_data         : in  std_logic_vector(7 downto 0);
		mac_tx_valid        : in  std_logic;
		mac_tx_last         : in  std_logic;
		mac_tx_error        : in  std_logic:='0';
		mac_tx_ready        : out std_logic
);
end wrf2mac;

architecture behavioral of wrf2mac is

  type t_pre_state is(T_IDLE,T_ODD,T_EVEN,T_EVEN_END,T_END,T_DROP);
  signal pre_state : t_pre_state;
  type t_txfsm is (IDLE, GET_SIZE, STATUS ,PAYLOAD, EOF);
  signal txfsm : t_txfsm;

  signal drp_cnt              : unsigned(31 downto 0);
  signal fwd_cnt              : unsigned(31 downto 0);
  signal drp_cnt_inc          : std_logic;
  signal fwd_cnt_inc          : std_logic;

  signal valid_reg            : std_logic;
  signal frame_wr             : std_logic;
  signal frame_in             : std_logic_vector(15 downto 0);
  signal ffifo_almost_full    : std_logic;
  signal frame_rd             : std_logic;
  signal frame_out            : std_logic_vector(15 downto 0);
  signal fsize                : unsigned(15 downto 0);
  signal fsize_in             : std_logic_vector(15 downto 0);
  signal fsize_out            : std_logic_vector(15 downto 0);
  signal fsize_wr             : std_logic;
  signal sfifo_wr_full        : std_logic;
  signal fsize_rd             : std_logic;
  signal sfifo_rd_empty       : std_logic;

  signal txsize   : unsigned(15 downto 0);
  signal src_fab  : t_ep_internal_fabric;
  signal src_dreq : std_logic;

  constant stored_status : t_wrf_status_reg :=
    ('0', '1', '0', '0', '0', (others => '0')); -- has_smac, has_crc

begin

  ---------------------------------------------------------------------------
  ----------------------------- FIFO Write Part -----------------------------
  ---------------------------------------------------------------------------
  fsize_in <= std_logic_vector(fsize);

  p_tx_data:process(mac_clk)
  begin
    if rising_edge(mac_clk) then
      if rst_mac_clk = '1' then
        pre_state   <= T_IDLE;
        fsize       <= (others=>'0');
        fsize_wr    <= '0';
        frame_wr    <= '0';
        frame_in    <= (others=>'0');
        valid_reg   <= '0';
      else
        fsize_wr    <= '0';
        frame_wr    <= '0';

        case( pre_state ) is
          when T_IDLE=>
            if (mac_tx_valid = '1') and (valid_reg ='1') and (sfifo_wr_full = '0') then
              frame_in    <= frame_in(7 downto 0) & mac_tx_data;
              fsize       <= fsize+2;
              frame_wr    <= '1';
              pre_state   <= T_EVEN;
            elsif (valid_reg ='1') and (sfifo_wr_full = '0') then
              fsize       <= fsize+1;
              pre_state   <= T_ODD;
            elsif (mac_tx_valid = '1') and (sfifo_wr_full = '0') then
              frame_in    <= frame_in(7 downto 0) & mac_tx_data;
              fsize       <= fsize+1;
              pre_state   <= T_ODD;
            elsif (mac_tx_valid = '1') or (valid_reg ='1') then
              drp_cnt_inc <= '1';
              pre_state   <= T_DROP;
            end if;          
          when T_EVEN =>
            valid_reg     <= '0';
            if mac_tx_valid ='1' then
              frame_in    <= frame_in(7 downto 0) & mac_tx_data;
              fsize       <= fsize+1;
              pre_state   <= T_ODD;
            end if;
            if mac_tx_last = '1' then
              fsize_wr    <= '1';
              pre_state   <= T_EVEN_END;
            end if ;
          when T_ODD =>
            valid_reg <= '0';
            if mac_tx_valid = '1' then
              frame_in    <= frame_in(7 downto 0) & mac_tx_data;
              frame_wr    <= '1';
              fsize       <= fsize+1;
              pre_state   <= T_EVEN;
            end if ;
            if mac_tx_last = '1' then
              fsize_wr    <= '1';
              pre_state   <= T_END;
            end if ;
          when T_EVEN_END =>
            frame_wr      <= '1';
            frame_in      <= frame_in(7 downto 0) & mac_tx_data;
            fsize         <= (others=>'0');
            if mac_tx_valid = '1' then
              valid_reg   <= '1';
            end if;
            pre_state     <= T_IDLE;
          when T_END =>
            fsize         <= (others=>'0');
            if mac_tx_valid = '1' then
              valid_reg   <= '1';
              frame_in    <= frame_in(7 downto 0) & mac_tx_data;
            end if;
            pre_state     <= T_IDLE;
          when T_DROP =>
            valid_reg     <= '0';        
            if mac_tx_last = '1' then
              pre_state   <= T_END;
            end if;
        end case;
      end if;
    end if;
  end process; -- p_tx_data

  mac_tx_ready <= ((not ffifo_almost_full) and mac_tx_valid);

  --------------------------------------------------------------------------
  ----------------------------- FIFO      Part -----------------------------
  --------------------------------------------------------------------------
  FRAME_FIFO : generic_async_fifo
  generic map (
    g_data_width             => 16,
    g_size                   => 512,
    g_with_rd_empty          => false,
    g_with_rd_almost_empty   => false,
    g_with_rd_count          => false,
    g_with_wr_almost_full    => true,
    g_almost_full_threshold  => 510
  )
  port map (
    clk_wr_i          => mac_clk,
    d_i               => frame_in,
    we_i              => frame_wr,
    wr_almost_full_o  => ffifo_almost_full,
    clk_rd_i          => clk_sys_i,
    q_o               => frame_out,
    rd_i              => frame_rd,
    rd_empty_o        => open
  );

  SIZE_FIFO: entity work.generic_async_fifo
    generic map(
      g_data_width             => 16,
      g_size                   => 8,
      g_with_rd_empty          => true,
      g_with_wr_full           => true,
      g_almost_empty_threshold => 1,
      g_almost_full_threshold  => 7)
    port map(
      clk_wr_i         => mac_clk,
      d_i              => fsize_in,
      we_i             => fsize_wr,
      wr_full_o        => sfifo_wr_full,
      clk_rd_i         => clk_sys_i,
      q_o              => fsize_out,
      rd_i             => fsize_rd,
      rd_empty_o       => sfifo_rd_empty
    );

  --------------------------------------------------------------------------
  ----------------------------- FIFO Read Part -----------------------------
  --------------------------------------------------------------------------
  TX_FSM_P:process(clk_sys_i)
  begin
    if rising_edge(clk_sys_i) then
      if(rst_sys_n_i = '0') then
        txfsm         <= IDLE;
        txsize        <= (others=>'0');
        fsize_rd      <= '0';
        frame_rd      <= '0';
        fwd_cnt_inc   <= '0';
        src_fab.addr  <= (others=>'0');
      else
        fsize_rd <= '0';
        frame_rd <= '0';
        fwd_cnt_inc <= '0';
        src_fab.sof <= '0';
        src_fab.eof <= '0';
        src_fab.dvalid <= '0';

        case txfsm is
          when IDLE =>
            txsize  <= (others=>'0');
            src_fab.bytesel <= '0';
            src_fab.addr <= c_WRF_STATUS;

            if(sfifo_rd_empty = '0' and src_dreq='1') then
              fsize_rd <= '1';
              src_fab.sof <= '1';
              txfsm <= GET_SIZE;
            end if;

          when GET_SIZE =>
            src_fab.dvalid <= '1';
            frame_rd <= '1';
            txfsm <= STATUS;
          
          when STATUS =>
            if(src_dreq='1') then
              frame_rd <= '1';
              src_fab.addr <= c_WRF_DATA;
              txsize <= unsigned(fsize_out) - 2;
              src_fab.dvalid <= '1';
              txfsm <= PAYLOAD;
            end if;
          
          when PAYLOAD =>
            if(src_dreq='1' and txsize>1) then
              txsize <= txsize - 2;
              src_fab.bytesel <= '0';
            elsif(src_dreq='1' and txsize=1) then
              txsize <= txsize - 1;
              src_fab.bytesel <= '1';
            end if;

            if(src_dreq='1' and txsize>2) then
              frame_rd <= '1';
              src_fab.dvalid <= '1';
            elsif( src_dreq='1' and txsize<=2) then
              src_fab.dvalid <= '1';
              txfsm   <= EOF;
            end if;

          when EOF =>
            if(src_dreq='1') then
              src_fab.eof <= '1';
              fwd_cnt_inc <= '1';
              txfsm <= IDLE;
            end if;

          when others =>
            txfsm <= IDLE;
        end case;
      end if;
    end if;
  end process;

  src_fab.has_rx_timestamp <= '0';
  src_fab.rx_timestamp_valid <= '0';
  src_fab.error <= '0';
  src_fab.data <= frame_out when (txfsm=PAYLOAD or txfsm=EOF) else
                  f_marshall_wrf_status(stored_status);

  WRF_SRC: entity work.ep_rx_wb_master
    generic map(
      g_ignore_ack   => false,
      g_cyc_on_stall => true)
    port map(
      clk_sys_i  => clk_sys_i,
      rst_n_i    => rst_sys_n_i,
      snk_fab_i  => src_fab,
      snk_dreq_o => src_dreq,
      src_wb_i   => src_i,
      src_wb_o   => src_o
    );

end behavioral;
