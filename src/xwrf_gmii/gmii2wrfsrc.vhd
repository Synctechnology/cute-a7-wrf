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

entity gmii2wrfsrc is
  port(
    rst_sys_n_i    : in  std_logic;
    clk_sys_i      : in  std_logic;
    gmii_src_o     : out t_wrf_source_out;
    gmii_src_i     : in  t_wrf_source_in;

    reset_125m_n_i : in  std_logic;
    clk_125m_i     : in  std_logic;
    gmii_rxd_i     : in  std_logic_vector(7 downto 0);
    gmii_rxdv_i    : in  std_logic;
    gmii_rx_er     : in  std_logic
  );
end gmii2wrfsrc;

architecture behavioral of gmii2wrfsrc is

type t_pre_state is(T_IDLE,T_ODD,T_EVEN,T_EVEN_END,T_END,T_DROP);
signal pre_state : t_pre_state;
type t_txfsm is (IDLE, GET_SIZE, STATUS ,PAYLOAD, EOF);
signal txfsm : t_txfsm;

signal drp_cnt  : unsigned(31 downto 0);
signal fwd_cnt  : unsigned(31 downto 0);
signal drp_cnt_inc : std_logic;
signal fwd_cnt_inc : std_logic;

signal sof_reg              : std_logic;
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

signal mac_rx_valid           : std_logic;
signal mac_rx_sof             : std_logic;
signal mac_rx_eof             : std_logic;
signal mac_rx_data            : std_logic_vector(7 downto 0);
signal gmii_rxd_vector        : std_logic_vector(63 downto 0);
signal gmii_rxd_user_valid    : std_logic;
signal gmii_rxd_user_valid_d1 : std_logic;
signal gmii_rxd_user_valid_d2 : std_logic;
signal gmii_rxd_user_valid_d3 : std_logic;

begin

mac_rx_eof <= (not gmii_rxdv_i) and gmii_rxd_user_valid;
p_rx : process(clk_125m_i)
begin
    if rising_edge(clk_125m_i) then
        if (reset_125m_n_i = '0') then
            gmii_rxd_vector        <= (OTHERS => '0');
            gmii_rxd_user_valid    <= '0';
            gmii_rxd_user_valid_d1 <= '0';
            gmii_rxd_user_valid_d2 <= '0';
            gmii_rxd_user_valid_d3 <= '0';
            mac_rx_data            <= (OTHERS => '0');
            mac_rx_valid           <= '0';
            mac_rx_sof             <= '0';
        else
            gmii_rxd_vector        <= gmii_rxd_vector(55 downto 0) & gmii_rxd_i;
            if gmii_rxd_vector = X"55555555555555D5" then 
                gmii_rxd_user_valid  <= '1';
            elsif gmii_rxdv_i= '0' then
                gmii_rxd_user_valid  <= '0';
            end if;
            gmii_rxd_user_valid_d1 <= gmii_rxd_user_valid;
            gmii_rxd_user_valid_d2 <= gmii_rxd_user_valid_d1;
            gmii_rxd_user_valid_d3 <= gmii_rxd_user_valid_d2;
            mac_rx_valid           <= gmii_rxd_user_valid_d3 and gmii_rxdv_i;  
            mac_rx_data            <= gmii_rxd_vector(31 downto 24);
            mac_rx_sof             <= gmii_rxd_user_valid_d3 and (not mac_rx_valid) and gmii_rxd_user_valid; 
        end if;
    end if;
end process;
  
---------------------------------------------------------------------------
----------------------------- FIFO Write Part -----------------------------
---------------------------------------------------------------------------
fsize_in <= std_logic_vector(fsize);

p_tx_data:process(clk_125m_i)
begin
    if rising_edge(clk_125m_i) then
        if reset_125m_n_i = '0' then
            pre_state   <= T_IDLE;
            fsize       <= (others=>'0');
            fsize_wr    <= '0';
            frame_wr    <= '0';
            frame_in    <= (others=>'0');
            sof_reg     <= '0';
            valid_reg   <= '0';
        else
            fsize_wr    <= '0';
            frame_wr    <= '0';
            drp_cnt_inc <= '0';
            sof_reg     <= '0';
            valid_reg   <= '0';
            case( pre_state ) is
                when T_IDLE=>
                    if((mac_rx_sof = '1' or sof_reg ='1') and sfifo_wr_full='0') then
                        if mac_rx_valid = '1' then
                            frame_in   <= frame_in(7 downto 0) & mac_rx_data;
                            if valid_reg = '1' then
                                fsize      <= fsize+2;
                                frame_wr   <= '1';
                                pre_state  <= T_EVEN;
                            else
                                pre_state  <= T_ODD;
                                fsize      <= fsize+1;
                            end if;
                        else
                            if valid_reg = '1' then
                                pre_state  <= T_ODD;
                                fsize      <= fsize+1;
                            else
                                pre_state  <= T_EVEN;
                            end if ;
                        end if;
                    elsif (mac_rx_sof = '1' or sof_reg ='1') then
                        drp_cnt_inc <= '1';
                        pre_state   <= T_DROP;
                    else
                        pre_state   <= T_IDLE;
                    end if;
                when T_EVEN =>
                    if mac_rx_valid ='1' then
                        frame_in     <= frame_in(7 downto 0) & mac_rx_data;
                        fsize        <= fsize+1;
                        pre_state    <= T_ODD;
                    end if;
                    if mac_rx_eof = '1' then
                        fsize_wr     <= '1';
                        pre_state    <= T_EVEN_END;
                    end if ;
                when T_ODD =>
                    if mac_rx_valid = '1' then
                        frame_in     <= frame_in(7 downto 0) & mac_rx_data;
                        frame_wr     <= '1';
                        fsize        <= fsize+1;
                        pre_state    <= T_EVEN;
                    end if ;
                    if mac_rx_eof = '1' then
                        fsize_wr     <= '1';
                        pre_state    <= T_END;
                    end if ;
                when T_EVEN_END =>
                    frame_wr         <= '1';
                    frame_in         <= frame_in(7 downto 0) & mac_rx_data;
                    fsize            <= (others=>'0');
                    sof_reg          <= mac_rx_sof;
                    valid_reg        <= mac_rx_valid;
                    pre_state        <= T_IDLE;
                when T_END =>
                    fsize            <= (others=>'0');
                    sof_reg          <= mac_rx_sof;
                    valid_reg        <= mac_rx_valid;
                    frame_in         <= frame_in(7 downto 0) & mac_rx_data;
                    pre_state        <= T_IDLE;
                when T_DROP =>
                    if mac_rx_eof = '1' then
                        pre_state   <= T_END;
                    end if ;
            end case ;
        end if;
    end if;
