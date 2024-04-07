`timescale 1ns / 1ps
/*  * Module: BCU.v  
* Project: milestone 2  
* Author: laila khashaba -lailakhashaba@aucegypt.edu
jannah soliman- jannahsoliman9@aucegypt.edu
* Description: BRANCH CONTROL UNIT - USED AS A SELCT FOR PC MUX
* Change history: 10/4/23 -  implemented bCU
28/4/23- added support for flushing

               
*  **********************************************************************/


module BCU(input ecall,input ebreak,input fence,input jal, input jalr,input controlSignal, input zf, input cf, input vf, 
input sf,input[2:0] func3, output reg [1:0]flag, output reg flushFlag
);
always @ (*)
 begin
 if (fence|ebreak|ecall)
 begin
 flag=2'b11;
 end
 
else if(jal==1'b1)
begin
flag=2'b01;
end

else if (jalr==1'b1) 
begin
flag=2'b10;
end

else if(func3==3'b000)
begin
flag = {1'b0,zf &controlSignal} ; //BEQ
end

else if(func3==3'b001) 
begin
flag ={1'b0, ~zf &controlSignal}; //BNE
end

else if(func3==3'b100)
begin
flag = {1'b0,(sf != vf)&controlSignal};//BLT
end

else if(func3==3'b101)
begin
flag = {1'b0,(sf == vf)&controlSignal};//BGE
end

else if(func3==3'b110)
begin
flag ={1'b0,~cf &controlSignal};//BLTU
end

else if(func3==3'b111)
begin
flag ={1'b0, cf &controlSignal};//BGEU
end
 
else
begin 
flag= 2'b00;
end
if (flag==2'b01 || flag==2'b11 || flag==2'b11)
flushFlag= 1'b1;
else 
flushFlag=1'b0; 
end
endmodule
