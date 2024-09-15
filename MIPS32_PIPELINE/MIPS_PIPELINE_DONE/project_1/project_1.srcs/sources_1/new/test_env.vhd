
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component MPG is
    Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

component SSD is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(7 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0));
end component;

component IFetch
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           BranchAddress : in STD_LOGIC_VECTOR(31 downto 0);
           JumpAddress : in STD_LOGIC_VECTOR(31 downto 0);
           Jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           Instruction : out STD_LOGIC_VECTOR(31 downto 0);
           PCp4 : out STD_LOGIC_VECTOR(31 downto 0));
end component;

component ID is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;    
           Instr : in STD_LOGIC_VECTOR(25 downto 0);
           WD : in STD_LOGIC_VECTOR(31 downto 0);
           RegWrite : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR(31 downto 0);
           RD2 : out STD_LOGIC_VECTOR(31 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR(31 downto 0);
           func : out STD_LOGIC_VECTOR(5 downto 0);
           sa : out STD_LOGIC_VECTOR(4 downto 0);
           rd : out std_logic_vector(4 downto 0);
           rt : out std_logic_vector(4 downto 0));
end component;

component UC
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
end component;

component EX is
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
end component;

component MEM
    port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           ALUResIn : in STD_LOGIC_VECTOR(31 downto 0);
           RD2 : in STD_LOGIC_VECTOR(31 downto 0);
           MemWrite : in STD_LOGIC;			
           MemData : out STD_LOGIC_VECTOR(31 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR(31 downto 0));
end component;

signal Instruction, PCp4, RD1, RD2, WD, Ext_imm : STD_LOGIC_VECTOR(31 downto 0); 
signal JumpAddress, BranchAddress, ALURes, ALURes1, MemData : STD_LOGIC_VECTOR(31 downto 0);
signal func : STD_LOGIC_VECTOR(5 downto 0);
signal sa : STD_LOGIC_VECTOR(4 downto 0);
signal zero : STD_LOGIC;
signal digits : STD_LOGIC_VECTOR(31 downto 0);
signal en, rst, PCSrc : STD_LOGIC; 
-- main controls 
signal RegDst, ExtOp, ALUSrc, Branch, Jump, MemWrite, MemtoReg, RegWrite : STD_LOGIC;
signal ALUOp : STD_LOGIC_VECTOR(2 downto 0);
--pipeline registers
signal rt,rd : std_logic_vector(4 downto 0);
signal instr_if_id : std_logic_vector(31 downto 0);
signal pc_4_if_id : std_logic_vector(31 downto 0);
signal reg_dst_id_ex : std_logic;
signal alu_src_id_ex : std_logic;
signal branch_id_ex : std_logic;
signal alu_op_id_ex : std_logic_vector(2 downto 0);
signal mem_write_id_ex : std_logic;
signal mem_To_Reg_id_ex : std_logic;
signal reg_write_id_ex : std_logic;
signal rd1_id_ex : std_logic_vector(31 downto 0);
signal rd2_id_ex : std_logic_vector(31 downto 0);
signal ext_imm_id_ex : std_logic_vector(31 downto 0) ;
signal func_id_ex : std_logic_vector(5 downto 0) ;
signal sa_id_ex : std_logic_vector(4 downto 0) ;
signal rd_id_ex : std_logic_vector(4 downto 0) ;
signal rt_id_ex : std_logic_vector(4 downto 0) ;
signal pc_4_id_ex : std_logic_vector(31 downto 0) ;
signal branch_ex_mem : std_logic;
signal mem_write_ex_mem : std_logic;
signal mem_to_Reg_ex_mem : std_logic;
signal reg_write_ex_mem : std_logic;
signal zero_ex_mem : std_logic := '0';
signal branch_address_ex_mem : std_logic_vector(31 downto 0);
signal alu_res_ex_mem : std_logic_vector(31 downto 0) ;
signal wa_ex_mem : std_logic_vector(4 downto 0);
signal rd2_ex_mem : std_logic_vector(31 downto 0) ;
signal mem_to_reg_mem_wb : std_logic;
signal reg_write_mem_wb : std_logic ;
signal alu_res_mem_wb : std_logic_vector(31 downto 0);
signal mem_data_mem_wb : std_logic_vector(31 downto 0) ;
signal wa_mem_wb : std_logic_vector(4 downto 0) ;
signal wa : std_logic_vector(4 downto 0);

