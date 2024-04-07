/*  * Module: CU.v  
* Project: milestone 2  
* Author: laila khashaba -lailakhashaba@aucegypt.edu
jannah soliman- jannahsoliman9@aucegypt.edu
* Description: control unit
*  
** Change history: 10/4/23 -  
 added support for R-type, I-type
 15/4 added support for branching 
 17/4 added support for auipc, lui
 20/4 added support for jal, jalR
 1/5/23 added support for division and mul 
               
*  **********************************************************************/
module CU(input [4:0]inst, input bit, output reg branch,
output reg memRead , output reg memToReg,
output reg [1:0] ALUOp, output reg memWrite,
output reg ALUSrc, output reg regWrite, output reg jal, output reg jalr, output reg auipc_lui, output reg fence,
output reg ebreak, output reg ecall);
always @(*)
begin
casex(inst)

5'b01100: begin // R-Type
branch = 1'b0;
memRead = 1'b0;
memToReg = 1'b0;
ALUOp = 2'b10;
memWrite = 1'b0;
ALUSrc = 1'b0;
regWrite = 1'b1;
jal= 1'b0;
jalr=1'b0;
auipc_lui =1'b0;
fence=1'b0;
ecall=1'b0;
ebreak=1'b0;
end
5'b00100:begin // I-Format
branch = 1'b0;
memRead = 1'b0;
memToReg = 1'b0;
ALUOp=2'b11;
memWrite = 1'b0;
ALUSrc=1'b1;
regWrite = 1'b1;
jal= 1'b0;
jalr=1'b0;
auipc_lui =1'b0;
fence=1'b0;
ecall=1'b0;
ebreak=1'b0;
end
5'b00000: begin// lw
branch = 1'b0;
memRead = 1'b1;
memToReg = 1'b1;
ALUOp = 2'b00;
memWrite = 1'b0;
ALUSrc = 1'b1;
regWrite = 1'b1;
jal= 1'b0;
jalr=1'b0;
auipc_lui =1'b0;
fence=1'b0;
ecall=1'b0;
ebreak=1'b0;
end
5'b01000: begin// store
branch = 1'b0;
memRead = 1'b0;
memToReg = 1'b0;
ALUOp = 2'b00;
memWrite = 1'b1;
ALUSrc = 1'b1;
regWrite = 1'b0;
jal= 1'b0;
jalr=1'b0;
auipc_lui =1'b0;
fence=1'b0;
ecall=1'b0;
ebreak=1'b0;
end
5'b11000: begin//branch
branch = 1'b1;
memRead = 1'b0;
memToReg =1'b0;
ALUOp = 2'b01;
memWrite = 1'b0;
ALUSrc = 1'b0;
regWrite = 1'b0;
jal= 1'b0;
jalr=1'b0;
auipc_lui =1'b0;
fence=1'b0;
ecall=1'b0;
ebreak=1'b0;
end
5'b11011: begin//jal
branch = 1'b0;
memRead = 1'b0;
memToReg =1'b0;
ALUOp = 2'b11; //add immediate op format
memWrite = 1'b0;
ALUSrc = 1'b0;
regWrite = 1'b1;
jal= 1'b1;
jalr=1'b0;
auipc_lui =1'b0;
fence=1'b0;
ecall=1'b0;
ebreak=1'b0;
end
5'b11001: begin//jalr
branch = 1'b0;
memRead = 1'b0;
memToReg =1'b0;
ALUOp = 2'b11; //add immediate op format
memWrite = 1'b0;
ALUSrc = 1'b1;
regWrite = 1'b1;
jal= 1'b0;
jalr=1'b1;
auipc_lui =1'b0;
fence=1'b0;
ecall=1'b0;
ebreak=1'b0;
end
5'b00101: begin//auipc
branch = 1'b0;
memRead = 1'b0;
memToReg =1'b1;
ALUOp = 2'b11; //add immediate op format
memWrite = 1'b0;
ALUSrc = 1'b0;
regWrite = 1'b1;
jal= 1'b0;
jalr=1'b0;
auipc_lui =1'b1;
fence=1'b0;
ecall=1'b0;
ebreak=1'b0;
end
5'b01101: begin//lui
branch = 1'b0;
memRead = 1'b0;
memToReg =1'b0;
ALUOp = 2'bx; //pass
memWrite = 1'b0;
ALUSrc = 1'b1;
regWrite = 1'b1;
jal= 1'b0;
jalr=1'b0;
auipc_lui =1'b0;
fence=1'b0;
ecall=1'b0;
ebreak=1'b0;
end
5'b00011: begin//fence jal x0,x0
branch = 1'b0;
memRead = 1'b0;
memToReg =1'b0;
ALUOp = 2'bx; //pass
memWrite = 1'b0;
ALUSrc = 1'b1;
regWrite = 1'b1;
jal= 1'b0;
jalr=1'b0;
auipc_lui =1'b0;
fence=1'b1;
ecall=1'b0;
ebreak=1'b0;
end
5'b11100: begin
if(bit==1'b0)// ecall
begin
branch = 1'b0;
memRead = 1'b0;
memToReg =1'b0;
ALUOp = 2'bx; //pass
memWrite = 1'b0;
ALUSrc = 1'b1;
regWrite = 1'b1;
jal= 1'b0;
jalr=1'b0;
auipc_lui =1'b0;
fence=1'b0;
ecall=1'b1;
ebreak=1'b0;
end
else if (bit ==1'b1)//ebreak
begin 
branch = 1'b0;
memRead = 1'b0;
memToReg =1'b0;
ALUOp = 2'bx; //pass
memWrite = 1'b0;
ALUSrc = 1'b1;
regWrite = 1'b1;
jal= 1'b0;
jalr=1'b0;
auipc_lui =1'b0;
fence=1'b0;
ecall=1'b0;
ebreak=1'b1;
end
end
default:
begin
branch = 1'b0;
memRead = 1'b0;
memToReg = 1'b0;
ALUOp = 2'b00;
memWrite = 1'b0;
ALUSrc = 1'b0;
regWrite = 1'b0;
fence=1'b0;
ecall=1'b0;
ebreak=1'b0;
end
endcase
end
endmodule
