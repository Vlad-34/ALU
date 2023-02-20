library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bit_operations is
    generic (n : NATURAL := 32);
    port(X  : in STD_LOGIC_VECTOR ((n - 1) downto 0);
         Y  : in STD_LOGIC_VECTOR ((n - 1) downto 0);
         Op : in STD_LOGIC_VECTOR (3 downto 0);
         S  : out STD_LOGIC_VECTOR((n - 1) downto 0));
end bit_operations;

architecture Behavioral of bit_operations is
begin
MUX : process(Op) is
begin
    case Op is
        when "0100" => S <= not X;
        when "0101" => S <= X and Y;
        when "0110" => S <= X or Y;
        when "0111" => S <= X xor Y;
        when "1000" => S <= X(n - 1) & X((n - 1) downto 1);
        when "1001" => S <= X((n - 2) downto 0) & '0';
        when "1010" => S <= '0' & X((n - 1) downto 1);
        when "1011" => S <= X((n - 2) downto 0) & '0';
        when "1100" => S <= X(0) & X((n - 1) downto 1);
        when "1101" => S <= X((n - 2) downto 0) & X(n - 1);
        when others => S <= x"00000000";
    end case;
end process;

end Behavioral;
