library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.ipbus.all;
use work.wishbone_pkg.all;
use work.wr_fabric_pkg.all;

library unisim;
use unisim.vcomponents.all;

entity cute_a7_ipbus is
generic(
  -- project name, NORMAL, SHINE
    g_project_name : string := "NORMAL";
    g_num_phys : integer := 2
);
port(
--    SFP_RATE_SELECT_O     : out   std_logic_vector(g_num_phys-1 downto 0);
    SFP_TX_DISABLE_O      : out   std_logic_vector(g_num_phys-1 downto 0);
    SFP_TX_O_N            : out   std_logic_vector(g_num_phys-1 downto 0);
    SFP_TX_O_P            : out   std_logic_vector(g_num_phys-1 downto 0);
    SFP_RX_I_N            : in    std_logic_vector(g_num_phys-1 downto 0);
    SFP_RX_I_P            : in    std_logic_vector(g_num_phys-1 downto 0);
    SFP_FAULT_I           : in    std_logic_vector(g_num_phys-1 downto 0);
    SFP_LOS_I             : in    std_logic_vector(g_num_phys-1 downto 0);

    UART_RX_I             : in    std_logic;
    UART_TX_O             : out   std_logic;
    RESET_N               : in    std_logic;
    LOCK                  : out   std_logic;

    PPS_O_P               : out   std_logic;
    PPS_O_N               : out   std_logic;
    SYNC_CLK_10M_O_P      : out   std_logic;
    SYNC_CLK_10M_O_N      : out   std_logic;

    VER0                  : in    std_logic;
    VER1                  : in    std_logic;
    VER2                  : in    std_logic;
    CLK_62M5_DMTD         : in    std_logic;
    FPGA_GCLK_P           : in    std_logic;
    FPGA_GCLK_N           : in    std_logic;
    MGTREFCLK1_P          : in    std_logic;
    MGTREFCLK1_N          : in    std_logic;
    OE_125M               : out   std_logic;
    MGTREFCLK0_P          : in    std_logic;
    MGTREFCLK0_N          : in    std_logic;
    DAC_LDAC_N            : out   std_logic;
    DAC_SCLK              : out   std_logic;
    DAC_SYNC_N            : out   std_logic;
    DAC_SDI               : out   std_logic;
    DAC_SDO               : in    std_logic;
    DAC_DMTD_LDAC_N       : out   std_logic;
    DAC_DMTD_SCLK         : out   std_logic;
    DAC_DMTD_SYNC_N       : out   std_logic;
    DAC_DMTD_SDI          : out   std_logic;
    DAC_DMTD_SDO          : in    std_logic;
    DELAY_EN              : out   std_logic_vector(0 downto 0);
    DELAY_SCLK            : out   std_logic_vector(0 downto 0);
    DELAY_SLOAD           : out   std_logic_vector(0 downto 0);
    DELAY_SDIN            : out   std_logic_vector(0 downto 0);
    -- DLY0_SE_FB            : in    std_logic;
    -- DLY1_SE_FB            : in    std_logic;
    QSPI_CS               : out   std_logic;
    QSPI_DQ0              : out   std_logic;
    QSPI_DQ1              : in    std_logic;
    --QSPI_DQ2              : in    std_logic
    --QSPI_DQ3              : in    std_logic
    ------------------------------------------
    -- AD9516 SPI
    ------------------------------------------
    PLL_CS                : out   std_logic;
    PLL_REFSEL            : out   std_logic;
    PLL_RESET             : out   std_logic;
    PLL_SCLK              : out   std_logic;
    PLL_SDO               : out   std_logic;
    PLL_SYNC              : out   std_logic;
    PLL_LOCK              : in    std_logic;
    PLL_SDI               : in    std_logic;
    PLL_STAT              : in    std_logic;

    ------------------------------------------
    -- GM
    ------------------------------------------
    -- TIMING
    -- GM_FMC_TOD_IN         : in     std_logic;
    -- GM_FMC_TOD_OUT        : out    std_logic;
    -- GM_FMC_TOD_TERM_EN    : out    std_logic;
    GM_FMC_PPS_IN         : in     std_logic;
    GM_FMC_PPS_TERM_EN    : out    std_logic;
    GM_FMC_EXT_CLK_IN_P   : in     std_logic;
    GM_FMC_EXT_CLK_IN_N   : in     std_logic;
    -- Another AD9516
    GM_FMC_EXT_PLL_OUT6_P : in     std_logic;
    GM_FMC_EXT_PLL_OUT6_N : in     std_logic;
    GM_FMC_EXT_PLL_LOCK   : in     std_logic;
    --GM_FMC_EXT_PLL_STAT   : in     std_logic;
    GM_FMC_EXT_PLL_SDO    : in     std_logic;
    GM_FMC_EXT_PLL_RESET  : out    std_logic;
    GM_FMC_EXT_PLL_SYNC   : out    std_logic;
    GM_FMC_EXT_PLL_CS     : out    std_logic;
    GM_FMC_EXT_PLL_SCLK   : out    std_logic;
    GM_FMC_EXT_PLL_SDI    : out    std_logic;
    GM_SYS_CLK_OUT_P      : out    std_logic;
    GM_SYS_CLK_OUT_N      : out    std_logic;

    -- 3-state-signals
    ONE_WIRE              : inout std_logic;
    SFP_MOD_DEF0_I        : in    std_logic_vector(1 downto 0);
    SFP_MOD_DEF1_IO       : inout std_logic_vector(1 downto 0);
    SFP_MOD_DEF2_IO       : inout std_logic_vector(1 downto 0);
    -- CLK_25M_BAK           : in    std_logic;
    -- DDS/AD9910
    --                               |-> SYNC_IN_P -> SYNC_OUT_P -> GM_FMC_GBTCLK0_M2C_P
    -- AD9516 OUT9 -> GBTCLK0_M2C_P -|
    --                               |-> DIFF_P -> SMA(PLL 125M OUT)
    -- SPI config interface
    -- GM_FMC_SDO            : in     std_logic;
    -- GM_FMC_SDIO           : out    std_logic;
    -- GM_FMC_SCLK           : out    std_logic;
    -- GM_FMC_CS             : out    std_logic;
    -- GM_FMC_IO_UPDATE      : out    std_logic;
    -- GM_FMC_DROVER         : in     std_logic;
    -- GM_FMC_DRCTL          : out    std_logic;
    -- GM_FMC_DRHOLD         : out    std_logic;
    -- GM_FMC_RAM_SWP_OVR    : in     std_logic;
    -- GM_FMC_PLL_LOCK       : in     std_logic;
    -- GM_FMC_SYNC_SMP_ERROR : in     std_logic;
    -- GM_FMC_SYNC_CLK       : in     std_logic;
    -- GM_FMC_IO_RESET       : out    std_logic;
    -- GM_FMC_F0             : out    std_logic;
    -- GM_FMC_F1             : out    std_logic;
    -- GM_FMC_PROFILE0       : out    std_logic;
    -- GM_FMC_PROFILE1       : out    std_logic;
    -- GM_FMC_PROFILE2       : out    std_logic;
    -- GM_FMC_OSK            : out    std_logic;
    -- GM_FMC_MASTER_RESET   : out    std_logic;
    -- GM_FMC_EXT_PWR_DWN    : out    std_logic;
    -- GM_FMC_LPF_FILTA      : out    std_logic;
    -- GM_FMC_LPF_FILTB      : out    std_logic;
    -- GM Debug
    -- GM_FMC_LED            : out    std_logic
    -- PG_C2M_FMC
    -- CLK1_M2C_N
    -- CLK1_M2C_P
    -- DP0_M2C_N
    -- DP0_M2C_P
    -- LA02_N
    -- LA02_P
    -- LA03_N
    -- LA03_P
    -- LA04_N
    -- LA04_P
    -- LA05_N
    -- LA05_P
    -- LA06_N
    -- LA06_P
    -- LA07_N
    -- LA07_P
    -- LA08_N
    -- LA08_P
    -- LA09_N
    -- LA09_P
    -- LA10_N
    -- LA10_P
    -- LA11_N
    -- LA11_P
    -- LA12_N
    -- LA12_P
    -- LA16_N
    -- LA16_P

    -- RESV_I                : in     std_logic;
    -- RESV_O                : out    std_logic;
    LED_GREEN_O           : out   std_logic_vector(1 downto 0);
    LED_RED_O             : out   std_logic_vector(1 downto 0)

);
end cute_a7_ipbus;

