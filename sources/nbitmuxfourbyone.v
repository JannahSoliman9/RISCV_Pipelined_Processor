`timescale 1ns / 1ps
/*  * Module: nbitmuxforbyone.v  
* Project: milestone 2  
* Author: laila khashaba -lailakhashaba@aucegypt.edu
jannah soliman- jannahsoliman9@aucegypt.edu
* Description: 4x1 mux
*  
* Change history: 10/4/23 - implementaion 
               
*  **********************************************************************/

module nbitmuxfourbyone #(parameter N=32)
(
input [N-1:0]A,
input [N-1:0]B,
input [N-1:0]C,
input [N-1:0]D,
input [1:0]S, 
output reg [N-1:0] out

 );
 always@(*)
 begin
case(S)
2'b00:
begin
out<=A;
end
2'b01:
begin
out<=B;
end
2'b10:
begin
out<=C;
end
2'b11:
out<=D;
default:
begin
out<=0;
end

endcase
end
endmodule
