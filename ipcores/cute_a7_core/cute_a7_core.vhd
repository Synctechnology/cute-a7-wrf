-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.2 (lin64) Build 2258646 Thu Jun 14 20:02:38 MDT 2018
-- Date        : Sat Nov 12 21:18:30 2022
-- Host        : yeym-thu-dell running 64-bit Ubuntu 16.04.7 LTS
-- Command     : write_vhdl -mode synth_stub -force ../cute-a7-wrf/ipcores/cute_a7_core//cute_a7_core.vhd
-- Design      : cute_a7_core
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcsg325-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cute_a7_core is
  Port ( 
    SFP_RATE_SELECT_O : out STD_LOGIC_VECTOR ( 1 downto 0 );
    SFP_TX_DISABLE_O : out STD_LOGIC_VECTOR ( 1 downto 0 );
    SFP_TX_O_N : out STD_LOGIC_VECTOR ( 1 downto 0 );
    SFP_TX_O_P : out STD_LOGIC_VECTOR ( 1 downto 0 );
    SFP_RX_I_N : in STD_LOGIC_VECTOR ( 1 downto 0 );
    SFP_RX_I_P : in STD_LOGIC_VECTOR ( 1 downto 0 );
    SFP_FAULT_I : in STD_LOGIC_VECTOR ( 1 downto 0 );
    SFP_LOS_I : in STD_LOGIC_VECTOR ( 1 downto 0 );
    UART_RX_I : in STD_LOGIC;
    UART_TX_O : out STD_LOGIC;
    RESET_N : in STD_LOGIC;
    PPS_O_P : out STD_LOGIC;
    PPS_O_N : out STD_LOGIC;
    SYNC_CLK_10M_O_P : out STD_LOGIC;
    SYNC_CLK_10M_O_N : out STD_LOGIC;
    VER0 : in STD_LOGIC;
    VER1 : in STD_LOGIC;
    VER2 : in STD_LOGIC;
    CLK_62M5_DMTD : in STD_LOGIC;
    FPGA_GCLK_P : in STD_LOGIC;
    FPGA_GCLK_N : in STD_LOGIC;
    MGTREFCLK1_P : in STD_LOGIC;
    MGTREFCLK1_N : in STD_LOGIC;
    OE_125M : out STD_LOGIC;
    MGTREFCLK0_P : in STD_LOGIC;
    MGTREFCLK0_N : in STD_LOGIC;
    DAC_LDAC_N : out STD_LOGIC;
    DAC_SCLK : out STD_LOGIC;
    DAC_SYNC_N : out STD_LOGIC;
    DAC_SDI : out STD_LOGIC;
    DAC_SDO : in STD_LOGIC;
    DAC_DMTD_LDAC_N : out STD_LOGIC;
    DAC_DMTD_SCLK : out STD_LOGIC;
    DAC_DMTD_SYNC_N : out STD_LOGIC;
    DAC_DMTD_SDI : out STD_LOGIC;
    DAC_DMTD_SDO : in STD_LOGIC;
    DELAY_EN : out STD_LOGIC_VECTOR ( 0 to 0 );
    DELAY_SCLK : out STD_LOGIC_VECTOR ( 0 to 0 );
    DELAY_SLOAD : out STD_LOGIC_VECTOR ( 0 to 0 );
    DELAY_SDIN : out STD_LOGIC_VECTOR ( 0 to 0 );
    QSPI_CS : out STD_LOGIC;
    QSPI_DQ0 : out STD_LOGIC;
    QSPI_DQ1 : in STD_LOGIC;
    PLL_CS : out STD_LOGIC;
    PLL_REFSEL : out STD_LOGIC;
    PLL_RESET : out STD_LOGIC;
    PLL_SCLK : out STD_LOGIC;
    PLL_SDO : out STD_LOGIC;
    PLL_SYNC : out STD_LOGIC;
    PLL_LOCK : in STD_LOGIC;
    PLL_SDI : in STD_LOGIC;
    PLL_STAT : in STD_LOGIC;
    GM_FMC_PPS_IN : in STD_LOGIC;
    GM_FMC_PPS_TERM_EN : out STD_LOGIC;
    GM_FMC_EXT_PLL_LOCK : in STD_LOGIC;
    GM_FMC_EXT_PLL_SDI : in STD_LOGIC;
    GM_FMC_EXT_PLL_RESET : out STD_LOGIC;
    GM_FMC_EXT_PLL_SYNC : out STD_LOGIC;
    GM_FMC_EXT_PLL_CS : out STD_LOGIC;
    GM_FMC_EXT_PLL_SCLK : out STD_LOGIC;
    GM_FMC_EXT_PLL_SDO : out STD_LOGIC;
    onewire_i : in STD_LOGIC;
    onewire_oen_o : out STD_LOGIC;
    sfp_scl_i : in STD_LOGIC_VECTOR ( 1 downto 0 );
    sfp_scl_o : out STD_LOGIC_VECTOR ( 1 downto 0 );
    sfp_sda_i : in STD_LOGIC_VECTOR ( 1 downto 0 );
    sfp_sda_o : out STD_LOGIC_VECTOR ( 1 downto 0 );
    sfp_det_i : in STD_LOGIC_VECTOR ( 1 downto 0 );
    clk_ext_i : in STD_LOGIC;
    clk_ext_mul_i : in STD_LOGIC;
    rst_62m5_n_o : out STD_LOGIC;
    clk_62m5_o : out STD_LOGIC;
    pps_csync_o : out STD_LOGIC;
    tm_time_valid_o : out STD_LOGIC;
    tm_tai_o : out STD_LOGIC_VECTOR ( 39 downto 0 );
    tm_cycles_o : out STD_LOGIC_VECTOR ( 27 downto 0 );
    \eb_cfg_master_o[cyc]\ : out STD_LOGIC;
    \eb_cfg_master_o[stb]\ : out STD_LOGIC;
    \eb_cfg_master_o[adr]\ : out STD_LOGIC_VECTOR ( 31 downto 0 );
    \eb_cfg_master_o[sel]\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \eb_cfg_master_o[we]\ : out STD_LOGIC;
    \eb_cfg_master_o[dat]\ : out STD_LOGIC_VECTOR ( 31 downto 0 );
    \eb_cfg_master_i[ack]\ : in STD_LOGIC;
    \eb_cfg_master_i[err]\ : in STD_LOGIC;
    \eb_cfg_master_i[rty]\ : in STD_LOGIC;
    \eb_cfg_master_i[stall]\ : in STD_LOGIC;
    \eb_cfg_master_i[dat]\ : in STD_LOGIC_VECTOR ( 31 downto 0 );
    \eb_wrf_src_o[1][adr]\ : out STD_LOGIC_VECTOR ( 1 downto 0 );
    \eb_wrf_src_o[1][dat]\ : out STD_LOGIC_VECTOR ( 15 downto 0 );
    \eb_wrf_src_o[1][cyc]\ : out STD_LOGIC;
    \eb_wrf_src_o[1][stb]\ : out STD_LOGIC;
    \eb_wrf_src_o[1][we]\ : out STD_LOGIC;
    \eb_wrf_src_o[1][sel]\ : out STD_LOGIC_VECTOR ( 1 downto 0 );
    \eb_wrf_src_o[0][adr]\ : out STD_LOGIC_VECTOR ( 1 downto 0 );
    \eb_wrf_src_o[0][dat]\ : out STD_LOGIC_VECTOR ( 15 downto 0 );
    \eb_wrf_src_o[0][cyc]\ : out STD_LOGIC;
    \eb_wrf_src_o[0][stb]\ : out STD_LOGIC;
    \eb_wrf_src_o[0][we]\ : out STD_LOGIC;
    \eb_wrf_src_o[0][sel]\ : out STD_LOGIC_VECTOR ( 1 downto 0 );
    \eb_wrf_src_i[1][ack]\ : in STD_LOGIC;
    \eb_wrf_src_i[1][stall]\ : in STD_LOGIC;
    \eb_wrf_src_i[1][err]\ : in STD_LOGIC;
    \eb_wrf_src_i[1][rty]\ : in STD_LOGIC;
    \eb_wrf_src_i[0][ack]\ : in STD_LOGIC;
    \eb_wrf_src_i[0][stall]\ : in STD_LOGIC;
    \eb_wrf_src_i[0][err]\ : in STD_LOGIC;
    \eb_wrf_src_i[0][rty]\ : in STD_LOGIC;
    \eb_wrf_snk_o[1][ack]\ : out STD_LOGIC;
    \eb_wrf_snk_o[1][stall]\ : out STD_LOGIC;
    \eb_wrf_snk_o[1][err]\ : out STD_LOGIC;
    \eb_wrf_snk_o[1][rty]\ : out STD_LOGIC;
    \eb_wrf_snk_o[0][ack]\ : out STD_LOGIC;
    \eb_wrf_snk_o[0][stall]\ : out STD_LOGIC;
    \eb_wrf_snk_o[0][err]\ : out STD_LOGIC;
    \eb_wrf_snk_o[0][rty]\ : out STD_LOGIC;
    \eb_wrf_snk_i[1][adr]\ : in STD_LOGIC_VECTOR ( 1 downto 0 );
    \eb_wrf_snk_i[1][dat]\ : in STD_LOGIC_VECTOR ( 15 downto 0 );
    \eb_wrf_snk_i[1][cyc]\ : in STD_LOGIC;
    \eb_wrf_snk_i[1][stb]\ : in STD_LOGIC;
    \eb_wrf_snk_i[1][we]\ : in STD_LOGIC;
    \eb_wrf_snk_i[1][sel]\ : in STD_LOGIC_VECTOR ( 1 downto 0 );
    \eb_wrf_snk_i[0][adr]\ : in STD_LOGIC_VECTOR ( 1 downto 0 );
    \eb_wrf_snk_i[0][dat]\ : in STD_LOGIC_VECTOR ( 15 downto 0 );
    \eb_wrf_snk_i[0][cyc]\ : in STD_LOGIC;
    \eb_wrf_snk_i[0][stb]\ : in STD_LOGIC;
    \eb_wrf_snk_i[0][we]\ : in STD_LOGIC;
    \eb_wrf_snk_i[0][sel]\ : in STD_LOGIC_VECTOR ( 1 downto 0 );
    LED_GREEN_O : out STD_LOGIC_VECTOR ( 1 downto 0 );
    LED_RED_O : out STD_LOGIC_VECTOR ( 1 downto 0 )
  );

