library ieee;
use ieee.std_logic_1164.all;
library lpm;
use lpm.lpm_components.all;
use work.all;

entity reg_file is
	port(
		clk : in std_logic;
		uOps : in std_logic_vector(29 downto 9); --from useq
		M_q : in std_logic_vector(7 downto 0); --from ram
		A_q : out std_logic_vector(7 downto 0);
		M_addr : out std_logic_vector(7 downto 0) --to ram
		M_write : out std_logic --to ram
	);
end entity;

architecture structural of reg_file is
	--register outputs
	signal SP_q, PC_q, opcode, DR_q, R_q, A_q : std_logic_vector(7 downto 0);
	--register loads
	signal MARLOAD, SPLOAD, PCLOAD, IRLOAD, DRLOAD, RLOAD, ALOAD, ZLOAD : std_logic;
	--counting controls
	signal SPCNT, SPUD, PCCNT, PCCLR : std_logic;
	--mux selectors
	signal MARSEL, ASEL : std_logic_vector(1 downto 0);
	signal DRSEL, ALUSEL : std_logic;
	--intermediate signals
	signal MAR_mux_data : std_logic_2D(3 downto 0, 7 downto 0);
	signal MAR_mux_out : std_logic_vector(7 downto 0);
	signal DR_mux_data : std_logic_2D(1 downto 0, 7 downto 0);
	signal DR_mux_out : std_logic_vector(7 downto 0);
begin
	
	GEN_MUX_SIGNALS: for i in 0 to 7 generate
		MAR_mux_data(0, i) <= SP_q(i);
		MAR_mux_data(1, i) <= PC_q(i);
		MAR_mux_data(2, i) <= DR_q(i);
		MAR_mux_data(3, i) <= '0';
	end generate;
	
	MAR_MUX: lpm_mux
		generic map(lpm_width=>8, lpm_size=>4, lpm_widths=>2)
		port map(data=>MAR_mux_data, sel=>MARSEL, result=>MAR_mux_out);
		
	MAR_REG: lpm_ff
		generic map(lpm_width=>8)
		port map(clock=>clk, sload=> MARLOAD, data=>MAR_mux_out, q=>M_addr);
	
	SP_COUNTER: lpm_counter
		generic map(lpm_width=>8)
		port map(clock=>clk, data=>DR_q, sload=>SPLOAD, cnt_en=>SPCNT, updown=>SPUD, q=>SP_q);
	
	PC_COUNTER: lpm_counter
		generic map(lpm_width=>8)
		port map(clock=>clk, data=>DR_q, sload=>PCLOAD, cnt_en=>PCCNT, sclr=>PCCLR, q=>PC_q);
	
	IR_REG: lpm_ff
		generic map(lpm_width=>8)
		port map(clock=>clk, sload=>IRLOAD, data=>DR_q, q=>opcode);
		
	DR_MUX: lpm_mux
		generic map(lpm_width=>8, lpm_size=>2, lpm_widths=>1)
		port map(data=>DR_mux_data, sel => MARSEL, result => MAR_mux_out);
	
	DR_REG: lpm_ff
		generic map(lpm_width=>8)
		port map(clock=>clk, sload=>DRLOAD, data=>DR_mux_out, q=>DR_q);
		
	R_REG: lpm_ff
		generic map(lpm_width=>8)
		port map(clock=>clk, sload=>RLOAD, data=>A_q, q=>R_q);
	
	ALU: entity work.exp7_alu
		port map(a => A_q, )
	
end architecture;