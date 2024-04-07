/*  * Module: regfile.v  
* Project: milestone 2  
* Author: laila khashaba -lailakhashaba@aucegypt.edu
jannah soliman- jannahsoliman9@aucegypt.edu
* Description: register file
*  
* Change history: 10/4/23 -  added module
               
*  **********************************************************************/
module regfile #(parameter N=32)(input clk, input rst, input [4:0]read1,
input [4:0]read2, input [4:0]writeReg, input [N-1:0]writeData, input write,
output [N-1:0] readData1, output [N-1:0] readData2

    );
    reg [N-1:0] Regfile[31:0];
    integer i;
    assign readData1=Regfile[read1];
    assign readData2=Regfile[read2];
    
    always @(posedge clk,posedge rst)
    begin 
    if (rst==1'b1)begin 
    for(i=0;i<N;i=i+1)
    Regfile[i]='b0;
    end
    
    else if (write==1'b1)
    if(writeReg==0)
        Regfile[writeReg]=0;
        else
    Regfile[writeReg]=writeData;
    
    end 
endmodule
