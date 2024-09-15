library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity MEM is
  Port (MemWrite :in std_logic ; 
        ALUResIn : in std_logic_vector(31 downto 0);
        RD2 : in std_logic_vector(31 downto 0) ; 
        MemData : out std_logic_vector(31 downto 0 );
        CLK : in std_logic ; 
        EN : in std_logic ; 
        ALUResOut :out std_logic_vector(31 downto 0 ) 
      );
end MEM;

architecture Behavioral of MEM is

begin
     ALUResOut <= AluResIn ; 
RAM1 : entity work.RAM port map(
     Address => ALUResIn(7 downto 2),
     WriteData => RD2 ,
     CLk => CLK ,
     EN => EN , 
     MemWrite => MemWrite ,
     ReadData => MemData
   );
end Behavioral;
