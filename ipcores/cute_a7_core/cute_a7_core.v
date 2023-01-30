// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (lin64) Build 2258646 Thu Jun 14 20:02:38 MDT 2018
// Date        : Sat Nov 12 21:18:30 2022
// Host        : yeym-thu-dell running 64-bit Ubuntu 16.04.7 LTS
// Command     : write_verilog -mode synth_stub -force ../cute-a7-wrf/ipcores/cute_a7_core//cute_a7_core.v
// Design      : cute_a7_core
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcsg325-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module cute_a7_core(SFP_RATE_SELECT_O, SFP_TX_DISABLE_O, 
  SFP_TX_O_N, SFP_TX_O_P, SFP_RX_I_N, SFP_RX_I_P, SFP_FAULT_I, SFP_LOS_I, UART_RX_I, UART_TX_O, 
  RESET_N, PPS_O_P, PPS_O_N, SYNC_CLK_10M_O_P, SYNC_CLK_10M_O_N, VER0, VER1, VER2, CLK_62M5_DMTD, 
  FPGA_GCLK_P, FPGA_GCLK_N, MGTREFCLK1_P, MGTREFCLK1_N, OE_125M, MGTREFCLK0_P, MGTREFCLK0_N, 
  DAC_LDAC_N, DAC_SCLK, DAC_SYNC_N, DAC_SDI, DAC_SDO, DAC_DMTD_LDAC_N, DAC_DMTD_SCLK, 
  DAC_DMTD_SYNC_N, DAC_DMTD_SDI, DAC_DMTD_SDO, DELAY_EN, DELAY_SCLK, DELAY_SLOAD, DELAY_SDIN, 
  QSPI_CS, QSPI_DQ0, QSPI_DQ1, PLL_CS, PLL_REFSEL, PLL_RESET, PLL_SCLK, PLL_SDO, PLL_SYNC, PLL_LOCK, 
  PLL_SDI, PLL_STAT, GM_FMC_PPS_IN, GM_FMC_PPS_TERM_EN, GM_FMC_EXT_PLL_LOCK, 
  GM_FMC_EXT_PLL_SDI, GM_FMC_EXT_PLL_RESET, GM_FMC_EXT_PLL_SYNC, GM_FMC_EXT_PLL_CS, 
  GM_FMC_EXT_PLL_SCLK, GM_FMC_EXT_PLL_SDO, onewire_i, onewire_oen_o, sfp_scl_i, sfp_scl_o, 
  sfp_sda_i, sfp_sda_o, sfp_det_i, clk_ext_i, clk_ext_mul_i, rst_62m5_n_o, clk_62m5_o, 
  pps_csync_o, tm_time_valid_o, tm_tai_o, tm_cycles_o, \eb_cfg_master_o[cyc] , 
  \eb_cfg_master_o[stb] , \eb_cfg_master_o[adr] , \eb_cfg_master_o[sel] , 
  \eb_cfg_master_o[we] , \eb_cfg_master_o[dat] , \eb_cfg_master_i[ack] , 
  \eb_cfg_master_i[err] , \eb_cfg_master_i[rty] , \eb_cfg_master_i[stall] , 
  \eb_cfg_master_i[dat] , \eb_wrf_src_o[1][adr] , \eb_wrf_src_o[1][dat] , 
  \eb_wrf_src_o[1][cyc] , \eb_wrf_src_o[1][stb] , \eb_wrf_src_o[1][we] , 
  \eb_wrf_src_o[1][sel] , \eb_wrf_src_o[0][adr] , \eb_wrf_src_o[0][dat] , 
  \eb_wrf_src_o[0][cyc] , \eb_wrf_src_o[0][stb] , \eb_wrf_src_o[0][we] , 
  \eb_wrf_src_o[0][sel] , \eb_wrf_src_i[1][ack] , \eb_wrf_src_i[1][stall] , 
  \eb_wrf_src_i[1][err] , \eb_wrf_src_i[1][rty] , \eb_wrf_src_i[0][ack] , 
  \eb_wrf_src_i[0][stall] , \eb_wrf_src_i[0][err] , \eb_wrf_src_i[0][rty] , 
  \eb_wrf_snk_o[1][ack] , \eb_wrf_snk_o[1][stall] , \eb_wrf_snk_o[1][err] , 
  \eb_wrf_snk_o[1][rty] , \eb_wrf_snk_o[0][ack] , \eb_wrf_snk_o[0][stall] , 
  \eb_wrf_snk_o[0][err] , \eb_wrf_snk_o[0][rty] , \eb_wrf_snk_i[1][adr] , 
  \eb_wrf_snk_i[1][dat] , \eb_wrf_snk_i[1][cyc] , \eb_wrf_snk_i[1][stb] , 
  \eb_wrf_snk_i[1][we] , \eb_wrf_snk_i[1][sel] , \eb_wrf_snk_i[0][adr] , 
  \eb_wrf_snk_i[0][dat] , \eb_wrf_snk_i[0][cyc] , \eb_wrf_snk_i[0][stb] , 
  \eb_wrf_snk_i[0][we] , \eb_wrf_snk_i[0][sel] , LED_GREEN_O, LED_RED_O)
