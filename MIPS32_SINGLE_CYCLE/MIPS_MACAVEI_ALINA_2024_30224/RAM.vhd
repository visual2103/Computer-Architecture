----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2024 06:54:50 PM
-- Design Name: 
-- Module Name: RAM - Behavioral
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

entity RAM is
  Port ( Address : in std_logic_vector(5 downto 0);
         WriteData : in std_logic_vector(31 downto 0);
         CLk : in std_logic ;
         EN : in std_logic ; 
         MemWrite : in std_logic ; 
         ReadData : out std_logic_vector(31 downto 0)
         ) ; 
end RAM;

architecture Behavioral of RAM is
type ram_type is array (0 to 63) of std_logic_vector(31 downto 0 ) ;
signal ram : ram_type := (
    X"00000005",
    X"00000005",
    X"00000003",
    X"00000000",
    X"00000001",
    X"00000002",
    X"00000003",
    X"00000004",
    X"00000005",
    X"00000000",
    X"00000003",
    X"00000004",
    X"00000005",
    X"00000000",
    X"00000007",
    X"00000008",
    X"00000000",
    X"00000000",
    others => (others => '0')) ; 
begin
    process(clk)
    begin
    if rising_edge(clk) then 
        if EN ='1' then 
            if MemWrite = '1' then 
                ram(conv_integer(Address)) <= WriteData ; 
            end if ; 
        end if  ; 
    end if ;
    end process ; 
    --citirea asincrona 
    ReadData <= ram(conv_integer(Address)) ; 
end Behavioral;
