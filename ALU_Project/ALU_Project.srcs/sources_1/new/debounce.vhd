library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity debounce is
    port(Clk    : in STD_LOGIC;
         Btn    : in STD_LOGIC;
         Enable : out STD_LOGIC);
end debounce;

architecture Behavioral of debounce is

signal counter: STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
signal Q1: STD_LOGIC;
signal Q2: STD_LOGIC;
signal Q3: STD_LOGIC;

begin

Clk_divider : process(Clk)
begin
    if rising_edge(Clk) then
        if counter(15 downto 0) = "1111111111111111" then
            Q1 <= Btn;
        end if;
    end if;        
end process;

count : process(Clk)
begin
    if rising_edge(Clk) then
        counter <= counter + 1;
end if;    
end process;

process(Clk)
begin
    if rising_edge(Clk) then
        Q2<=Q1;
        Q3<=Q2;
    end if;    
end process;
    
Enable <= (not Q3) and Q2;
	
end Behavioral;