end cute_a7_core;

architecture stub of cute_a7_core is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "SFP_RATE_SELECT_O[1:0],SFP_TX_DISABLE_O[1:0],SFP_TX_O_N[1:0],SFP_TX_O_P[1:0],SFP_RX_I_N[1:0],SFP_RX_I_P[1:0],SFP_FAULT_I[1:0],SFP_LOS_I[1:0],UART_RX_I,UART_TX_O,RESET_N,PPS_O_P,PPS_O_N,SYNC_CLK_10M_O_P,SYNC_CLK_10M_O_N,VER0,VER1,VER2,CLK_62M5_DMTD,FPGA_GCLK_P,FPGA_GCLK_N,MGTREFCLK1_P,MGTREFCLK1_N,OE_125M,MGTREFCLK0_P,MGTREFCLK0_N,DAC_LDAC_N,DAC_SCLK,DAC_SYNC_N,DAC_SDI,DAC_SDO,DAC_DMTD_LDAC_N,DAC_DMTD_SCLK,DAC_DMTD_SYNC_N,DAC_DMTD_SDI,DAC_DMTD_SDO,DELAY_EN[0:0],DELAY_SCLK[0:0],DELAY_SLOAD[0:0],DELAY_SDIN[0:0],QSPI_CS,QSPI_DQ0,QSPI_DQ1,PLL_CS,PLL_REFSEL,PLL_RESET,PLL_SCLK,PLL_SDO,PLL_SYNC,PLL_LOCK,PLL_SDI,PLL_STAT,GM_FMC_PPS_IN,GM_FMC_PPS_TERM_EN,GM_FMC_EXT_PLL_LOCK,GM_FMC_EXT_PLL_SDI,GM_FMC_EXT_PLL_RESET,GM_FMC_EXT_PLL_SYNC,GM_FMC_EXT_PLL_CS,GM_FMC_EXT_PLL_SCLK,GM_FMC_EXT_PLL_SDO,onewire_i,onewire_oen_o,sfp_scl_i[1:0],sfp_scl_o[1:0],sfp_sda_i[1:0],sfp_sda_o[1:0],sfp_det_i[1:0],clk_ext_i,clk_ext_mul_i,rst_62m5_n_o,clk_62m5_o,pps_csync_o,tm_time_valid_o,tm_tai_o[39:0],tm_cycles_o[27:0],\eb_cfg_master_o[cyc]\,\eb_cfg_master_o[stb]\,\eb_cfg_master_o[adr]\[31:0],\eb_cfg_master_o[sel]\[3:0],\eb_cfg_master_o[we]\,\eb_cfg_master_o[dat]\[31:0],\eb_cfg_master_i[ack]\,\eb_cfg_master_i[err]\,\eb_cfg_master_i[rty]\,\eb_cfg_master_i[stall]\,\eb_cfg_master_i[dat]\[31:0],\eb_wrf_src_o[1][adr]\[1:0],\eb_wrf_src_o[1][dat]\[15:0],\eb_wrf_src_o[1][cyc]\,\eb_wrf_src_o[1][stb]\,\eb_wrf_src_o[1][we]\,\eb_wrf_src_o[1][sel]\[1:0],\eb_wrf_src_o[0][adr]\[1:0],\eb_wrf_src_o[0][dat]\[15:0],\eb_wrf_src_o[0][cyc]\,\eb_wrf_src_o[0][stb]\,\eb_wrf_src_o[0][we]\,\eb_wrf_src_o[0][sel]\[1:0],\eb_wrf_src_i[1][ack]\,\eb_wrf_src_i[1][stall]\,\eb_wrf_src_i[1][err]\,\eb_wrf_src_i[1][rty]\,\eb_wrf_src_i[0][ack]\,\eb_wrf_src_i[0][stall]\,\eb_wrf_src_i[0][err]\,\eb_wrf_src_i[0][rty]\,\eb_wrf_snk_o[1][ack]\,\eb_wrf_snk_o[1][stall]\,\eb_wrf_snk_o[1][err]\,\eb_wrf_snk_o[1][rty]\,\eb_wrf_snk_o[0][ack]\,\eb_wrf_snk_o[0][stall]\,\eb_wrf_snk_o[0][err]\,\eb_wrf_snk_o[0][rty]\,\eb_wrf_snk_i[1][adr]\[1:0],\eb_wrf_snk_i[1][dat]\[15:0],\eb_wrf_snk_i[1][cyc]\,\eb_wrf_snk_i[1][stb]\,\eb_wrf_snk_i[1][we]\,\eb_wrf_snk_i[1][sel]\[1:0],\eb_wrf_snk_i[0][adr]\[1:0],\eb_wrf_snk_i[0][dat]\[15:0],\eb_wrf_snk_i[0][cyc]\,\eb_wrf_snk_i[0][stb]\,\eb_wrf_snk_i[0][we]\,\eb_wrf_snk_i[0][sel]\[1:0],LED_GREEN_O[1:0],LED_RED_O[1:0]";
begin
end;
