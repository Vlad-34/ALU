library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity divider is
    generic(n : NATURAL := 32);
    port(signal Clk     : in STD_LOGIC;
         signal Rst     : in STD_LOGIC;
         signal X       : in STD_LOGIC_VECTOR((n - 1) downto 0);
         signal Y       : in STD_LOGIC_VECTOR((n - 1) downto 0);
         signal Quot    : out STD_LOGIC_VECTOR((n - 1) downto 0);
         signal Remi    : out STD_LOGIC_VECTOR((n - 1) downto 0);
         signal ErrDiv0 : OUT STD_LOGIC := '0');
end divider;

architecture Behavioral of divider is

type states is (init, shift, bitCheck, assign, check, stop);
signal current_state : states := init;

signal A  : STD_LOGIC_VECTOR(n downto 0); -- n+1
signal Q  : STD_LOGIC_VECTOR((n - 1) downto 0); -- n
signal B  : STD_LOGIC_VECTOR((n - 1) downto 0); -- n+1
signal BS : STD_LOGIC;
signal C  : NATURAL;

begin

unified_logic : process(Clk)
begin
    if rising_edge(Clk) then
        if Rst = '1' then
            current_state <= init;
        else
            case current_state is
                when init =>
                    B <= Y;
                    A <= '0' & x"00000000";
                    Q <= X;
                    C <= n;
                    BS <= '0';
                    current_state <= shift;
                when shift =>
                    A <= A((n - 1) downto 0) & Q(n - 1);
                    Q <= Q((n - 2) downto 0) & '0';
                    current_state <= bitCheck;
                when bitCheck =>
                    if BS = '1' then
                        A <= A + B;
                    else
                        A <= A - B;
                    end if;
                    current_state <= assign;
                    
                when assign =>
                    Q(0) <= not A(n);
                    BS <= A(n);
                    C <= C - 1;
                    
                    if C > 1 then
                        current_state <= shift;
                    else
                        current_state <= check;
                    end if;
                    
                when check =>
                    if BS = '1' then
                        A <= A + B;
                    end if;
                    current_state <= stop;
                    
                when stop =>
                    if B = x"00000000" then
                        ErrDiv0 <= '1';
                    else
                        ErrDiv0 <= '0';
                    end if;
                    current_state <= stop;
            end case;
        end if;
    end if;
end process;

Quot <= Q;
Remi <= A((n - 1) downto 0);

end Behavioral;
