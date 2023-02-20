library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CLA_32bit_tb is
end CLA_32bit_tb;

architecture Behavioral of CLA_32bit_tb is

signal X    : STD_LOGIC_VECTOR(31 downto 0);
signal Y    : STD_LOGIC_VECTOR(31 downto 0);
signal Tin  : STD_LOGIC;
signal S    : STD_LOGIC_VECTOR(31 downto 0);
signal Tout : STD_LOGIC;

constant CLK_PERIOD : TIME := 10 ns;

begin

DUT : entity WORK.CLA_32bit port map(
    X => X,
    Y => Y,
    Tin => Tin,
    S => S,
    Tout => Tout);

gen_vect_test: process
begin
    X <= x"00000006";
    Y <= x"000000F0";
    Tin <= '0';
    wait for CLK_PERIOD;
    assert S = x"000000F6" severity FAILURE;
    
    X <= x"0FFFFFF6";
    Y <= x"0FFFFFF4";
    Tin <= '0';
    wait for CLK_PERIOD;
    assert S = x"1FFFFFEA" severity FAILURE;
    
    X <= x"00000006";
    Y <= x"000000F0";
    Tin <= '1';
    wait for CLK_PERIOD;
    assert S = x"FFFFFF16" severity FAILURE;
    
    X <= x"000000F0";
    Y <= x"00000006";
    Tin <= '1';
    wait;
    assert S = x"000000EA" severity FAILURE;
end process gen_vect_test;

end Behavioral;
