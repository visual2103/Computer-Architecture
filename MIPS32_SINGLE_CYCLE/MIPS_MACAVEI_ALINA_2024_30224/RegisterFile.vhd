library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RegisterFile is
    Port ( clk : in std_logic;
           ra1 : in std_logic_vector(4 downto 0);
           ra2 : in std_logic_vector(4 downto 0);
           wa :  in std_logic_vector(4 downto 0);
           wd :  in std_logic_vector(31 downto 0);
           regwr : in std_logic;
           rd1 : out std_logic_vector(31 downto 0);
           rd2 : out std_logic_vector(31 downto 0);
           en : in std_logic );
    end RegisterFile;
    
architecture Behavioral of RegisterFile is
type reg_array is array(0 to 31) of std_logic_vector(31 downto 0);
signal reg_file : reg_array:= (x"00000000",
    x"00000004", -- A = 12 
    x"00000005", -- N = 5
    x"00000003",
    x"00000004",
    x"00000005",
    x"00000006",
    x"00000007",
    x"00000008",
    x"00000009",
    x"0000000A",
    x"0000000B",
    x"0000000C",
    x"0000000D", -- de unde incepe
    x"0000000E",
    x"0000000F",
    x"00000000",
    x"00000001",
    x"00000002",
    others => x"00000000");
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if regwr = '1' then
                reg_file(conv_integer(wa)) <= wd;
            end if;
        end if;
    end process;
    rd1 <= reg_file(conv_integer(ra1));
    rd2 <= reg_file(conv_integer(ra2));
end Behavioral ;