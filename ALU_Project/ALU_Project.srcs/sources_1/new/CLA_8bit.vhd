library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CLA_8bit is
    generic (n : NATURAL := 8);
    port(X, Y : in STD_LOGIC_VECTOR((n - 1) downto 0);
         Tin  : in STD_LOGIC;
         S    : out STD_LOGIC_VECTOR((n - 1) downto 0);
         P, G : out STD_LOGIC);
end CLA_8bit;

architecture Behavioral of CLA_8bit is

signal G_signal, P_signal     : STD_LOGIC_VECTOR((n - 1) downto 0);
signal T_signal, P_acc, G_acc : STD_LOGIC_VECTOR (n downto 0);

begin

T_signal(0) <= Tin;
G_acc(n) <= '0';
P_acc(n) <= '1';
    
SE : for i in 0 to (n - 1) generate
    G_signal(i) <= X(i) and Y(i);
    P_signal(i) <= X(i) or Y(i);
    T_signal(i + 1) <= G_signal(i) or (P_signal(i) and T_signal(i));
    S(i) <= X(i) xor Y(i) xor T_signal(i);
end generate;
    
GP : for i in (n - 1) downto 0 generate
    G_acc(i) <= G_acc(i + 1) or (G_signal(i) and P_acc(i + 1));
    P_acc(i) <= P_acc(i + 1) and P_signal(i);
end generate;
    
G <= G_acc(0);
P <= P_acc(0);

end Behavioral;
