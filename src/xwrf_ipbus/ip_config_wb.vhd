-------------------------------------------------------------------------------
-- Title      : get ip through wishbone interface
-- Project    :
-------------------------------------------------------------------------------
-- File       : ip_config_wb.vhd
-- Author     : lihm
-- Company    : Tsinghua
-- Created    : 2015-01-26
-- Last update: 2016-01-26
-- Platform   : Xilinx Spartan 6
-- Standard   : VHDL'93
-------------------------------------------------------------------------------
-- Description: Get IP address through wishbone interface for tcpip module.
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
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.wishbone_pkg.all;

entity ip_config_wb is
port(
    clk_sys_i             : in  std_logic;
    rst_n_i               : in  std_logic;
    wb_cfg_my_mac_addr    : out std_logic_vector(47 downto 0);
    wb_cfg_my_ip_addr     : out std_logic_vector(31 downto 0);
    cfg_slave_i           : in  t_wishbone_slave_in;
    cfg_slave_o           : out t_wishbone_slave_out
);
end ip_config_wb;

architecture rtl of ip_config_wb is

  constant c_pad  : std_logic_vector(15 downto 0) := (others => '0');
  constant tcpip_present  : std_logic_vector(31 downto 0) := x"DEADBEEF";

  signal my_mac_addr        : std_logic_vector(47 downto 0);
  signal my_ip_addr         : std_logic_vector(31 downto 0);

  impure function update(x : std_logic_vector) return std_logic_vector is
    alias    y : std_logic_vector(x'length-1 downto 0) is x;
    variable o : std_logic_vector(x'length-1 downto 0);
  begin
  for i in (y'length/8)-1 downto 0 loop
      if cfg_slave_i.sel(i) = '1' then
          o(i*8+7 downto i*8) := cfg_slave_i.dat(i*8+7 downto i*8);
      else
          o(i*8+7 downto i*8) := y(i*8+7 downto i*8);
      end if;
  end loop;
    return o;
  end update;

begin

  wb_cfg_my_mac_addr         <=  my_mac_addr;
  wb_cfg_my_ip_addr          <=  my_ip_addr;

  cfg_slave_o.err <= '0';
  cfg_slave_o.rty <= '0';
  cfg_slave_o.stall <= '0';

  cfg_wbs : process(rst_n_i, clk_sys_i) is
  begin
    if rising_edge(clk_sys_i) then
      if rst_n_i = '0' then
        my_mac_addr           <= x"D15EA5EDBEEF";
        my_ip_addr            <= x"C0A80109";
        cfg_slave_o.ack     <= '0';
        cfg_slave_o.dat     <= (others => '0');
      else
        if cfg_slave_i.cyc = '1' and cfg_slave_i.stb = '1' and cfg_slave_i.we = '1' then
          case to_integer(unsigned(cfg_slave_i.adr(5 downto 2))) is
            when 4 => my_mac_addr(47 downto 32) <= update(my_mac_addr(47 downto 32));
            when 5 => my_mac_addr(31 downto  0) <= update(my_mac_addr(31 downto  0));
            when 6 => my_ip_addr                <= update(my_ip_addr);
            when others => null;
          end case;
        end if;
        cfg_slave_o.ack <= cfg_slave_i.cyc and cfg_slave_i.stb;
        case to_integer(unsigned(cfg_slave_i.adr(5 downto 2))) is
          when 0 => cfg_slave_o.dat <= tcpip_present;
          when 1 => cfg_slave_o.dat <= (others =>'0');
          when 2 => cfg_slave_o.dat <= (others => '0');
          when 3 => cfg_slave_o.dat <= (others => '0');
          when 4 => cfg_slave_o.dat <= c_pad & my_mac_addr(47 downto 32);
          when 5 => cfg_slave_o.dat <= my_mac_addr(31 downto 0);
          when 6 => cfg_slave_o.dat <= my_ip_addr;
          when others => cfg_slave_o.dat <= (others=>'0');
        end case;
      end if;
    end if;
  end process;

end rtl;
