/*  * Module: nbitReg.v  
* Project: milestone 2  
* Author: laila khashaba -lailakhashaba@aucegypt.edu
jannah soliman- jannahsoliman9@aucegypt.edu
* Description: nbit multiplexer 
*  
* Change history: 10/4/23 -  added module
               
*  **********************************************************************/
module nbitmux #(parameter N=32)
( 
input [N-1:0]A,
input [N-1:0]B,
input S, 
output [N-1:0]out

 );
 
 assign out = S? B:A;
 endmodule
