/*  * Module: nbitReg.v  
* Project: milestone 2  
* Author: laila khashaba -lailakhashaba@aucegypt.edu
jannah soliman- jannahsoliman9@aucegypt.edu
* Description: top module  
*  
* Change history: 10/4/23 - added module 
               
*  **********************************************************************/
module nbitReg#(parameter N=32)(input clk,
input rst,input load, input [N-1:0] data, output reg [N-1:0] Q

    );
    always @(posedge clk or posedge rst)
    begin
    if(rst==1'b1)begin
    Q<= 'b0;end
    else if(load==1'b1)
    begin
    Q<=data;
end
    end
endmodule
