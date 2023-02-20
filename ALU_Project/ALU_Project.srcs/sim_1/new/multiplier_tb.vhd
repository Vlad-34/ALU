library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplier_tb is
end multiplier_tb;

architecture Behavioral of multiplier_tb is

signal Clk : STD_LOGIC;
signal Rst : STD_LOGIC;
signal X   : STD_LOGIC_VECTOR(31 downto 0);
signal Y   : STD_LOGIC_VECTOR(31 downto 0);
signal P   : STD_LOGIC_VECTOR(63 downto 0);

constant CLK_PERIOD : TIME := 10 ns;

begin

DUT : entity WORK.multiplier port map(
    Clk => Clk,
    Rst => Rst,
    X => X,
    Y => Y,
    P => P);
     
gen_clk : process
begin
    Clk <= '0';
    wait for (CLK_PERIOD/2);
    Clk <= '1';
    wait for (CLK_PERIOD/2);
end process gen_clk;

gen_vect_test : process
begin
    Rst <= '1';
    wait for CLK_PERIOD;
    Rst <= '0';
    X <= x"00000006";
    Y <= x"00000004";
    wait for 105 * CLK_PERIOD;
    assert P = x"0000000000000018" severity FAILURE;
    Rst <= '1';
    wait for CLK_PERIOD;
    Rst <= '0';
    X <= x"0FFFFFF6";
    Y <= x"0FFFFFF4";
    wait;
    assert P = x"00fffffea0000078" severity FAILURE;
end process gen_vect_test;

end Behavioral;
