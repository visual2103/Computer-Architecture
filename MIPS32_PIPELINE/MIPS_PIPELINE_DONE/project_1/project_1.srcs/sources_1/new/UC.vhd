
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UC is
    Port ( Instr : in STD_LOGIC_VECTOR(5 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR(2 downto 0);
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end UC;

architecture Behavioral of UC is
begin

    process(Instr)
    begin
        RegDst <= '0'; ExtOp <= '0'; ALUSrc <= '0'; 
        Branch <= '0'; Jump <= '0'; MemWrite <= '0';
        MemtoReg <= '0'; RegWrite <= '0';
        ALUOp <= "000";
        case (Instr) is 
          --add, sub, srl, sll, and, or , xor
            when "000000" => 
              RegDst <= '1' ;
              RegWrite <= '1' ; 
   
            -- ADDI
            when "000001" => 
              ExtOp <= '1' ; 
              ALUSrc <= '1' ; 
              RegWrite <= '1' ; 
              ALUOp <= "001" ; 
            -- ANDI
            when "000010" =>
              ExtOp <= '1' ; 
              ALUSrc <= '1' ; 
              RegWrite <= '1' ; 
              ALUOp <= "010" ; 
            -- BEQ 
            when "000011" =>
              ExtOp <= '1' ; 
              Branch <= '1' ;
              ALUOp <= "011" ; 
            -- BGTZ
            when "000100" =>
              ExtOp <= '1'; 
              Branch <= '1' ;
              ALUOp <= "100" ; 
            -- SLT
            when "000101" =>
              -- slt 
              RegDst <= '1';
              RegWrite <= '1' ;
              ALUOp <="101";
            --LW
            when "000110" =>
              ExtOp <= '1'; 
              ALUSrc <= '1' ; 
              MemWrite <= '1' ;
              ALUOp <= "111" ; 
            --SW
            when "000111" =>
              ExtOp <= '1'; 
              ALUSrc <= '1' ;
              MemToReg <= '1' ; 
              RegWrite <= '1' ; 
              ALUOp <= "110" ; 
            --JUMP
            when "001000" => 
                Jump <= '1' ;
          
            when others => 
                RegDst <= 'X'; ExtOp <= 'X'; ALUSrc <= 'X'; 
                Branch <= 'X'; Jump <= 'X'; MemWrite <= 'X';
                MemtoReg <= 'X'; RegWrite <= 'X';
                ALUOp <= "XXX";
        end case;
    end process;		

end Behavioral;