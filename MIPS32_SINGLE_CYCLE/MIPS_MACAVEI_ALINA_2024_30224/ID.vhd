library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ID is
  Port ( RegWrite : in std_logic  ; 
         Instruction : in std_logic_vector(25 downto 0) ;
         RegDst : in std_logic ;
         EN : in std_logic ; 
         WD : in std_logic_vector(31 downto 0) ; 
         ExtOp : in std_logic ;
         RD1 : out std_logic_vector(31 downto 0) ;
         RD2 : out std_logic_vector(31 downto 0) ;
         Ext_Imm : out std_logic_vector(31 downto 0) ;
         func : out std_logic_vector(5 downto 0) ; 
         sa : out std_logic_vector(4 downto 0) ;
         clk : in std_logic 
       );
end ID;

architecture Behavioral of ID is
signal mux1 : std_logic_vector(4 downto 0) := "00000" ; 
begin
    func <= Instruction(5 downto 0);
    sa <= Instruction(10 downto 6);
RegisterFile1 : entity work.RegisterFile port map(
           clk => clk , 
           ra1 => Instruction(25 downto 21) ,
           ra2 => Instruction(20 downto 16) , 
           wa  => mux1 ,
           wd  => WD , 
           regwr =>RegWrite ,
           rd1 => RD1 ,
           rd2 => RD2 ,
           en => EN
    );
    
    process(RegDst)
    begin 
        case RegDst is 
            when '0' => mux1 <= Instruction(20 downto 16) ; 
            when others => mux1 <= Instruction(15 downto 11) ;
        end case ; 
    end process ; 
    
    process(ExtOp)
    begin 
        case ExtOp is 
            when '0' => Ext_Imm <= x"00000000" ;
            when others => Ext_Imm <= x"0000" & Instruction(15 downto 0);
        end case ;
    end process;

    

end Behavioral;