architecture rtl of cute_a7_ipbus is

    signal eb_cfg_master_out    : t_wishbone_master_out;
    signal eb_wrf_src_out       : t_wrf_source_out_array(2-1 downto 0);
    signal eb_wrf_snk_out       : t_wrf_sink_out_array(2-1 downto 0);
    signal eb_cfg_master_in     : t_wishbone_master_in:=c_DUMMY_WB_MASTER_IN;
    signal eb_wrf_src_in        : t_wrf_source_in_array(2-1 downto 0):=(others=>c_dummy_src_in);
    signal eb_wrf_snk_in        : t_wrf_sink_in_array(2-1 downto 0):=(others=>c_dummy_snk_in);

    signal rst_sys_n            : STD_LOGIC;
    signal clk_sys              : STD_LOGIC;
    signal pps_csync            : STD_LOGIC;
    signal tm_time_valid        : STD_LOGIC;
    signal tm_tai               : STD_LOGIC_VECTOR ( 39 downto 0 );
    signal tm_cycles            : STD_LOGIC_VECTOR ( 27 downto 0 );
    signal onewire_i            : std_logic;
    signal onewire_oen_o        : std_logic;
    signal clk_ext_i            : std_logic:='0';
    signal clk_ext_mul_i        : std_logic:='0';
    signal sfp_scl_i            : std_logic_vector(2-1 downto 0);
    signal sfp_scl_o            : std_logic_vector(2-1 downto 0);
    signal sfp_sda_i            : std_logic_vector(2-1 downto 0);
    signal sfp_sda_o            : std_logic_vector(2-1 downto 0);
    signal sfp_det_i            : std_logic_vector(2-1 downto 0);

    -- ipbus
    signal ipb_clk              : std_logic;
    signal ipb_rst              : std_logic;
    signal aux_clk              : std_logic;
    signal aux_rst              : std_logic;
    signal pkt                  : std_logic;
    signal ipb_in               : ipb_rbus;
    signal ipb_out              : ipb_wbus;
    signal userled              : std_logic;

