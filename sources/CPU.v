/*  * Module: CPU.v  
* Project: milestone 2  
* Author: laila khashaba -lailakhashaba@aucegypt.edu
jannah soliman- jannahsoliman9@aucegypt.edu
* Description: top module  
*  
* Change history: 10/4/23 -  supported R type 
10/4/23 -supported immediate type
12/4/23 -supported branching
15/4/23 - supported auipc lui jal and jalr 
18/4/23- implemented pipeline
19/4/23- implemented a single memory
20/4/23 - implemented forwarding unit
28/4/23- implemented flushing 
30/4- added support for multiplication


               
*  **********************************************************************/
module CPU(input clk,input rst,input SSDclk, input [3:0]SSDsel, input [1:0]LEDSelect, output reg [15:0] LEDout, output [3:0] Anode, 
 output [6:0] SSDLED_out );
 
wire [31:0] noop;
assign noop= 32'b0000000_00000_00000_000_00000_0110011; 
wire [31:0] newInst;
wire flushFlag;
nbitmux #(.N(32)) flushMUX(.A(inst),.B(noop), .S(flushFlag), .out(newInst));


// program counter inputs and outputs
wire [31:0] newPC;
wire [31:0] PC_out;
wire [31:0] inst;



wire [31:0] ecallorbreakMUXout;

nbitmux #(.N(32)) ecallorbreak(.A(EXMEM_pc), 
.B(32'b0), .S(EXMEM_ctrl[8]|EXMEM_ctrl[10]), .out(ecallorbreakMUXout));

nbitmuxfourbyone#(.N(32)) PC_MUX(.A(pcAdder_out),.B(branchAdder_out),
.C(EXMEM_ALUout),.D(ecallorbreakMUXout),.S(branchAnd_out),.out(newPC));
 
nbitRCA #(.N(32)) PCAdder(.A(PC_out), .B(32'd4), .out(pcAdder_out), .cin(1'b0));



nbitReg #(.N(32)) PC(.clk(!clk), .rst(rst), .load(1'b1), .data((newPC)), .Q(PC_out));




wire [4:0] read1;
wire [4:0] read2;
wire [4:0] writeReg;
wire [31:0] readData1;
wire [31:0] readData2;
wire [31:0] writeData;
// instruction memory 
//instMem instMem(.addr({PC_out}), .data_out(inst));

wire [31:0] IFID_pc;
wire [31:0] IFID_inst;
wire [31:0] IFID_pc4;

nbitReg #(.N(96)) IF_ID(.clk(~clk), .rst(rst), .load(1'b1), .data(({pcAdder_out,PC_out,newInst})), .Q({IFID_pc4,IFID_pc,IFID_inst}));

regfile  regFile(.clk(~clk), .rst(rst), .read1(IFID_inst[19:15]), .read2(IFID_inst[24:20]), .writeReg(MEMWB_rd), 
.writeData(writeData), .write(MEMWB_regwrite), .readData1(readData1), .readData2(readData2));
//reg file inputs and outputs




wire [4:0] shamt;

nbitmux #(.N(5)) shamtMux(.A(IFID_inst[24:20]), 
.B(readData2[4:0]), .S(IFID_inst[5]), .out(shamt));

//control unit
//outputs
wire [1:0] ALUOp;
wire  ALUSrc;
wire memToReg;
wire memRead;
wire memWrite;
wire regWrite;
wire branch;
wire jal;
wire jalr;
wire auipc_lui;
wire ecall;
wire ebreak;
wire fence;

wire [13:0] ControlMUXout;
nbitmux #(.N(14)) ControlMUX (.A({ecall,ebreak,fence,jalr,jal,auipc_lui,branch,memRead,memToReg,ALUOp,memWrite,ALUSrc,regWrite}),
 .B(13'b0),.S(flushFlag),.out(ControlMUXout));


CU CU(.inst(IFID_inst[6:2]),.branch(branch),
.memRead(memRead), .memToReg(memToReg), .ALUOp(ALUOp),
.memWrite(memWrite), .ALUSrc(ALUSrc), 
.regWrite(regWrite), .auipc_lui(auipc_lui),.jal(jal),.jalr(jalr),
.ebreak(ebreak),.ecall(ecall),.fence(fence),.bit(IFID_inst[20]));

//immGen inputs and outputs
wire [31:0] immGen_out;
immGen immGen(.Imm(immGen_out), .IR(IFID_inst));
wire [3:0] IDEX_func;
wire [4:0] IDEX_rs1;
wire [4:0] IDEX_rs2;
wire [4:0] IDEX_rd;
wire [13:0] IDEX_Ctrl;
wire[4:0] IDEX_shamt;
wire[31:0] IDEX_pc;
wire [31:0] IDEX_pc4;
wire [31:0] IDEX_RegR1;
wire [31:0] IDEX_RegR2;
wire[31:0] IDEX_Imm;
wire IDEXmulbit;



nbitReg #(.N(199)) ID_EX(.clk(clk), .rst(flushFlag|rst), .load(1'b1), 
.data({ControlMUXout, IFID_pc,readData1,readData2,immGen_out,IFID_inst[30],
IFID_inst[14:12],IFID_inst[19:15],IFID_inst[24:20],
IFID_inst[11:7],shamt,IFID_pc4,IFID_inst[25]}),
 .Q({IDEX_Ctrl,IDEX_pc, IDEX_RegR1,IDEX_RegR2,
 IDEX_Imm,IDEX_func,IDEX_rs1,IDEX_rs2,IDEX_rd,IDEX_shamt,IDEX_pc4,IDEXmulbit}));

