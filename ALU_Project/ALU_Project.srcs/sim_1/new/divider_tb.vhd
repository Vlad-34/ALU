library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity divider_tb is
end divider_tb;

architecture Behavioral of divider_tb is

signal Clk     : STD_LOGIC;
signal Rst     : STD_LOGIC;
signal X       : STD_LOGIC_VECTOR(31 downto 0);
signal Y       : STD_LOGIC_VECTOR(31 downto 0);
signal Quot    : STD_LOGIC_VECTOR(31 downto 0);
signal Remi    : STD_LOGIC_VECTOR(31 downto 0);
signal ErrDiv0 : STD_LOGIC;

constant CLK_PERIOD : TIME := 10 ns;

begin

DUT : entity WORK.divider port map(
    Clk => Clk,
    Rst => Rst,
    X => X,
    Y => Y,
    Quot => Quot,
    Remi => Remi,
    ErrDiv0 => ErrDiv0);
     
gen_clk: process
begin
    Clk <= '0';
    wait for (CLK_PERIOD/2);
    Clk <= '1';
    wait for (CLK_PERIOD/2);
end process gen_clk;

gen_vect_test: process
begin
    Rst <= '1';
    wait for CLK_PERIOD;
    Rst <= '0';
    X <= x"00000006";
    Y <= x"00000000";
    wait for 105 * CLK_PERIOD;
    assert Quot = x"ffffffff" and Remi = x"00000006" severity FAILURE;
    Rst <= '1';
    wait for CLK_PERIOD;
    Rst <= '0';
    X <= x"0FFFFFF6";
    Y <= x"0FFFFFF4";
    wait;
    assert Quot = x"00000001" and Remi = x"00000002" severity FAILURE;
end process gen_vect_test;

end Behavioral;
