library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;


entity UC is
    Port( opcode : in std_logic_vector( 5 downto 0 ) ;
          RegDst : out std_logic;
          ExtOp : out std_logic ; 
          ALUSrc :out std_logic ; 
          Branch :out std_logic ; 
          Jump : out std_logic;
          ALUOp :out std_logic_vector(2 downto 0) ;
          MemWrite :out std_logic ; 
          MemToReg :out std_logic ; 
          RegWrite : out std_logic
    );
end UC ; 

architecture Behavioral of UC is

begin
    process(opcode)
    begin
    RegDst <= '0' ;
    ExtOp <= '0'; 
    ALUSrc <= '0' ; 
    Branch <= '0';
    Jump <= '0' ; 
    ALUOp <="000" ; 
    MemWrite <= '0' ; 
    MemToReg <= '0' ; 
    RegWrite <= '0' ; 
    case opcode is
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
                RegDst <= '0' ; 
    end case ;
    end process ; 
end Behavioral;