end process; -- p_tx_data

--------------------------------------------------------------------------
----------------------------- FIFO      Part -----------------------------
--------------------------------------------------------------------------
FRAME_FIFO : generic_async_fifo_dual_rst
generic map (
    g_data_width             => 16,
    g_size                   => 2048,
    g_with_rd_empty          => false,
    g_with_rd_almost_empty   => false,
    g_with_rd_count          => false,
    g_with_wr_almost_full    => true,
    g_almost_empty_threshold => 2,
    g_almost_full_threshold  => 1024
)
port map (
    rst_wr_n_i               => reset_125m_n_i,
    clk_wr_i                 => clk_125m_i,
    d_i                      => frame_in,
    we_i                     => frame_wr,
    wr_almost_full_o         => ffifo_almost_full,
    rst_rd_n_i               => rst_sys_n_i,
    clk_rd_i                 => clk_sys_i,
    q_o                      => frame_out,
    rd_i                     => frame_rd,
    rd_empty_o               => open
);

SIZE_FIFO: generic_async_fifo_dual_rst
generic map(
    g_data_width             => 16,
    g_size                   => 8,
    g_with_rd_empty          => true,
    g_with_wr_full           => true,
    g_almost_empty_threshold => 1,
    g_almost_full_threshold  => 7)
port map(
    rst_wr_n_i               => reset_125m_n_i,
    clk_wr_i                 => clk_125m_i,
    d_i                      => fsize_in,
    we_i                     => fsize_wr,
    wr_full_o                => sfifo_wr_full,
    rst_rd_n_i               => rst_sys_n_i,
    clk_rd_i                 => clk_sys_i,
    q_o                      => fsize_out,
    rd_i                     => fsize_rd,
    rd_empty_o               => sfifo_rd_empty
);

--------------------------------------------------------------------------
----------------------------- FIFO Read Part -----------------------------
--------------------------------------------------------------------------
TX_FSM_P:process(clk_sys_i)
begin
    if rising_edge(clk_sys_i) then
        if(rst_sys_n_i = '0') then
            txfsm             <= IDLE;
            txsize            <= (others=>'0');
            fsize_rd          <= '0';
            frame_rd          <= '0';
            fwd_cnt_inc       <= '0';
            src_fab.addr      <= (others=>'0');
        else
            fsize_rd          <= '0';
            frame_rd          <= '0';
            fwd_cnt_inc       <= '0';
            src_fab.sof       <= '0';
            src_fab.eof       <= '0';
            src_fab.dvalid    <= '0';
            case txfsm is
                when IDLE =>
                    txsize  <= (others=>'0');
                    src_fab.bytesel <= '0';
                    src_fab.addr    <= c_WRF_STATUS;

                    if(sfifo_rd_empty = '0' and src_dreq='1') then
                        fsize_rd      <= '1';
                        src_fab.sof   <= '1';
                        txfsm         <= GET_SIZE;
                    end if;
                when GET_SIZE =>
                    src_fab.dvalid  <= '1';
                    frame_rd        <= '1';
                    txfsm           <= STATUS;
                when STATUS =>
                    if(src_dreq='1') then
                        frame_rd      <= '1';
                        src_fab.addr  <= c_WRF_DATA;
                        txsize        <= unsigned(fsize_out) - 2;
                        src_fab.dvalid<= '1';
                        txfsm         <= PAYLOAD;
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

src_fab.has_rx_timestamp   <= '0';
src_fab.rx_timestamp_valid <= '0';
src_fab.error              <= '0';
src_fab.data               <= frame_out when (txfsm=PAYLOAD or txfsm=EOF) else
                              f_marshall_wrf_status(stored_status);

WRF_SRC: ep_rx_wb_master
generic map(
    g_ignore_ack   => false,
    g_cyc_on_stall => true)
port map(
    clk_sys_i      => clk_sys_i,
    rst_n_i        => rst_sys_n_i,
    snk_fab_i      => src_fab,
    snk_dreq_o     => src_dreq,
    src_wb_i       => gmii_src_i,
    src_wb_o       => gmii_src_o
);

end behavioral;
