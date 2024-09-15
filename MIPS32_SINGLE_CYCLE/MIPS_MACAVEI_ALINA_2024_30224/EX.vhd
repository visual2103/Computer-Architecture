library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;
use IEEE.numeric_std.ALL;
entity EX is
  Port ( RD1 : in std_logic_vector(31 downto 0) ; 
         ALUSrc : in std_logic ; 
         RD2 : in std_logic_vector(31 downto 0) ; 
         Ext_Imm : in std_logic_vector(31 downto 0) ; 
         sa :in std_logic_vector(4 downto 0) ; 
         func :in std_logic_vector(5 downto 0) ; 
         ALUOp:in std_logic_vector(2 downto 0) ; 
         PC4: in std_logic_vector(31 downto 0) ; 
         Zero:out std_logic ; 
         ALURes :out std_logic_vector(31 downto 0) ; 
         BranchAddress :out std_logic_vector(31 downto 0) 
          );
end EX;

architecture Behavioral of EX is
signal mux : std_logic_vector(31 downto 0 ):= x"00000000" ;
signal ALUCtrl : std_logic_vector(2 downto 0) := "000" ; 
signal alu: std_logic_vector(31 downto 0) := x"00000000" ; 
begin
    BranchAddress <= (EXt_Imm(31 downto 2) & "00" ) +PC4 ; 
    process (ALUOp , func)
    begin 
        case ALUOp is 
            when "000" => 
                case func is 
                    when "00000" => ALUCtrl <= "000" ;  -- +
                    when "00001" => ALUCtrl <= "001" ;  -- -
                    when "00010" => ALUCtrl <= "010" ;  -- >>1
                    when "00011" => ALUCtrl <= "011" ;  -- <<1
                    when "00100" => ALUCtrl <= "100" ;  -- &
                    when "00101" => ALUCtrl <= "101" ;  -- |
                    when "00110" => ALUCtrl <= "110" ;  -- xor
                    when others => ALUCtrl <= "000" ; 
                end case ;
             when "001" => ALUCtrl <= "000" ;  -- ADDI
             when "010" => ALUCtrl <= "100" ;  -- ANDI
             when "011" => ALUCtrl <= "001" ;  -- BEQ
             when "100" => ALUCtrl <= "000" ;  -- BGTZ  ----- CORECTEAZA !!!
             when "101" => ALUCtrl <= "000" ;  -- BLTZ 
             when "110" => ALUCtrl <= "000" ;  -- LW
             when "111" => ALUCtrl <= "000" ;  -- SW
             when others => ALUCtrl <= "000" ; 
         end case ;
    end process ; 

    process(ALUSrc)
    begin
        case AluSrc is 
            when '0' => mux <= RD2 ; -- tip R
            when others => mux <= Ext_Imm ; -- tip I
        end case ;
    end process ; 
    
    BranchAddress <= ( PC4 + ( Ext_Imm (31 downto 2) & "00")) ; 
    process (ALUCtrl) 
    begin 
        case ALUCtrl is 
            when "000" => alu <= mux + RD1 ;              
            when "001" => alu <= mux - RD1 ;  -- se dau peste cap?
            when "010" => alu <= to_stdlogicvector(to_bitvector(mux)srl conv_integer(sa)) ;  -- << sa
            when "011" => alu <= to_stdlogicvector(to_bitvector(mux)srl conv_integer(sa)) ;  -- << sa ; 
            when "100" => alu <= mux and RD1 ; 
            when "101" => alu <= mux or RD1 ; 
            when "110" => alu <= mux xor RD1 ; 
            when "111" => alu <= mux + RD1 ; 
            when others => alu <= x"00000000" ; 
        end case ;
    end process ;
   
   ALURes <= alu ; 
   process(alu)
   begin
        case alu is 
            when x"00000000" => Zero <= '1' ;
            when others => Zero <= '0' ;
        end case ;
   end process;
    
    
end Behavioral;
