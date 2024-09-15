library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
entity MAIN is
  Port ( clk : in std_logic ;
         sw : in std_logic_vector(15 downto 0); 
         an : out std_logic_vector(3 downto 0);
         cat : out std_logic_vector(6 downto 0);
         button : in std_logic_vector(4 downto 0 );
         led :out std_logic_vector(15 downto 0 )
         );
end MAIN;

architecture Behavioral of MAIN is

signal numberToPrint : std_logic_vector(31 downto 0) := x"00000000";
signal enMPG : std_logic ; 
signal myButton0 : std_logic := '0' ; 

signal instructionOut : std_logic_vector(31 downto 0):= x"00000000" ; 
signal programCounter : std_logic_vector(31 downto 0 ); 

signal jumpAddress : std_logic_vector(31 downto 0) := x"00000000" ; 
signal branchAddress : std_logic_vector(31 downto 0):=  x"00000000"  ; 

signal RegDst : std_logic := '0' ;
signal ExtOp : std_logic := '0' ; 
signal ALUSrc : std_logic := '0' ; 
signal Branch : std_logic := '0'; 
signal Jump : std_logic := '0';
signal ALUOp : std_logic_vector(2 downto 0) := "000" ;
signal MemWrite : std_logic := '0'; 
signal MemToReg : std_logic := '0' ; 
signal RegWrite : std_logic := '0'; 

signal RD1 : std_logic_vector(31 downto 0) := x"00000000";
signal RD2 : std_logic_vector(31 downto 0) := x"00000000";
signal ExtImm : std_logic_vector(31 downto 0) := x"00000000";
signal func : std_logic_vector(5 downto 0) := "000000";
signal sa : std_logic_vector(4 downto 0) := "00000";
signal WD : std_logic_vector(31 downto 0) := x"00000000";

signal ALURes : std_logic_vector(31 downto 0) := x"00000000";

signal ALUResOut : std_logic_vector(31 downto 0) := x"00000000";
signal MemData : std_logic_vector(31 downto 0) := x"00000000";
signal mux : std_logic_vector(31 downto 0) := x"00000000";
signal Zero : std_logic := '0';
signal PCSrc : std_logic := '0';

signal INSTR : std_logic_vector(25 downto 0);

begin

led(8) <= RegDst ; 
-- vezi schimba led ul 7 si 12 ca francesco are Bayses de la second 
led(6 downto 0) <= ExtOp & ALUsrc & Branch & Jump & MemWrite & MemToReg & RegWrite ;
led(15 downto 13) <= ALUOp ; 

MPG_1 : entity work.MPG1 port map(
    enable => enMPG  , btn => button(0) , clk => clk  );
           

SSD1 : entity work.SSD port map(
    clk => clk , sw32 => sw(0) , input => numberToPrint , an => an , cat => cat 
);

IF1 : entity work.IFetch port map(
    clk => clk, 
    en => enMPG  , 
    rst => button(1) , 
    BranchAddress => x"00000010" , 
    JumpAddress => x"00000000" , 
    PCSrc => sw(1) , 
    Jump =>sw(2) , 
    Instruction =>instructionOut , 
    PC4 => programCounter 
   );
    
ID1 :  entity work.ID port map( 
         RegWrite => RegWrite ,
         Instruction => instructionOut(25 downto 0) ,
         RegDst => RegDst ,
         EN => myButton0 ,
         WD => WD ,
         ExtOp => ExtOp ,
         RD1 => RD1 ,
         RD2 => RD2 ,
         Ext_Imm => ExtImm ,
         func => func , 
         sa => sa ,
         clk => clk  
  );
UC1 :  entity work.UC port map(
        opcode => instructionOut(31 downto 26) ,
        RegDst => RegDst ,
        ExtOp => ExtOp ,
        ALUSrc => ALUSrc ,
        Branch => Branch ,
        Jump => Jump ,
        ALUOp => ALUOp ,
        MemWrite => MemWrite ,
        MemToReg => MemToReg,
        RegWrite => RegWrite 
   );
   
MEM1 : entity work.MEM port map(
        MemWrite => MemWrite ,
        ALUResIn => ALURes ,
        RD2 => RD2 ,
        MemData => MemData ,
        CLK => clk,
        EN => myButton0,
        ALUResOut => ALUResOut 
        );
        
        process(sw(4 downto 2))
        begin
            case sw(4 downto 2) is
                when "000" => numberToPrint <= instructionOut;
                when "001" => numberToPrint <= programCounter;
                when "010" => numberToPrint <= RD1;
                when "011" => numberToPrint <= RD2;
                when "100" => numberToPrint <= ExtImm;
                when "101" => numberToPrint <= ALURes;
                when "110" => numberToPrint <= MemData;
                when others => numberToPrint <= mux ;
            end case ;
        end process;
        
        JumpAddress <= programCounter(31 downto 28) & instructionOut(25 downto 0) & "00";
        pcSrc <= branch and zero;
        INSTR <= instructionOut(25 downto 0);

EX1 : entity work.EX port map( 
        RD1 => RD1, 
        ALUSrc=> ALUSrc , 
        RD2 => RD2 , 
        Ext_Imm =>ExtImm , 
        sa => sa , 
        func=> func, 
        ALUOp=>ALUOp , 
        PC4=>programCounter , 
        Zero=>Zero , 
        ALURes =>ALURes , 
        BranchAddress => BranchAddress 
        );
end Behavioral;