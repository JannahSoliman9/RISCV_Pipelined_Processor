/*  * Module: decoder1x2.v  
* Project: milestone 2  
* Author: laila khashaba -lailakhashaba@aucegypt.edu
jannah soliman- jannahsoliman9@aucegypt.edu
* Description: decoder to be placed after the memory
*  
* Change history: 10/4/23 -  implemented the decoder

               
*  **********************************************************************/


module decoder1x2(input clk, input[31:0] a, output reg [31:0] instruction , output reg [31:0] data);
    
    always@(*) begin
    
    if (clk)begin instruction = a;
    //data=0;
    end
    else begin data = a;
    end
  
    end 
    
endmodule