begin

    monopulse : MPG port map(en, btn(0), clk);
    
    -- main units
    inst_IFetch : IFetch port map(clk, btn(1), en, Branch_Address_EX_MEM, JumpAddress, Jump, PCSrc, Instruction, PCp4);
    inst_ID : ID port map(clk, en, Instr_IF_ID(25 downto 0), WD, Reg_Write_MEM_WB, ExtOp, RD1, RD2, Ext_imm, func, sa,RD,RT);
    inst_UC : UC port map(Instr_IF_ID(31 downto 26), RegDst, ExtOp, ALUSrc, Branch, Jump, ALUOp, MemWrite, MemtoReg, RegWrite);
    inst_EX : EX port map(PC_4_ID_EX, RD1_ID_EX, RD2_ID_EX, Ext_imm_ID_EX, func_ID_EX, sa_ID_EX, ALU_Src_ID_EX, ALU_Op_ID_EX, BranchAddress, ALURes, Zero,REG_DST_ID_EX,RD_ID_EX,RT_ID_EX,WA); 
    inst_MEM : MEM port map(clk, en, ALU_Res_EX_MEM, RD2_EX_MEM, Mem_Write_EX_MEM, MemData, ALURes1);

    --pipeline 
    process(CLK)
begin
    if rising_edge(clk) then
        if en = '1' then
        -- IF_ID
            instr_if_id <= Instruction;
            pc_4_if_id <= pcp4;
        -- ID_EX
            reg_dst_id_ex <= regdst;
            alu_src_id_ex <= alusrc;
            branch_id_ex <= branch;
            alu_op_id_ex <= aluop;
            mem_write_id_ex <= memwrite;
            mem_to_reg_id_ex <= memtoreg;
            reg_write_id_ex <= regwrite;
            rd1_id_ex <= rd1;
            rd2_id_ex <= rd2;
            ext_imm_id_ex <= ext_imm;
            func_id_ex <= func;
            sa_id_ex <= sa;
            rd_id_ex <= rd;
            rt_id_ex <= rt;
            pc_4_id_ex <= pc_4_if_id;
        -- EX_MEM
            branch_ex_mem <= branch_id_ex;
            mem_write_ex_mem <= mem_write_id_ex;
            mem_to_reg_ex_mem <= mem_to_reg_id_ex;
            reg_write_ex_mem <= reg_write_id_ex;
            zero_ex_mem <= zero;
            branch_address_ex_mem <= branchaddress;
            alu_res_ex_mem <= alures;
            wa_ex_mem <= wa;
            rd2_ex_mem <= rd2_id_ex;
        -- MEM_WB
            mem_to_reg_mem_wb <= mem_to_reg_ex_mem;
            reg_write_mem_wb <= reg_write_ex_mem;
            alu_res_mem_wb <= alures1;
            mem_data_mem_wb <= memdata;
            wa_mem_wb <= wa_ex_mem;
        end if;
    end if;
end process;

    -- WB
    WD <= Mem_Data_MEM_WB when Mem_to_Reg_MEM_WB = '1' else ALU_Res_MEM_WB; 

    -- Branch Control
    PCSrc <= Zero_EX_MEM and Branch_EX_MEM;

    -- Jump Address
    JumpAddress <= PC_4_IF_ID(31 downto 28) & Instr_IF_ID(25 downto 0) & "00";

   -- SSD MUX
    with sw(7 downto 5) select
        digits <=  Instruction when "000", 
                   PCp4 when "001",
                   RD1 when "010",
                   RD2 when "011",
                   Ext_Imm when "100",
                   ALURes when "101",
                   MemData when "110",
                   WD when "111",
                   (others => 'X') when others; 

    display : SSD port map(clk, digits, an, cat);
    
    --leds
    led(10 downto 0) <= ALUOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemtoReg & RegWrite;
    
end Behavioral;