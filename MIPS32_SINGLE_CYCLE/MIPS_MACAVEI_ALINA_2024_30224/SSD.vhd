----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2024 06:04:33 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;


entity SSD is
  Port ( CLK : in std_logic ; 
         sw32 : in std_logic;
         input:in std_logic_vector(31 downto 0) ;
         an : out std_logic_vector(3 downto 0);
         cat: out std_logic_vector(6 downto 0)
         );
end SSD;

architecture Behavioral of SSD is
signal counter : std_logic_vector(15 downto 0) := x"0000" ; 
signal selection : std_logic_vector(1 downto 0) := "00" ; 
signal digit : std_logic_vector(3 downto 0) := "0000" ; 
begin
    process(clk)
    begin 
        if rising_edge(clk) then 
            counter <= counter + 1 ; 
        end if ;
    end process; 
   
    selection(1 downto 0) <= counter(15 downto 14) ;
    
    process(selection)
    begin 
        if sw32 = '0'  then 
            case (selection) is
                when "00" => an <= "1110" ; 
                             digit <= input(3 downto 0 );
                when "01" => an <= "1101" ; 
                             digit <= input(7 downto 4 );
                when "10" => an <= "1011" ; 
                             digit <= input(11 downto 8 );   
                when "11" => an <= "0111" ; 
                             digit <= input(15 downto 12 );
                when others => an <= x"0" ; 
                               digit <= "0000" ;
            end case ;
        else 
            case (selection) is 
                when "00" => an <= "1110" ; 
                             digit <= input(19 downto 16 );
                when "01" => an <= "1101" ; 
                             digit <= input(23 downto 20 );
                when "10" => an <= "1011" ; 
                             digit <= input(27 downto 24 );
                when "11" => an <= "0111" ; 
                             digit <= input(31 downto 28 );
                when others => an <= x"0" ; 
                               digit <= "0000";
            end case ;
        end if ;
    end process ; 
    
    process(selection , digit)
    begin 
        case digit is
        when x"0" => cat <= "0000001";
        when x"1" => cat <= "1001111";
        when x"2" => cat <= "0010010";
        when x"3" => cat <= "0000110";
        when x"4" => cat <= "1001100";
        when x"5" => cat <= "0100100";
        when x"6" => cat <= "0100000";
        when x"7" => cat <= "0001111";
        when x"8" => cat <= "0000000";
        when x"9" => cat <= "0001100";
        when x"A" => cat <= "0001000";
        when x"B" => cat <= "1100000";
        when x"C" => cat <= "0110001";
        when x"D" => cat <= "1000010";
        when x"E" => cat <= "0110000";
        when others => cat <= "0111000";
    end case;
    end process ; 
 

end Behavioral;
