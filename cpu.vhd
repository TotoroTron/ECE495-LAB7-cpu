library ieee;
use ieee.std_logic_1164.all;
library lpm;
use lpm.lpm_components.all;

entity cpu is
	port(
		clk : in std_logic;				--from clk-div.vhd
		M_q: in std_logic_vector(7 downto 0);		--from reg_FILE from lpm_ram_dq
		A_q: out std_logic_vector(7 downto 0);		--from reg_FILE from lpm_ram_dq
		M_addr: out std_logic_vector(7 downto 0);	--to reg_FILE to lpm_ram_dq
		M_write: out std_logic;				--to reg_FILE to lpm_ram_dq
		M_data: out std_logic_vector(7 downto 0)
	);
end entity;

architecture dataflow of cpu is
	component exp7_useq is
		generic (
			uROM_width: integer;
			uROM_file: string
		);
		port(
			opcode: in std_logic_vector(3 downto 0);
			uop: out std_logic_vector(29 downto 9);
			clock: in std_logic
		);
	end component;
	component reg_file is
		port(
			clk : in std_logic;
			uOps : in std_logic_vector(29 downto 9); --from useq
			M_q : in std_logic_vector(7 downto 0); --from ram
			opcode : out std_logic_vector(3 downto 0);
			A_q_out : out std_logic_vector(7 downto 0);
			M_data : out std_logic_vector(7 downto 0);
			M_addr : out std_logic_vector(7 downto 0); --to ram
			M_write : out std_logic --to ram
		);
	end component;
	signal uOP : std_logic_vector(29 downto 9);
	signal opcode : std_logic_vector(3 downto 0);
	signal not_clk : std_logic;
begin
	not_clk <= not clk;
	uSEQUENCER : exp7_useq
		generic map(uROM_width => 30, uROM_file => "microde.hex")
		port map(clock => clk, opcode => opcode, uop => uOP);
		
	REGISTER_FILE : reg_file
		port map(
			clk => clk, --clk_div.vhd
			uOps => uOp,
			M_q => M_q,
			opcode => opcode,
			A_q_out => A_q,
			M_addr => M_addr,
			M_write => M_write
		);
end architecture;
