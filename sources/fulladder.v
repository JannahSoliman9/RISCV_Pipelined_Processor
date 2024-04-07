/*  * Module: CPU.v  
* Project: milestone 2  
* Author: laila khashaba -lailakhashaba@aucegypt.edu
jannah soliman- jannahsoliman9@aucegypt.edu
* Description: full adder 
*  
* Change history: 10/4/23 - added module



               
*  **********************************************************************/

module fulladder(
    input A,
    input B,
    input Cin,
    output cout,
    output sum
    );
    assign {cout,sum}=A+B+Cin;
endmodule
