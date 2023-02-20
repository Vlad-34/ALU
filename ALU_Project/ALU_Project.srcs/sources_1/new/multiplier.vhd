library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity multiplier is
    generic(n : NATURAL := 32);
    port(signal Clk : in STD_LOGIC;
         signal Rst : in STD_LOGIC;
         signal X   : in STD_LOGIC_VECTOR((n - 1) downto 0);
         signal Y   : in STD_LOGIC_VECTOR((n - 1) downto 0);
         signal P   : out STD_LOGIC_VECTOR((2 * n - 1) downto 0));
end multiplier;

architecture Behavioral of multiplier is

type states is (init, branch, shiftDecAndCheck, stop);
signal current_state : states := init;

signal A   : STD_LOGIC_VECTOR(n downto 0); -- n+1
signal Q   : STD_LOGIC_VECTOR(n downto 0); -- n+1
signal B   : STD_LOGIC_VECTOR(n downto 0); -- n+1
signal Q_1 : STD_LOGIC;
signal C   : NATURAL;

begin

unified_logic : process(Clk)
begin
    if rising_edge(Clk) then
        if Rst = '1' then
            current_state <= init;
        else
            case current_state is
                when init =>
                    B <= X(n - 1) & X;
                    A <= '0' & x"00000000";
                    Q <= Y(n - 1) & Y;
                    Q_1 <= '0';
                    C <= n + 1;
                    current_state <= branch;
                when branch =>
                    if Q(0) = '1' and Q_1 = '0' then
                        A <= A - B;
                    elsif Q(0) = '0' and Q_1 = '1' then
                        A <= A + B;
                    end if;
                    current_state <= shiftDecAndCheck;
                when shiftDecAndCheck =>
                    Q_1 <= Q(0);
                    Q <= A(0) & Q(n downto 1);
                    A <= A(n) & A(n downto 1); -- shra A_Q
                    
                    C <= C - 1;
                    if C > 1 then
                        current_state <= branch;
                    else
                        current_state <= stop;
                    end if;
                when stop =>
                    current_state <= stop;
            end case;
        end if;
    end if;
end process;

P <= A((n - 2) downto 0) & Q;

end Behavioral;
