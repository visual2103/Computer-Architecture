library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;
entity IFetch is 
    Port (Jump : in std_logic ;
          JumpAddress : in std_logic_vector(31 downto 0) ;
          PCSrc : in std_logic ;
          BranchAddress : in std_logic_vector(31 downto 0) ;
          PC4: out std_logic_vector(31 downto 0 ) ;
          Instruction : out std_logic_vector(31 downto 0 ) ;
          en : in std_logic ; 
          rst : in std_logic ; 
          clk : in std_logic 
);
end IFetch;

architecture Behavioral of IFetch is

signal outputPC : std_logic_vector(31 downto 0) ;
signal muxBr : std_logic_vector(31 downto 0) ; 
signal muxJ : std_logic_vector(31 downto 0) ; 

begin
    PCounter : entity work.PC port map(
        rst => rst , clk => clk , en => en , d => muxJ , q => outputPC  ) ; 
    ROM1 : entity work.ROM port map(
        addr => outputPC(6 downto 2),  data => Instruction ) ; 
       
    process(jump) 
    begin 
        case jump is
            when '0' => muxJ <= JumpAddress ; 
            when others  => muxJ <= muxBr ; 
        end case ;
    end process ; 
    
    process(PCSrc)
    begin 
        case PCSrc is 
            when '1' => muxBr <= BranchAddress ; 
            when others => muxBr <= outputPC + 4 ; 
        end case ;
    end process ; 
    
    PC4 <= outputPC + 4 ; 
    

end Behavioral;
