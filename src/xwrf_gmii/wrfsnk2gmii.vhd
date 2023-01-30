library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

library work;
use work.gencores_pkg.all;
use work.genram_pkg.all;
use work.endpoint_pkg.all;
use work.wr_fabric_pkg.all;
use work.ep_crc32_pkg.all;

entity wrfsnk2gmii is
port (
    clk_sys_i      : in  std_logic;
    rst_sys_n_i    : in  std_logic;
    gmii_snk_i     : in  t_wrf_sink_in;
    gmii_snk_o     : out t_wrf_sink_out;

    clk_125m_i     : in  std_logic;
    reset_125m_n_i : in  std_logic;
    gmii_txdata_o  : out std_logic_vector(7 downto 0);
    gmii_txen_o    : out std_logic;
    gmii_tx_er_o   : out std_logic
);
end entity;

architecture rtl of wrfsnk2gmii is

    constant C_FIFO_WIDTH        : integer := 16 + 2;

    signal fifo_wr_almost_full   : std_logic;
    signal fifo_wrreq            : std_logic;
    signal fifo_rdreq            : std_logic;
    signal fifo_rdvalid          : std_logic;
    signal fifo_rdempty          : std_logic;
    signal fifo_wrdata           : std_logic_vector(c_fifo_width-1 downto 0);
    signal fifo_rddata           : std_logic_vector(c_fifo_width-1 downto 0);
    signal dvalid                : std_logic;
    
    signal pre_data              : std_logic_vector(15 downto 0);
    signal pre_ctrl              : std_logic_vector(1 downto 0);

    signal snk_out               : t_wrf_sink_out;

    signal txcnt                 : std_logic_vector(11 downto 0);
    signal mfifo_wedata          : std_logic_vector(15 downto 0);
    signal mfifo_write           : std_logic_vector(1 downto 0);
    signal mfifo_rd              : std_logic;
    signal mfifo_rddata          : std_logic_vector(7 downto 0);
    signal crc_in_data           : std_logic_vector(7 downto 0);
    signal mfifo_rdempty         : std_logic;
    signal length                : std_logic_vector(11 downto 0);
    signal sfifo_empty           : std_logic;
    signal sfifo_we              : std_logic;
    signal sfifo_rd              : std_logic;
    signal sfifo_wedata          : std_logic_vector(11 downto 0);
    signal sfifo_rddata          : std_logic_vector(11 downto 0);
    signal gmii_length           : std_logic_vector(11 downto 0);
    signal crc_reset             : std_logic; 
    signal crc_calc              : std_logic; 
    signal crc_datain            : std_logic_vector(7 downto 0);
    signal gmii_txdata           : std_logic_vector(7 downto 0);
    signal gmii_txen             : std_logic;
    signal crc_value             : std_logic_vector(31 downto 0);
    
    type t_state is(T_IDLE,T_START,T_DATA);
    signal state : t_state;
    
    type t_gmii_state is (IDLE,PREAMBLE,TXDATA,TXPAD,TXFCS,FRAMEWAIT);
    signal gmii_state: t_gmii_state;

    function f_b2s (x : boolean)
        return std_logic is
    begin
        if(x) then
            return '1';
        else
            return '0';
        end if;
    end function;

