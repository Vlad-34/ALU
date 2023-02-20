library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- 0000 add
-- 0001 sub
-- 0010 mul
-- 0011 div
-- 0100 not
-- 0101 and
-- 0110 or
-- 0111 xor
-- 1000 shr
-- 1001 shl
-- 1010 sar
-- 1011 sal
-- 1100 ror
-- 1101 rol

entity Main is
    port(Clk : in STD_LOGIC;
         sw  : in STD_LOGIC_VECTOR(15 downto 0);
         btn : in STD_LOGIC;
         led : out STD_LOGIC;
         an  : out STD_LOGIC_VECTOR(3 downto 0);
         cat : out STD_LOGIC_VECTOR(6 downto 0));
end Main;

architecture Behavioral of Main is

constant n : INTEGER := 32;

signal debounced_btn : STD_LOGIC;
signal S_signal, P_signal, G_signal : STD_LOGIC_VECTOR((n - 1) downto 0);
signal Tout : STD_LOGIC;

signal X_signal, Y_signal : STD_LOGIC_VECTOR(31 downto 0);
signal fromCLA_signal, fromBitOperation_signal, fromDiv_signal_quot, fromDiv_signal_remi, fromDiv_signal : STD_LOGIC_VECTOR(31 downto 0);
signal fromMul_signal : STD_LOGIC_VECTOR(63 downto 0);
signal Tin_signal : STD_LOGIC;

begin

    X_signal <= "00000000000000000000000000" & sw(15 downto 10);
    Y_signal <= "00000000000000000000000000" & sw(5 downto 0);
    Tin_signal <= '1' when sw(9 downto 6) = "0001" else '0'; -- 0 for +, 1 for -
    S_signal <= fromCLA_signal when sw(9 downto 6) = "0000" or sw(9 downto 6) = "0001" else fromMul_signal(31 downto 0) when sw(9 downto 6) = "0010" else fromDiv_signal when sw(9 downto 6) = "0011" else fromBitOperation_signal;
    fromDiv_signal <= x"0000" & fromDiv_signal_quot(7 downto 0) & fromDiv_signal_remi(7 downto 0);
    
debouncer : entity WORK.debounce
    port map (
         Clk => Clk,
         Btn => btn,
         Enable => debounced_btn);
    
CLA32 : entity WORK.CLA_32bit
    port map (
        X => X_signal,
        Y => Y_signal,
        Tin => Tin_signal,
        S => fromCLA_signal,
        Tout => Tout);
        
logic_and_shift : entity WORK.bit_operations
    port map (
        X => X_signal,
        Y => Y_signal,
        Op => sw(9 downto 6),
        S => fromBitOperation_signal);
        
multiply : entity WORK.multiplier
    port map (
        Clk => Clk,
        Rst => debounced_btn,
        X => X_signal,
        Y => Y_signal,
        P => fromMul_signal);
        
divide : entity WORK.divider
    port map (
        Clk => Clk,
        Rst => debounced_btn,
        X => X_signal,
        Y => Y_signal,
        Quot => fromDiv_signal_quot,
        Remi => fromDiv_signal_remi,
        ErrDiv0 => led);
        
        
SSD : entity WORK.displ7seg
    port map (
        Clk => Clk,
        Rst => debounced_btn,
        Data => S_signal(15 downto 0),
        An => an,
        Seg => cat);

end Behavioral;
