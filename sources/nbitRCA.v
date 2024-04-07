/*  * Module: nbitRCA.v  
* Project: milestone 2  
* Author: laila khashaba -lailakhashaba@aucegypt.edu
jannah soliman- jannahsoliman9@aucegypt.edu
* Description: n-BIT RIPPLE CARRY ADDER
*  
* Change history: 10/4/23 -  added module
               
*  **********************************************************************/
module  nbitRCA #(parameter N=32)(
    input [N-1:0]A,
    input [N-1:0]B,
    input cin,
    output [N-1:0]out
    );
    wire [N:0]w;
    assign w[0]=cin;
    genvar i;
    generate 
    for(i=0;i<N;i=i+1)
    begin
    fulladder u0(A[i],B[i],w[i],w[i+1],out[i]);
    end
    endgenerate
    
    assign out[N]=w[N];
    
endmodule