//forwarding unit 
wire forwardA;
wire forwardB;

forwardingunit FU(.ID_EX_RegisterRs1(IDEX_rs1),.ID_EX_RegisterRs2(IDEX_rs2),
.MEMWB_rd(MEMWB_rd),.MEM_WB_RegWrite(MEMWB_regwrite),.forwardA(forwardA),.forwardB(forwardB));
wire [31:0] ALUMUX1;
wire [31:0] ALUMUX2;
//Forwarding MUX 
nbitmux #(.N(32)) ALU_MUX1(.A(IDEX_RegR1), 
.B(writeData), .S(forwardA), .out(ALUMUX1));

nbitmux #(.N(32)) ALU_MUX2(.A(IDEX_RegR2), 
.B(writeData), .S(forwardB), .out(ALUMUX2));

//ALU MUX 
wire [31:0] ALUinput2;
nbitmux #(.N(32)) ALU_MUX(.A(ALUMUX2), 
.B(IDEX_Imm), .S(IDEX_Ctrl[1]), .out(ALUinput2));
//ALU control unit
wire [4:0] ALUsel;
ALUCU ALUCU(.ALUOp(IDEX_Ctrl[4:3]), .inst1(IDEX_func[2:0]), 
.inst2(IDEX_func[3]),.mulbit(IDEXmulbit),.ALUsel(ALUsel));
//ALU inputs and outputs
wire zeroflag;
wire cf;
wire vf;
wire sf;
wire [31:0] ALUout;

ALU  ALU (.a(ALUMUX1),
 .b(ALUinput2), .shamt(IDEX_shamt),
.alufn(ALUsel), .r(ALUout), .zf(zeroflag),.cf(cf),.vf(vf),.sf(sf));

wire signed [31:0] branchAdder_out;
nbitRCA #(.N(32)) branchAdder(.A(EXMEM_pc), .B(EXMEM_Imm), .out(branchAdder_out), .cin(1'b0));
wire EXMEM_zeroflag;
wire EXMEM_cf;
wire EXMEM_vf;
wire EXMEM_sf;
wire [31:0] EXMEM_ALUout;
wire [10:0] EXMEM_ctrl;
wire [31:0] EXMEM_RegR2;
wire [4:0] EXMEM_rd;
wire [2:0] EXMEM_func;
wire [31:0] EXMEM_pc;
wire [31:0] EXMEM_pc4;
wire [31:0] EXMEM_Imm;


//EXMEM 
nbitReg #(.N(183))EX_MEM(.clk(!clk), .rst(rst), .load(1'b1),.data({IDEX_Ctrl[13:5],IDEX_Ctrl[2],
IDEX_Ctrl[0],zeroflag,cf,vf,sf,ALUout, ALUMUX2,IDEX_rd,IDEX_func[2:0],IDEX_pc,IDEX_pc4,IDEX_Imm}),
 .Q({EXMEM_ctrl,EXMEM_zeroflag,EXMEM_cf,EXMEM_vf,EXMEM_sf,EXMEM_ALUout,EXMEM_RegR2,EXMEM_rd,EXMEM_func,EXMEM_pc,EXMEM_pc4,EXMEM_Imm}));




// branch control unit 
wire [1:0] branchAnd_out;
BCU BCU(.ecall(EXMEM_ctrl[10]),.ebreak(EXMEM_ctrl[9]),.fence(EXMEM_ctrl[8]),.jal(EXMEM_ctrl[6]),
.jalr(EXMEM_ctrl[7]),.controlSignal(EXMEM_ctrl[4]),
.zf(EXMEM_zeroflag), .cf(EXMEM_cf), .vf(EXMEM_vf), .sf(EXMEM_sf), 
.func3(EXMEM_func), .flag(branchAnd_out),.flushFlag(flushFlag));
//Data Mem inputs and outputs
wire [68:0] singleMemInput;
nbitmux #(.N(69)) singleMemMux(.A({PC_out,3'b010,32'b0,1'b1,1'b0}), 
.B({EXMEM_ALUout,EXMEM_func,EXMEM_RegR2,EXMEM_ctrl[3],EXMEM_ctrl[1]}), .S(!clk), .out(singleMemInput));


