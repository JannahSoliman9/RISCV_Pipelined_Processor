`include "defines.v"
/*  * Module: ALU.v  
* Project: milestone 2  
* Author: laila khashaba -lailakhashaba@aucegypt.edu
jannah soliman- jannahsoliman9@aucegypt.edu
* Description: ALU 
*  
* Change history: 10/4/23 -  added to project
1/5/23- added support for multiplication and division

               
*  **********************************************************************/
module ALU(
	input  wire  [31:0] a, b,
	input   wire [4:0]  shamt,
	output  reg  [31:0] r,
	output  wire        cf, zf, vf, sf,
	input   wire [4:0]  alufn
);

    wire [31:0] add, sub, op_b;
    wire cfa, cfs;
    reg  [63:0] mulresult;
    assign op_b = (~b);
    
    assign {cf, add} = alufn[0] ? (a + op_b + 1'b1) : (a + b);
    
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf);
    
    wire[31:0] sh;
   shifter shifter0(.a(a), .shamt(shamt), .type(alufn[1:0]),  .r(sh));
    
    always @ * begin
        r = 0;
        (* parallel_case *)
        case (alufn)
            // arithmetic
            5'b000_00 : r = add;
            5'b000_01 : r = add;
            5'b000_11 : r = b;
            // logic
            5'b001_00:  r = a | b;
            5'b001_01:  r = a & b;
            5'b001_11:  r = a ^ b;
            // shift
            5'b010_00:  r=sh;
            5'b010_01:  r=sh;
            5'b010_10:  r=sh;
            // slt & sltu
            5'b011_01:  r = {31'b0,(sf != vf)}; 
            5'b011_11:  r = {31'b0,(~cf)}; 
            //mul 
            5'b10000: r= $signed(a)* $signed(b); 
            5'b10001: 
            begin
            mulresult =  $signed(a)* $signed(b);
            r = mulresult[63:32]; 
             end
            5'b10010: begin mulresult=  $signed(a)* b; r=mulresult[63:32]; end
            5'b10011: begin mulresult=  a*b; r=mulresult[63:32]; end
            
            //DIV 
            5'b10100: r= $signed(a)/ $signed(b); 
            5'b10101: r= a/b;
            5'b10110: r= $signed(a)% $signed(b);
            5'b10111: r= a%b; 
            
                       	
        endcase
    end
endmodule
