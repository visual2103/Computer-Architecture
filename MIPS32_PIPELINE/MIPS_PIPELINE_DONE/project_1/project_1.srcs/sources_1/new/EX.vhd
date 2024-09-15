

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;
--use IEEE.std_logic_arith.ALL;

entity EX is
    Port ( PCp4 : in STD_LOGIC_VECTOR(31 downto 0);
           RD1 : in STD_LOGIC_VECTOR(31 downto 0);
           RD2 : in STD_LOGIC_VECTOR(31 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR(31 downto 0);
           func : in STD_LOGIC_VECTOR(5 downto 0);
           sa : in STD_LOGIC_VECTOR(4 downto 0);
           ALUSrc : in STD_LOGIC;
           ALUOp : in STD_LOGIC_VECTOR(2 downto 0);
           BranchAddress : out STD_LOGIC_VECTOR(31 downto 0);
           ALURes : out STD_LOGIC_VECTOR(31 downto 0);
           Zero : out STD_LOGIC;
           RegDst : in std_logic;
           RD : in std_logic_vector(4 downto 0);
           RT : in std_logic_vector(4 downto 0);
           WA : out std_logic_vector(4 downto 0));
end EX;

architecture Behavioral of EX is

signal A, B, C : STD_LOGIC_VECTOR(31 downto 0);
signal ALUCtrl : STD_LOGIC_VECTOR(2 downto 0);

begin

    --rt rd for pipeline
    WA <= RD WHEN RegDst = '1' ELSE RT;

    -- ALU Control
    process(ALUOp, func)
    begin
        case ALUOp is
            when "000" => -- R type 
                case func is
                    when "00000" => ALUCtrl <= "000" ;  -- +
                    when "00001" => ALUCtrl <= "001" ;  -- -
                    when "00010" => ALUCtrl <= "010" ;  -- >>1
                    when "00011" => ALUCtrl <= "011" ;  -- <<1
                    when "00100" => ALUCtrl <= "100" ;  -- &
                    when "00101" => ALUCtrl <= "101" ;  -- |
                    when "00110" => ALUCtrl <= "110" ;  -- xor
                    when others => ALUCtrl <= (others => 'X'); -- unknown
                end case;
             when "001" => ALUCtrl <= "000" ;  -- ADDI
             when "010" => ALUCtrl <= "100" ;  -- ANDI
             when "011" => ALUCtrl <= "001" ;  -- BEQ
             when "100" => ALUCtrl <= "000" ;  -- BGTZ  -----!!!
             when "101" => ALUCtrl <= "000" ;  -- BLTZ 
             when "110" => ALUCtrl <= "000" ;  -- LW
             when "111" => ALUCtrl <= "000" ;  -- SW
            when others => ALUCtrl <= (others => 'X'); -- unknown
        end case;
    end process;

    -- ALU
    A <= RD1;
    B <= Ext_Imm when ALUSrc = '1' else RD2; -- MUX for ALU input  
    process(ALUCtrl, A, B, sa)
    begin
        case ALUCtrl  is
            when "000" => -- ADD
                C <= A + B;
            when "100" =>  -- SUB
                C <= A - B;                                    
            when "011" => -- SLL
                C <= to_stdlogicvector(to_bitvector(B) sll conv_integer(sa));
            when "101" => -- SRL
                C <= to_stdlogicvector(to_bitvector(B) srl conv_integer(sa));
            when "001" => -- AND
                C <= A and B;		
            when "010" => -- OR
                C <= A or B; 
            when "110" => -- XOR
                C <= A xor B;		
            when "111" => -- SLT
                if signed(A) < signed(B) then
                    C <= X"00000001";
                else 
                    C <= X"00000000";
                end if;
            when others => -- unknown
                C <= (others => 'X');              
        end case;
    end process;

    -- zero detector
    Zero <= '1' when C = 0 else '0'; 

    -- ALU result
    ALURes <= C;

    -- generate branch address
    BranchAddress <= PCp4 + (Ext_Imm(29 downto 0) & "00");

end Behavioral;