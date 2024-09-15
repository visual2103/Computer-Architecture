
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IFetch is
    Port (clk : in STD_LOGIC;
          rst : in STD_LOGIC;
          en : in STD_LOGIC;
          BranchAddress : in STD_LOGIC_VECTOR(31 downto 0);
          JumpAddress : in STD_LOGIC_VECTOR(31 downto 0);
          Jump : in STD_LOGIC;
          PCSrc : in STD_LOGIC;
          Instruction : out STD_LOGIC_VECTOR(31 downto 0);
          PCp4 : out STD_LOGIC_VECTOR(31 downto 0));
end IFetch;

architecture Behavioral of IFetch is

-- Memorie ROM
type tROM is array (0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
signal ROM : tROM := (
   
 
    b"000000_00000_00000_00000_00000_000110" ,--Xor $1 , $0 ,$0
    b"000110_00000_00010_00000_00000_000000" ,-- Lw $2 ,0($0)
    b"000110_00000_00011_00000_00000_000100", --Lw $3 , 4($0)
    b"000110_00000_00100_00000_00000_001000",--Lw $4,8($0)
    b"000000_00010_00000_00101_00000_000000",--Add $5 , $2 , $0
    b"000011_00001_00011_00000_00000_001101", --Beq $1 , $3 , 13 (21-7)
    b"000000_00000_00000_00000_00000_000000", -- NoOp
    b"000000_00000_00000_00000_00000_000000", -- NoOp
    b"000000_00000_00000_00000_00000_000000", -- NoOp
    b"000110_00101_00110_00000_00000_000000" ,--Lw $4 , 0($5)
    b"000000_00000_00000_00000_00000_000000", -- NoOp
    b"000000_00000_00000_00000_00000_000000", -- NoOp
    b"000101_00110_00100_00111_00000_000001" ,--Slt $7 ,$6 ,$4
    b"000000_00000_00000_00000_00000_000000", -- NoOp
    b"000000_00000_00000_00000_00000_000000", -- NoOp
    b"000011_00111_00000_00000_00000_000101" ,--Beq $7 , $0 ,5(23-17)
    b"000000_00000_00000_00000_00000_000000", -- NoOp
    b"000000_00000_00000_00000_00000_000000", -- NoOp
    b"000000_00000_00000_00000_00000_000000", -- NoOp
    b"000000_00000_00111_01000_00001_000010" ,--Srl $8 , $7 , 1
    b"001001_00000_00000_00000_00000_011011", --Jump 27
    b"000000_00000_00000_00000_00000_000000", -- NoOp
    b"000000_00000_00111_01001_00001_000011", --Sll $9 , $7 ,1
    b"000000_00000_00000_00000_00000_000000", -- NoOp
    b"000000_00000_00000_00000_00000_000000", -- NoOp
    b"000000_01001_00110_01000_00000_000000", --Add $8 , $9 , $6
    b"000001_00001_00001_00000_00000_000001", --Addi $1 ,$1 ,1
    b"000001_00101_00101_00000_00000_000100" ,--Addi $5 , $5 , 4
    b"001001_00000_00000_00000_00000_001101" , --Jump 6
    b"000000_00000_00000_00000_00000_000000", -- NoOp
-----------------------------------------      
    others => X"00000000");                     -- X"00000000", NOOP (SLL $0, $0, 0)
-----------------------------------------

signal PC : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal PCAux, NextAddr, AuxSgn : STD_LOGIC_VECTOR(31 downto 0);

begin

    -- Program Counter
    process(clk, rst)
    begin
        if rst = '1' then
            PC <= (others => '0');
        elsif rising_edge(clk) then
            if en = '1' then
                PC <= NextAddr;
            end if;
        end if;
    end process;

    -- Instruction OUT
    Instruction <= ROM(conv_integer(PC(6 downto 2)));

    -- PC + 4
    PCAux <= PC + 4;
    PCp4 <= PCAux;

    -- MUX for branch
    AuxSgn <= BranchAddress when PCSrc = '1' else PCAux;  
    
    -- MUX for jump
    NextAddr <= JumpAddress when Jump = '1' else AuxSgn;
    
end Behavioral;