/* synthesis syn_black_box black_box_pad_pin="SFP_RATE_SELECT_O[1:0],SFP_TX_DISABLE_O[1:0],SFP_TX_O_N[1:0],SFP_TX_O_P[1:0],SFP_RX_I_N[1:0],SFP_RX_I_P[1:0],SFP_FAULT_I[1:0],SFP_LOS_I[1:0],UART_RX_I,UART_TX_O,RESET_N,PPS_O_P,PPS_O_N,SYNC_CLK_10M_O_P,SYNC_CLK_10M_O_N,VER0,VER1,VER2,CLK_62M5_DMTD,FPGA_GCLK_P,FPGA_GCLK_N,MGTREFCLK1_P,MGTREFCLK1_N,OE_125M,MGTREFCLK0_P,MGTREFCLK0_N,DAC_LDAC_N,DAC_SCLK,DAC_SYNC_N,DAC_SDI,DAC_SDO,DAC_DMTD_LDAC_N,DAC_DMTD_SCLK,DAC_DMTD_SYNC_N,DAC_DMTD_SDI,DAC_DMTD_SDO,DELAY_EN[0:0],DELAY_SCLK[0:0],DELAY_SLOAD[0:0],DELAY_SDIN[0:0],QSPI_CS,QSPI_DQ0,QSPI_DQ1,PLL_CS,PLL_REFSEL,PLL_RESET,PLL_SCLK,PLL_SDO,PLL_SYNC,PLL_LOCK,PLL_SDI,PLL_STAT,GM_FMC_PPS_IN,GM_FMC_PPS_TERM_EN,GM_FMC_EXT_PLL_LOCK,GM_FMC_EXT_PLL_SDI,GM_FMC_EXT_PLL_RESET,GM_FMC_EXT_PLL_SYNC,GM_FMC_EXT_PLL_CS,GM_FMC_EXT_PLL_SCLK,GM_FMC_EXT_PLL_SDO,onewire_i,onewire_oen_o,sfp_scl_i[1:0],sfp_scl_o[1:0],sfp_sda_i[1:0],sfp_sda_o[1:0],sfp_det_i[1:0],clk_ext_i,clk_ext_mul_i,rst_62m5_n_o,clk_62m5_o,pps_csync_o,tm_time_valid_o,tm_tai_o[39:0],tm_cycles_o[27:0],\eb_cfg_master_o[cyc] ,\eb_cfg_master_o[stb] ,\eb_cfg_master_o[adr] [31:0],\eb_cfg_master_o[sel] [3:0],\eb_cfg_master_o[we] ,\eb_cfg_master_o[dat] [31:0],\eb_cfg_master_i[ack] ,\eb_cfg_master_i[err] ,\eb_cfg_master_i[rty] ,\eb_cfg_master_i[stall] ,\eb_cfg_master_i[dat] [31:0],\eb_wrf_src_o[1][adr] [1:0],\eb_wrf_src_o[1][dat] [15:0],\eb_wrf_src_o[1][cyc] ,\eb_wrf_src_o[1][stb] ,\eb_wrf_src_o[1][we] ,\eb_wrf_src_o[1][sel] [1:0],\eb_wrf_src_o[0][adr] [1:0],\eb_wrf_src_o[0][dat] [15:0],\eb_wrf_src_o[0][cyc] ,\eb_wrf_src_o[0][stb] ,\eb_wrf_src_o[0][we] ,\eb_wrf_src_o[0][sel] [1:0],\eb_wrf_src_i[1][ack] ,\eb_wrf_src_i[1][stall] ,\eb_wrf_src_i[1][err] ,\eb_wrf_src_i[1][rty] ,\eb_wrf_src_i[0][ack] ,\eb_wrf_src_i[0][stall] ,\eb_wrf_src_i[0][err] ,\eb_wrf_src_i[0][rty] ,\eb_wrf_snk_o[1][ack] ,\eb_wrf_snk_o[1][stall] ,\eb_wrf_snk_o[1][err] ,\eb_wrf_snk_o[1][rty] ,\eb_wrf_snk_o[0][ack] ,\eb_wrf_snk_o[0][stall] ,\eb_wrf_snk_o[0][err] ,\eb_wrf_snk_o[0][rty] ,\eb_wrf_snk_i[1][adr] [1:0],\eb_wrf_snk_i[1][dat] [15:0],\eb_wrf_snk_i[1][cyc] ,\eb_wrf_snk_i[1][stb] ,\eb_wrf_snk_i[1][we] ,\eb_wrf_snk_i[1][sel] [1:0],\eb_wrf_snk_i[0][adr] [1:0],\eb_wrf_snk_i[0][dat] [15:0],\eb_wrf_snk_i[0][cyc] ,\eb_wrf_snk_i[0][stb] ,\eb_wrf_snk_i[0][we] ,\eb_wrf_snk_i[0][sel] [1:0],LED_GREEN_O[1:0],LED_RED_O[1:0]" */;
  output [1:0]SFP_RATE_SELECT_O;
  output [1:0]SFP_TX_DISABLE_O;
  output [1:0]SFP_TX_O_N;
  output [1:0]SFP_TX_O_P;
  input [1:0]SFP_RX_I_N;
  input [1:0]SFP_RX_I_P;
  input [1:0]SFP_FAULT_I;
  input [1:0]SFP_LOS_I;
  input UART_RX_I;
  output UART_TX_O;
  input RESET_N;
  output PPS_O_P;
  output PPS_O_N;
  output SYNC_CLK_10M_O_P;
  output SYNC_CLK_10M_O_N;
  input VER0;
  input VER1;
  input VER2;
  input CLK_62M5_DMTD;
  input FPGA_GCLK_P;
  input FPGA_GCLK_N;
  input MGTREFCLK1_P;
  input MGTREFCLK1_N;
  output OE_125M;
  input MGTREFCLK0_P;
  input MGTREFCLK0_N;
  output DAC_LDAC_N;
  output DAC_SCLK;
  output DAC_SYNC_N;
  output DAC_SDI;
  input DAC_SDO;
  output DAC_DMTD_LDAC_N;
  output DAC_DMTD_SCLK;
  output DAC_DMTD_SYNC_N;
  output DAC_DMTD_SDI;
  input DAC_DMTD_SDO;
  output [0:0]DELAY_EN;
  output [0:0]DELAY_SCLK;
  output [0:0]DELAY_SLOAD;
  output [0:0]DELAY_SDIN;
  output QSPI_CS;
  output QSPI_DQ0;
  input QSPI_DQ1;
  output PLL_CS;
  output PLL_REFSEL;
  output PLL_RESET;
  output PLL_SCLK;
  output PLL_SDO;
  output PLL_SYNC;
  input PLL_LOCK;
  input PLL_SDI;
  input PLL_STAT;
  input GM_FMC_PPS_IN;
  output GM_FMC_PPS_TERM_EN;
  input GM_FMC_EXT_PLL_LOCK;
  input GM_FMC_EXT_PLL_SDI;
  output GM_FMC_EXT_PLL_RESET;
  output GM_FMC_EXT_PLL_SYNC;
  output GM_FMC_EXT_PLL_CS;
  output GM_FMC_EXT_PLL_SCLK;
  output GM_FMC_EXT_PLL_SDO;
  input onewire_i;
  output onewire_oen_o;
  input [1:0]sfp_scl_i;
  output [1:0]sfp_scl_o;
  input [1:0]sfp_sda_i;
  output [1:0]sfp_sda_o;
  input [1:0]sfp_det_i;
  input clk_ext_i;
  input clk_ext_mul_i;
  output rst_62m5_n_o;
  output clk_62m5_o;
  output pps_csync_o;
  output tm_time_valid_o;
  output [39:0]tm_tai_o;
  output [27:0]tm_cycles_o;
  output \eb_cfg_master_o[cyc] ;
  output \eb_cfg_master_o[stb] ;
  output [31:0]\eb_cfg_master_o[adr] ;
  output [3:0]\eb_cfg_master_o[sel] ;
  output \eb_cfg_master_o[we] ;
  output [31:0]\eb_cfg_master_o[dat] ;
  input \eb_cfg_master_i[ack] ;
  input \eb_cfg_master_i[err] ;
  input \eb_cfg_master_i[rty] ;
  input \eb_cfg_master_i[stall] ;
  input [31:0]\eb_cfg_master_i[dat] ;
  output [1:0]\eb_wrf_src_o[1][adr] ;
  output [15:0]\eb_wrf_src_o[1][dat] ;
  output \eb_wrf_src_o[1][cyc] ;
  output \eb_wrf_src_o[1][stb] ;
  output \eb_wrf_src_o[1][we] ;
  output [1:0]\eb_wrf_src_o[1][sel] ;
  output [1:0]\eb_wrf_src_o[0][adr] ;
  output [15:0]\eb_wrf_src_o[0][dat] ;
  output \eb_wrf_src_o[0][cyc] ;
  output \eb_wrf_src_o[0][stb] ;
  output \eb_wrf_src_o[0][we] ;
  output [1:0]\eb_wrf_src_o[0][sel] ;
  input \eb_wrf_src_i[1][ack] ;
  input \eb_wrf_src_i[1][stall] ;
  input \eb_wrf_src_i[1][err] ;
  input \eb_wrf_src_i[1][rty] ;
  input \eb_wrf_src_i[0][ack] ;
  input \eb_wrf_src_i[0][stall] ;
  input \eb_wrf_src_i[0][err] ;
  input \eb_wrf_src_i[0][rty] ;
  output \eb_wrf_snk_o[1][ack] ;
  output \eb_wrf_snk_o[1][stall] ;
  output \eb_wrf_snk_o[1][err] ;
  output \eb_wrf_snk_o[1][rty] ;
  output \eb_wrf_snk_o[0][ack] ;
  output \eb_wrf_snk_o[0][stall] ;
  output \eb_wrf_snk_o[0][err] ;
  output \eb_wrf_snk_o[0][rty] ;
  input [1:0]\eb_wrf_snk_i[1][adr] ;
  input [15:0]\eb_wrf_snk_i[1][dat] ;
  input \eb_wrf_snk_i[1][cyc] ;
  input \eb_wrf_snk_i[1][stb] ;
  input \eb_wrf_snk_i[1][we] ;
  input [1:0]\eb_wrf_snk_i[1][sel] ;
  input [1:0]\eb_wrf_snk_i[0][adr] ;
  input [15:0]\eb_wrf_snk_i[0][dat] ;
  input \eb_wrf_snk_i[0][cyc] ;
  input \eb_wrf_snk_i[0][stb] ;
  input \eb_wrf_snk_i[0][we] ;
  input [1:0]\eb_wrf_snk_i[0][sel] ;
  output [1:0]LED_GREEN_O;
  output [1:0]LED_RED_O;
endmodule
