library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CLA_32bit is
    generic (m : NATURAL := 32);
    port(X, Y : in STD_LOGIC_VECTOR ((m - 1) downto 0);
         Tin  : in STD_LOGIC;
         S    : out STD_LOGIC_VECTOR ((m - 1) downto 0);
         Tout : out STD_LOGIC);
end CLA_32bit;

architecture Behavioral of CLA_32bit is

constant n : NATURAL := 8;
signal P_signal, G_signal, T_signal : STD_LOGIC_VECTOR(0 to (m / n));
signal Y_signal : STD_LOGIC_VECTOR((m - 1) downto 0);

begin

T_signal(0) <= Tin;
Y_signal <= not Y when Tin = '1' else Y;

generare : for i in 0 to (m / n - 1) generate
    CLA8 : entity WORK.CLA_8bit
        port map (X   => X((i * n + n - 1) downto i * n),
                Y => Y_signal((i * n + n - 1) downto i * n),
                Tin => T_signal(i),
                S => S((i * n + n - 1) downto i * n),
                P => P_signal(i),
                G => G_signal(i));
        T_signal(i + 1) <= G_signal(i) or (P_signal(i) and T_signal(i));
end generate;
    
Tout <= T_signal(m / n);
    
end Behavioral;