begin

    u_cute_a7_core: entity work.cute_a7_core
    port map(
        VER0                     => VER0,
        VER1                     => VER1,
        VER2                     => VER2,
        CLK_62M5_DMTD            => CLK_62M5_DMTD,
        FPGA_GCLK_P              => FPGA_GCLK_P,
        FPGA_GCLK_N              => FPGA_GCLK_N,
        MGTREFCLK1_P             => MGTREFCLK1_P,
        MGTREFCLK1_N             => MGTREFCLK1_N,
        OE_125M                  => OE_125M,
        MGTREFCLK0_P             => MGTREFCLK0_P,
        MGTREFCLK0_N             => MGTREFCLK0_N,
        DAC_LDAC_N               => DAC_LDAC_N,
        DAC_SCLK                 => DAC_SCLK,
        DAC_SYNC_N               => DAC_SYNC_N,
        DAC_SDI                  => DAC_SDI,
        DAC_SDO                  => DAC_SDO,
        DAC_DMTD_LDAC_N          => DAC_DMTD_LDAC_N,
        DAC_DMTD_SCLK            => DAC_DMTD_SCLK,
        DAC_DMTD_SYNC_N          => DAC_DMTD_SYNC_N,
        DAC_DMTD_SDI             => DAC_DMTD_SDI,
        DAC_DMTD_SDO             => DAC_DMTD_SDO,
        SFP_TX_DISABLE_O         => SFP_TX_DISABLE_O,
        SFP_TX_O_N               => SFP_TX_O_N,
        SFP_TX_O_P               => SFP_TX_O_P,
        SFP_RX_I_N               => SFP_RX_I_N,
        SFP_RX_I_P               => SFP_RX_I_P,
        SFP_FAULT_I              => SFP_FAULT_I,
        SFP_LOS_I                => SFP_LOS_I,
        LED_GREEN_O              => LED_GREEN_O,
        LED_RED_O                => LED_RED_O,
        UART_RX_I                => UART_RX_I,
        UART_TX_O                => UART_TX_O,
        RESET_N                  => RESET_N,
        SYNC_CLK_10M_O_N         => SYNC_CLK_10M_O_N,
        SYNC_CLK_10M_O_P         => SYNC_CLK_10M_O_P,
        PPS_O_N                  => PPS_O_N,
        PPS_O_P                  => PPS_O_P,
        DELAY_EN                 => DELAY_EN,
        DELAY_SCLK               => DELAY_SCLK,
        DELAY_SLOAD              => DELAY_SLOAD,
        DELAY_SDIN               => DELAY_SDIN,
        QSPI_CS                  => QSPI_CS,
        QSPI_DQ0                 => QSPI_DQ0,
        QSPI_DQ1                 => QSPI_DQ1,
        PLL_CS                   => PLL_CS,
        PLL_REFSEL               => PLL_REFSEL,
        PLL_RESET                => PLL_RESET,
        PLL_SCLK                 => PLL_SCLK,
        PLL_SDO                  => PLL_SDO,
        PLL_SYNC                 => PLL_SYNC,
        PLL_LOCK                 => PLL_LOCK,
        PLL_SDI                  => PLL_SDI,
        PLL_STAT                 => PLL_STAT,
        GM_FMC_PPS_IN            => GM_FMC_PPS_IN,
        GM_FMC_PPS_TERM_EN       => GM_FMC_PPS_TERM_EN,
        -- GM_FMC_EXT_CLK_IN_P      => GM_FMC_EXT_CLK_IN_P,
        -- GM_FMC_EXT_CLK_IN_N      => GM_FMC_EXT_CLK_IN_N,
        -- GM_FMC_EXT_PLL_OUT6_P    => GM_FMC_EXT_PLL_OUT6_P,
        -- GM_FMC_EXT_PLL_OUT6_N    => GM_FMC_EXT_PLL_OUT6_N,
        GM_FMC_EXT_PLL_LOCK      => GM_FMC_EXT_PLL_LOCK,
        GM_FMC_EXT_PLL_SDI       => GM_FMC_EXT_PLL_SDO,
        GM_FMC_EXT_PLL_RESET     => GM_FMC_EXT_PLL_RESET,
        GM_FMC_EXT_PLL_SYNC      => GM_FMC_EXT_PLL_SYNC,
        GM_FMC_EXT_PLL_CS        => GM_FMC_EXT_PLL_CS,
        GM_FMC_EXT_PLL_SCLK      => GM_FMC_EXT_PLL_SCLK,
        GM_FMC_EXT_PLL_SDO       => GM_FMC_EXT_PLL_SDI,
        clk_ext_i                => clk_ext_i,
        clk_ext_mul_i            => clk_ext_mul_i,
        onewire_i                => onewire_i,
        onewire_oen_o            => onewire_oen_o,
        sfp_scl_i                => sfp_scl_i,
        sfp_scl_o                => sfp_scl_o,
        sfp_sda_i                => sfp_sda_i,
        sfp_sda_o                => sfp_sda_o,
        sfp_det_i                => sfp_det_i,
        rst_62m5_n_o             => rst_sys_n,
        clk_62m5_o               => clk_sys,
        pps_csync_o              => pps_csync,
        tm_time_valid_o          => tm_time_valid,
        tm_tai_o                 => tm_tai,
        tm_cycles_o              => tm_cycles,
        \eb_cfg_master_o[cyc]\   => eb_cfg_master_out.cyc,
        \eb_cfg_master_o[stb]\   => eb_cfg_master_out.stb,
        \eb_cfg_master_o[adr]\   => eb_cfg_master_out.adr,
        \eb_cfg_master_o[sel]\   => eb_cfg_master_out.sel,
        \eb_cfg_master_o[we]\    => eb_cfg_master_out.we,
        \eb_cfg_master_o[dat]\   => eb_cfg_master_out.dat,
        \eb_cfg_master_i[ack]\   => eb_cfg_master_in.ack,
        \eb_cfg_master_i[err]\   => eb_cfg_master_in.err,
        \eb_cfg_master_i[rty]\   => eb_cfg_master_in.rty,
        \eb_cfg_master_i[stall]\ => eb_cfg_master_in.stall,
        \eb_cfg_master_i[dat]\   => eb_cfg_master_in.dat,
        \eb_wrf_src_o[1][adr]\   => eb_wrf_src_out(1).adr,
        \eb_wrf_src_o[1][dat]\   => eb_wrf_src_out(1).dat,
        \eb_wrf_src_o[1][cyc]\   => eb_wrf_src_out(1).cyc,
        \eb_wrf_src_o[1][stb]\   => eb_wrf_src_out(1).stb,
        \eb_wrf_src_o[1][we]\    => eb_wrf_src_out(1).we,
        \eb_wrf_src_o[1][sel]\   => eb_wrf_src_out(1).sel,
        \eb_wrf_src_o[0][adr]\   => eb_wrf_src_out(0).adr,
        \eb_wrf_src_o[0][dat]\   => eb_wrf_src_out(0).dat,
        \eb_wrf_src_o[0][cyc]\   => eb_wrf_src_out(0).cyc,
        \eb_wrf_src_o[0][stb]\   => eb_wrf_src_out(0).stb,
        \eb_wrf_src_o[0][we]\    => eb_wrf_src_out(0).we,
        \eb_wrf_src_o[0][sel]\   => eb_wrf_src_out(0).sel,
        \eb_wrf_src_i[1][ack]\   => eb_wrf_src_in(1).ack,
        \eb_wrf_src_i[1][stall]\ => eb_wrf_src_in(1).stall,
        \eb_wrf_src_i[1][err]\   => eb_wrf_src_in(1).err,
        \eb_wrf_src_i[1][rty]\   => eb_wrf_src_in(1).rty,
        \eb_wrf_src_i[0][ack]\   => eb_wrf_src_in(0).ack,
        \eb_wrf_src_i[0][stall]\ => eb_wrf_src_in(0).stall,
        \eb_wrf_src_i[0][err]\   => eb_wrf_src_in(0).err,
        \eb_wrf_src_i[0][rty]\   => eb_wrf_src_in(0).rty,
        \eb_wrf_snk_o[1][ack]\   => eb_wrf_snk_out(1).ack,
        \eb_wrf_snk_o[1][stall]\ => eb_wrf_snk_out(1).stall,
        \eb_wrf_snk_o[1][err]\   => eb_wrf_snk_out(1).err,
        \eb_wrf_snk_o[1][rty]\   => eb_wrf_snk_out(1).rty,
        \eb_wrf_snk_o[0][ack]\   => eb_wrf_snk_out(0).ack,
        \eb_wrf_snk_o[0][stall]\ => eb_wrf_snk_out(0).stall,
        \eb_wrf_snk_o[0][err]\   => eb_wrf_snk_out(0).err,
        \eb_wrf_snk_o[0][rty]\   => eb_wrf_snk_out(0).rty,
        \eb_wrf_snk_i[1][adr]\   => eb_wrf_snk_in(1).adr,
        \eb_wrf_snk_i[1][dat]\   => eb_wrf_snk_in(1).dat,
        \eb_wrf_snk_i[1][cyc]\   => eb_wrf_snk_in(1).cyc,
        \eb_wrf_snk_i[1][stb]\   => eb_wrf_snk_in(1).stb,
        \eb_wrf_snk_i[1][we]\    => eb_wrf_snk_in(1).we,
        \eb_wrf_snk_i[1][sel]\   => eb_wrf_snk_in(1).sel,
        \eb_wrf_snk_i[0][adr]\   => eb_wrf_snk_in(0).adr,
        \eb_wrf_snk_i[0][dat]\   => eb_wrf_snk_in(0).dat,
        \eb_wrf_snk_i[0][cyc]\   => eb_wrf_snk_in(0).cyc,
        \eb_wrf_snk_i[0][stb]\   => eb_wrf_snk_in(0).stb,
        \eb_wrf_snk_i[0][we]\    => eb_wrf_snk_in(0).we,
        \eb_wrf_snk_i[0][sel]\   => eb_wrf_snk_in(0).sel
    );

    ipbus : entity work.xwrf_ipbus
    generic map (
        CLK_AUX_FREQ => 40.0,
        ADDRWIDTH    => 9
    )
    port map (
        clk_sys_i     => clk_sys,
        rst_sys_n_i   => rst_sys_n,
        cfg_slave_i   => eb_cfg_master_out,
        cfg_slave_o   => eb_cfg_master_in,
        wrf_snk_i     => eb_wrf_src_out(0),
        wrf_snk_o     => eb_wrf_src_in(0),
        wrf_src_i     => eb_wrf_snk_out(0),
        wrf_src_o     => eb_wrf_snk_in(0),
        ipb_clk_o     => ipb_clk, -- 31.25M
        ipb_rst_o     => ipb_rst,
        aux_clk_o     => aux_clk, -- 40M
        aux_rst_o     => aux_rst,
        pkt_o         => pkt,
        ipb_out       => ipb_out,
        ipb_in        => ipb_in
    );

    payload: entity work.payload
    port map(
        ipb_clk   => ipb_clk,
        ipb_rst   => ipb_rst,
        ipb_in    => ipb_out,
        ipb_out   => ipb_in,
        clk       => aux_clk,
        rst       => aux_rst,
        nuke      => open,
        soft_rst  => open,
        userled   => userled
    );

    gen_SFP_I2C: for i in 0 to g_num_phys-1 generate

        SFP_MOD_DEF1_IO(i) <= '0' when sfp_scl_o(i) = '0' else 'Z';
        SFP_MOD_DEF2_IO(i) <= '0' when sfp_sda_o(i) = '0' else 'Z';
        sfp_scl_i(i) <= SFP_MOD_DEF1_IO(i);
        sfp_sda_i(i) <= SFP_MOD_DEF2_IO(i);
        sfp_det_i(i) <= SFP_MOD_DEF0_I(i);

    end generate gen_SFP_I2C;

    ONE_WIRE <= '0' when onewire_oen_o = '1' else 'Z';
    onewire_i <= ONE_WIRE;

    -- EXT PLL(AD9516) for GM Mode
    cmp_clk_ext : IBUFGDS
    generic map (
        DIFF_TERM    => true,     -- Differential Termination
        IBUF_LOW_PWR => false,    -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
        IOSTANDARD   => "DEFAULT"
    )
    port map (
        O  => clk_ext_i,
        I  => GM_FMC_EXT_CLK_IN_P,
        IB => GM_FMC_EXT_CLK_IN_N
    );

    cmp_clk_ext_mul : IBUFGDS
    generic map (
        DIFF_TERM    => true,     -- Differential Termination
        IBUF_LOW_PWR => false,    -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
        IOSTANDARD   => "DEFAULT"
    )
    port map (
        O  => clk_ext_mul_i,
        I  => GM_FMC_EXT_PLL_OUT6_P,
        IB => GM_FMC_EXT_PLL_OUT6_N
    );

    LOCK <= tm_time_valid;

    SYS_CLK_OUT_OBUF : OBUFDS
    port map(
      O  => GM_SYS_CLK_OUT_P,
      OB => GM_SYS_CLK_OUT_N,
      I  => clk_sys);

end rtl;
