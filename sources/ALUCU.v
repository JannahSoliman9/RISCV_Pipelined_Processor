`include "defines.v"
/*  * Module: ALUCU.v  
* Project: milestone 2  
* Author: laila khashaba -lailakhashaba@aucegypt.edu
jannah soliman- jannahsoliman9@aucegypt.edu
* Description: ALU conrol unit
*  
* Change history: 10/4/23 -  
 added support for R-type, I-type
 15/4 added support for branching 
 17/4 added support for auipc, lui
 20/4 added support for jal, jalR
 1/5/23 added support for division and mul
               
*  **********************************************************************/
module ALUCU( input [1:0] ALUOp, input [2:0] inst1,
 input inst2, input mulbit, output reg [4:0] ALUsel);
always @(*)
begin
  if(ALUOp == 2'b00)
  begin
    ALUsel = 5'b00000; //ADD
  end
  else if(ALUOp == 2'b01)//branch
    begin
        ALUsel = 5'b00001; //SUB  
    end
     else if((ALUOp == 2'b10 |ALUOp == 2'b11)   && inst1 == `F3_ADD && inst2 == 1'b0 && mulbit==1'b0)
    begin
        ALUsel = 5'b00000; //add and addI
    end
     else if(ALUOp == 2'b10 && inst1 == `F3_ADD && inst2 == 1'b1 && mulbit==1'b0 )
    begin
        ALUsel = 5'b00001; //SUB 
    end
        else if((ALUOp == 2'b10 |ALUOp == 2'b11) && inst1 == `F3_SLL && inst2 == 1'b0 && mulbit==1'b0 )
    begin
        ALUsel = 5'b01001; // SLL and slli 
    end
    else if((ALUOp == 2'b10 |ALUOp == 2'b11) && inst1 == `F3_SLT && inst2 == 1'b0 && mulbit==1'b0)
    begin
        ALUsel = 5'b01101; //Slt and slti 
    end
     else if((ALUOp == 2'b10 |ALUOp == 2'b11) && inst1 ==  `F3_SLTU && inst2 == 1'b0 && mulbit==1'b0)
    begin
        ALUsel = 5'b01111; //sltu and sltiu 
    end
     else if((ALUOp == 2'b10 |ALUOp == 2'b11) && inst1 == `F3_XOR  && inst2 == 1'b0)
    begin
        ALUsel = 5'b00111; //xOR and xori 
    end
      else if((ALUOp == 2'b10 |ALUOp == 2'b11) && inst1 == `F3_SRL && inst2 == 1'b0 && mulbit==1'b0)
    begin
        ALUsel = 5'b01000; // SRL and srli 
    end
      else if((ALUOp == 2'b10 |ALUOp == 2'b11) && inst1 ==  `F3_SRL && inst2 == 1'b1 && mulbit==1'b0)
    begin
        ALUsel = 5'b01010; //SRA and srai 
    end
     else if((ALUOp == 2'b10 |ALUOp == 2'b11) && inst1 == `F3_OR && inst2 == 1'b0 && mulbit==1'b0)
    begin
        ALUsel = 5'b00100; //or and ori 
    end
    else if((ALUOp == 2'b10 |ALUOp == 2'b11) && inst1 == `F3_AND && inst2 == 1'b0 && mulbit==1'b0)
    begin
        ALUsel = 5'b00101; //AND and addi 
    end
    else if(ALUOp == 2'b10 && inst1 == `F3_MUL && inst2 == 1'b0 && mulbit==1'b1)
    begin
        ALUsel = 5'b10000; //MUL
    end
     else if(ALUOp == 2'b10 && inst1 == `F3_MULH && inst2 == 1'b0 && mulbit==1'b1)
    begin
        ALUsel = 5'b10001; //MULH
    end
    else if(ALUOp == 2'b10 && inst1 == `F3_MULHSU && inst2 == 1'b0 && mulbit==1'b1)
    begin
        ALUsel = 5'b10010; //MULHSU
    end
    else if(ALUOp == 2'b10 && inst1 == `F3_MULHU && inst2 == 1'b0 && mulbit==1'b1)
    begin
        ALUsel = 5'b10011; //MULHU
    end
    else if(ALUOp == 2'b10 && inst1 == `F3_DIV && inst2 == 1'b0 && mulbit==1'b1)
    begin
        ALUsel = 5'b10100; //DIV
    end
    else if(ALUOp == 2'b10 && inst1 == `F3_DIVU && inst2 == 1'b0 && mulbit==1'b1)
    begin
        ALUsel = 5'b10101; //DIVU
    end
    else if(ALUOp == 2'b10 && inst1 == `F3_REM && inst2 == 1'b0 && mulbit==1'b1)
    begin
        ALUsel = 5'b10110; //REM
    end
   else if(ALUOp == 2'b10 && inst1 == `F3_REMU && inst2 == 1'b0 && mulbit==1'b1)
    begin
        ALUsel = 5'b10111; //REMU
    end
       
    //LUI
    else 
    begin
        ALUsel = 5'b00011;// Pass
    
    end
   
  

  
    
  
end
endmodule