begin

    snk_out.stall <= fifo_wr_almost_full;
    snk_out.err   <= '0';
    snk_out.rty   <= '0';

    p_gen_ack : process(clk_sys_i)
    begin
        if rising_edge(clk_sys_i) then
            if rst_sys_n_i = '0' then
                snk_out.ack <= '0';
            else
                snk_out.ack <= gmii_snk_i.cyc and gmii_snk_i.stb and gmii_snk_i.we and not snk_out.stall;
            end if;
        end if;
    end process p_gen_ack;

    dvalid <= f_b2s(gmii_snk_i.adr=C_WRF_DATA) and gmii_snk_i.cyc and gmii_snk_i.stb;

    p_snk_fsm: process (clk_sys_i)
    begin
        if rising_edge(clk_sys_i) then
            if rst_sys_n_i = '0' then
                pre_ctrl   <= (others=>'0');
                pre_data   <= (others=>'0');
                fifo_wrreq <= '0';
                state      <= T_IDLE;
            else
                case( state ) is
                    when T_IDLE =>
                        if gmii_snk_i.cyc = '1' then
                            if(dvalid = '1') then
                                pre_data   <= gmii_snk_i.dat;
                                pre_ctrl   <= "01"; -- start
                                fifo_wrreq <= '1';
                                state      <= T_DATA;
                            else
                                fifo_wrreq <= '0';
                                pre_ctrl   <= (others=>'0');
                                pre_data   <= (others=>'0');
                                state      <= T_START;
                            end if;
                        else
                            fifo_wrreq     <= '0';
                            pre_ctrl       <= (others=>'0');
                            pre_data       <= (others=>'0');
                            state          <= T_IDLE;
                        end if ;
                    when T_START =>
                        if gmii_snk_i.cyc = '1' then
                            if(dvalid = '1') then
                                pre_data   <= gmii_snk_i.dat;
                                pre_ctrl   <= "01"; -- start
                                fifo_wrreq <= '1';
                                state      <= T_DATA;
                            else
                                pre_ctrl   <= (others=>'0');
                                pre_data   <= (others=>'0');
                                fifo_wrreq <= '0';
                                state      <= T_IDLE;
                            end if;
                        else
                            pre_ctrl   <= (others=>'0'); -- end without data
                            pre_data   <= (others=>'0');
                            fifo_wrreq <= '1';
                            state      <= T_IDLE;
                        end if;
                    when T_DATA =>
                        if gmii_snk_i.cyc = '1' then
                            if (dvalid = '1') then
                                pre_data   <= gmii_snk_i.dat;
                                pre_ctrl   <= gmii_snk_i.sel;
                                fifo_wrreq <= '1';
                            else
                                pre_ctrl   <= (others=>'0');
                                pre_data   <= (others=>'0');
                                fifo_wrreq <= '0';
                            end if;
                            state      <= T_DATA;
                        else
                            pre_ctrl   <= (others=>'0'); -- end without data
                            pre_data   <= (others=>'0');
                            fifo_wrreq <= '1';
                            state      <= T_IDLE;
                        end if;
                    when others =>
                        pre_ctrl   <= (others=>'0');
                        pre_data   <= (others=>'0');
                        fifo_wrreq <= '0';
                        state      <= T_IDLE;
                end case;
            end if;
        end if;
    end process p_snk_fsm;

    -- pre_ctrl = 01 start two bytes data
    -- pre_ctrl = 11 end two bytes data
    -- pre_ctrl = 10 end one bytes data
    -- pre_ctrl = 11 normal two bytes data
    -- pre_ctrl = 00 end without data
    fifo_wrdata <= pre_ctrl & pre_data;
    U_rx_fifo : generic_async_fifo_dual_rst
    generic map (
        g_data_width             => c_fifo_width,
        g_size                   => 1024,
        g_with_rd_empty          => true,
        g_with_rd_almost_empty   => false,
        g_with_rd_count          => false,
        g_with_wr_almost_full    => true,
        g_almost_empty_threshold => 4,
        g_almost_full_threshold  => 1020
    )
    port map (
        rst_wr_n_i        => rst_sys_n_i,
        clk_wr_i          => clk_sys_i,
        d_i               => fifo_wrdata,
        we_i              => fifo_wrreq,
        wr_empty_o        => open,
        wr_full_o         => open,
        wr_almost_empty_o => open,
        wr_almost_full_o  => fifo_wr_almost_full,
        wr_count_o        => open,

        rst_rd_n_i        => reset_125m_n_i,
        clk_rd_i          => clk_125m_i,
        q_o               => fifo_rddata,
        rd_i              => fifo_rdreq,
        rd_empty_o        => fifo_rdempty,
        rd_full_o         => open,
        rd_almost_empty_o => open,
        rd_almost_full_o  => open,
        rd_count_o        => open
    );
    
    p_gen_fifo_valid : process(clk_125m_i)
    begin
        if rising_edge(clk_125m_i) then
            if(reset_125m_n_i = '0') then
                fifo_rdvalid <= '0';
                fifo_rdreq   <= '0';
            else
                fifo_rdvalid <= fifo_rdreq;
                if(fifo_rdempty = '0') then
                    if(fifo_rdreq = '0') then
                        fifo_rdreq <= '1';
                    else
                        fifo_rdreq <= '0';
                    end if;
                else
                    fifo_rdreq <= '0';
                end if;
            end if;
        end if;
    end process;
    
    p_rd_fsm:process(clk_125m_i)
    begin
    if rising_edge(clk_125m_i) then
        if reset_125m_n_i = '0' then
            mfifo_wedata  <= (others=>'0');
            mfifo_write   <= "00";
        else
            mfifo_write   <= mfifo_write(0 downto 0) & '0';
            mfifo_wedata  <= mfifo_wedata(7 downto 0) & x"00";
            if(fifo_rdvalid = '1') then
                case( fifo_rddata(17 downto 16) ) is
                    when "00" =>
                        mfifo_write   <= "00";
                        mfifo_wedata  <= (others=>'0');
                    when "01" =>
                        mfifo_write   <= "11";
                        mfifo_wedata  <= fifo_rddata(15 downto 0);
                    when "10" =>
                        mfifo_write   <= "10";
                        mfifo_wedata  <= fifo_rddata(15 downto 0);
                    when "11" =>
                        mfifo_write   <= "11";
                        mfifo_wedata  <= fifo_rddata(15 downto 0);
                    when others =>
                        mfifo_write   <= "00";
                        mfifo_wedata  <= (others=>'0');
                end case ;
            end if;
        end if;
    end if;
    end process p_rd_fsm;

    process(clk_125m_i)
    begin
        if rising_edge(clk_125m_i) then
            if reset_125m_n_i = '0' then
                length          <= (others=>'0');
                sfifo_wedata    <= (others=>'0');
                sfifo_we        <= '0';
            elsif(fifo_rdvalid = '1') then
                case( fifo_rddata(17 downto 16) ) is
                    when "01" =>
                        length         <= length + 2;
                        sfifo_we       <= '0';
                    when "10" =>
                        length         <= length + 1;
                        sfifo_we       <= '0';
                    when "11" =>
                        length         <= length + 2;
                        sfifo_we       <= '0';
                    when "00" =>
                        sfifo_wedata   <= length;
                        sfifo_we       <= '1';
                        length         <= (others=>'0');
                    when others =>
                        sfifo_wedata   <= (others=>'0');
                        sfifo_we       <= '0';
                        length         <= (others=>'0');
                end case;
            else
                sfifo_we     <= '0';
            end if;
        end if;
    end process;

    I_data_fifo : generic_sync_fifo
    generic map(
        g_data_width             => 8,
        g_size                   => 2048,
        g_show_ahead             => true,
        g_with_empty             => false,
        g_with_full              => false,
        g_with_almost_full       => false)
    port map (
        clk_i   => clk_125m_i,
        rst_n_i => reset_125m_n_i,
        full_o  => open,
        we_i    => mfifo_write(1),
        d_i     => mfifo_wedata(15 downto 8),
        empty_o => open,
        rd_i    => mfifo_rd,
        q_o     => mfifo_rddata,
        count_o => open
    );

    I_size_fifo : generic_sync_fifo
    generic map(
        g_data_width             => 12,
        g_size                   => 8,
        g_show_ahead             => true,
        g_with_empty             => true,
        g_with_full              => false,
        g_with_almost_full       => false)
    port map (
        clk_i   => clk_125m_i,
        rst_n_i => reset_125m_n_i,
        full_o  => open,
        we_i    => sfifo_we,
        d_i     => sfifo_wedata,
        empty_o => sfifo_empty,
        rd_i    => sfifo_rd,
        q_o     => sfifo_rddata,
        count_o => open
    );
    
    p_gmii_state : process(clk_125m_i)
    begin
        if rising_edge(clk_125m_i) then
            if reset_125m_n_i = '0' then
                gmii_state  <= IDLE;
                txcnt       <= (others => '0');
                mfifo_rd    <= '0';
                gmii_txdata <= (others => '0');
                gmii_txen   <= '0';
                gmii_length <= (others => '0');
                sfifo_rd    <= '0';
            else
                case gmii_state is
                    when IDLE => 
                        txcnt       <= (others => '0');
                        gmii_txdata <= (others => '0');
                        gmii_txen   <= '0';
                        gmii_state  <= IDLE;
                        mfifo_rd    <= '0';
                        sfifo_rd    <= '0';
                        gmii_length <= (others=>'0');
                        if sfifo_empty = '0' then
                            txcnt       <= x"007"; -- 7bytes preamble code + 1byte SFD
                            sfifo_rd    <= '1';
                            gmii_length <= sfifo_rddata;
                            gmii_state  <= PREAMBLE;
                        end if;
                    when PREAMBLE =>
                        gmii_txen <= '1';
                        mfifo_rd  <= '0';
                        sfifo_rd  <= '0';
                        case( txcnt ) is
                            when x"000" =>
                                txcnt       <= gmii_length-1;
                                gmii_state  <= TXDATA;
                                gmii_txdata <= X"D5"; -- SFD
                                mfifo_rd    <= not mfifo_rdempty;
                            when others =>
                                txcnt       <= txcnt - '1';
                                gmii_state  <= PREAMBLE;
                                gmii_txdata <= X"55"; -- preamble code
                                mfifo_rd    <= '0';
                        end case ;
                    when TXDATA => 
                        gmii_txen   <= '1';
                        gmii_txdata <= mfifo_rddata;
                        sfifo_rd    <= '0';
                        case( txcnt ) is
                            when x"000" =>
                                mfifo_rd            <= '0';
                                if (gmii_length < X"03C") then
                                    gmii_state      <= TXPAD;
                                    txcnt           <= X"03B" - gmii_length;
                                else
                                    gmii_state      <= TXFCS;
                                    txcnt           <= X"003";
                                end if;
                            when others =>
                                gmii_state          <= TXDATA;
                                txcnt               <= txcnt - '1';
                                mfifo_rd            <= not mfifo_rdempty;
                        end case ;
                    when TXPAD =>
                        gmii_txen                   <= '1';
                        gmii_txdata                 <= X"00";
                        mfifo_rd                    <= '0';
                        sfifo_rd                    <= '0';
                        if txcnt = X"000" then 
                            gmii_state              <= TXFCS;    
                            txcnt                   <= X"003";
                        else  	        
                            gmii_state              <= TXPAD;
                            txcnt                   <= txcnt - '1';
                        end if;
                    when TXFCS => 
                        gmii_txen                   <= '1';
                        mfifo_rd                    <= '0';
                        sfifo_rd                    <= '0';
                        case( txcnt ) is
                            when x"003" =>
                                gmii_txdata         <= crc_value(31 downto 24);
                                gmii_state          <= TXFCS;
                                txcnt               <= txcnt - '1';
                            when x"002" =>
                                gmii_txdata         <= crc_value(23 downto 16);
                                gmii_state          <= TXFCS;
                                txcnt               <= txcnt - '1';
                            when x"001" =>
                                gmii_txdata         <= crc_value(15 downto 8);
                                gmii_state          <= TXFCS;
                                txcnt               <= txcnt - '1';
                            when x"000" =>
                                gmii_txdata         <= crc_value(7 downto 0);
                                gmii_state          <= FRAMEWAIT;
                                txcnt               <= X"00F";
                            when others =>
                        end case ;
                    when FRAMEWAIT => 
                        gmii_txen                   <= '0';
                        gmii_txdata                 <= (others=>'0');
                        mfifo_rd                    <= '0';
                        sfifo_rd                    <= '0';
                        if txcnt = X"000" then 
                            gmii_state <= IDLE;
                        else  	        
                            txcnt      <= txcnt - '1';
                            gmii_state <= FRAMEWAIT;
                        end if; 
                    when others =>
                        gmii_state  <= IDLE;
                        txcnt       <= (others => '0');
                        mfifo_rd    <= '0';
                        gmii_txdata <= (others => '0');
                        gmii_txen   <= '0';
                        gmii_length <= (others => '0');
                        sfifo_rd    <= '0';
                end case;
            end if;
        end if;
    end process p_gmii_state;

    crc_calc    <= '1' when (gmii_state = TXDATA OR gmii_state = TXPAD) else '0';
    crc_in_data <= mfifo_rddata when mfifo_rd = '1' else X"00";

    p_crc : process(clk_125m_i)
    begin
        if rising_edge(clk_125m_i) then
            if reset_125m_n_i = '0' then
                crc_reset     <= '0';
            else
                if(gmii_state = FRAMEWAIT) then
                    crc_reset <= '1';
                else
                    crc_reset <= '0';
                end if;
            end if;
        end if;
    end process p_crc;

    p_check_crc: process(clk_125m_i)
    begin
        if rising_edge(clk_125m_i) then
            if(crc_reset = '1') then
                crc_value <= c_CRC32_INIT_VALUE;
            elsif(crc_calc = '1') then
                crc_value <= f_update_crc32_d8(crc_value, crc_in_data);
            end if;
        end if;
    end process;

    gmii_txdata_o <= gmii_txdata;
    gmii_txen_o   <= gmii_txen;
    gmii_tx_er_o  <= '0';
    gmii_snk_o    <= snk_out;

end rtl;
