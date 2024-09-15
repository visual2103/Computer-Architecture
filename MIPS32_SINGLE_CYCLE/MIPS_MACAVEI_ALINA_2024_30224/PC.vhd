----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2024 07:55:04 PM
-- Design Name: 
-- Module Name: PC - Behavioral
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

entity PC is
  Port ( clk : in std_logic ; 
         en : in std_logic ; 
         rst : in std_logic ; 
         d : in std_logic_vector(31 downto 0);
         q : out std_logic_vector(31 downto 0 )
        );
end PC;

architecture Behavioral of PC is
begin
    process(clk)
    begin 
        if rst = '1' then 
            q <= (others => '0' );
        elsif rising_edge(clk) then 
            if en = '1' then 
                q <= d ; 
            end if ;  
        end if ;   
    end process ; 

end Behavioral;