wire [31:0] dataMem_out;
dataMem dataMem(.clk(clk),.addr(singleMemInput[68:37]), .func3(singleMemInput[36:34]),
 .data_in(singleMemInput[33:2]), 
 .data_out(dataMem_out), 
  .MemRead(singleMemInput[1]), .MemWrite(singleMemInput[0]));
  wire [31:0] decoderdata;
  decoder1x2 decoder(.clk(clk), .a(dataMem_out) ,.instruction(inst) ,.data(decoderdata));
    
  
 //MEMWB  
wire MEMWB_ecall;
wire MEMWB_ebreak;
wire MEMWB_fence;
wire MEMWB_jalr;
wire MEMWB_jal;
wire MEMWB_auipc_lui;
wire MEMWB_memToreg;
wire MEMWB_regwrite;
      
 wire [4:0] MEMWB_rd;
 wire [31:0] MEMWB_pc;
 wire [31:0] MEMWB_pc4;
 wire [31:0] MEMWB_BranchAdder_out;
 wire [31:0] MEMWB_ALUout;
 wire [1:0]  MEMWB_branchandout;
 wire [31:0] MEMWB_dataMemOut;
 wire [7:0] MEMWB_ctrl;


nbitReg #(.N(175)) MEM_WB(.clk(clk), .rst(rst), .load(1'b1), .data({EXMEM_ctrl[10:5],
EXMEM_ctrl[2],EXMEM_ctrl[0],decoderdata,EXMEM_rd,EXMEM_ALUout,branchAdder_out,EXMEM_pc,EXMEM_pc4,branchAnd_out}),
.Q({MEMWB_ecall,MEMWB_ebreak,MEMWB_fence,MEMWB_jalr,MEMWB_jal,
MEMWB_auipc_lui,MEMWB_memToreg,MEMWB_regwrite,MEMWB_dataMemOut,MEMWB_rd,MEMWB_ALUout,MEMWB_BranchAdder_out,MEMWB_pc,MEMWB_pc4,MEMWB_branchandout}));
 
 
//MUX for data mem output
wire [31:0] dataMuxOut;
nbitmux #(.N(32)) dataMem_MUX(.A(MEMWB_ALUout),
.B( MEMWB_dataMemOut),
.S(MEMWB_memToreg),.out(dataMuxOut ));
wire signed [31:0] pcAdder_out;



nbitmuxfourbyone#(.N(32)) writeDataMUX(.A(dataMuxOut),.B(MEMWB_BranchAdder_out),
.C(MEMWB_pc4),.D(32'b0),.S({(MEMWB_jalr| MEMWB_jal),MEMWB_auipc_lui /*EXMEM_ctrl[5]*/}),.out(writeData));
 
 



//FPGA
//FPGA

always @(*)
begin
if(LEDSelect==2'b00)
LEDout=newInst[15:0];
else if(LEDSelect==2'b01)
LEDout=newInst[31:16];
else if(LEDSelect==2'b10)
LEDout={2'b0,ecall,ebreak,fence,jalr,jal,auipc_lui,branch,memRead,memToReg,ALUOp,memWrite,ALUSrc,regWrite};
else LEDout=16'hxxxx;
end
reg [12:0] SSDout;
always @(*)
begin
case(SSDsel)
4'b0000: SSDout= PC_out[12:0];
4'b0001: SSDout= pcAdder_out[12:0];
4'b0010: SSDout= branchAdder_out[12:0];
4'b0011: SSDout= newPC[12:0];
4'b0100: SSDout= IDEX_RegR1[12:0];
4'b0101: SSDout= IDEX_RegR2[12:0];
4'b0110: SSDout= writeData[12:0];
4'b0111: SSDout= IDEX_Imm[12:0];  
4'b1000: SSDout= IDEX_Imm[12:0];
4'b1001: SSDout= ALUinput2[12:0];
4'b1010: SSDout= MEMWB_ALUout[12:0];
4'b1011: SSDout= MEMWB_dataMemOut[12:0];
4'b1100: SSDout= MEMWB_rd[4:0];
default :SSDout =0;
endcase
end
//7segment 
 Four_Digit_Seven_Segment_Driver f
(.clk(SSDclk), 
.SW(SSDout), 
 .Anode(Anode), 
 .LED_out(SSDLED_out) 
 ); 
endmodule
