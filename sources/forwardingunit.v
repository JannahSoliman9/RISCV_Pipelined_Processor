`timescale 1ns / 1ps
/*  * Module: nbitmuxforbyone.v  
* Project: forwarding unit 
* Author: laila khashaba -lailakhashaba@aucegypt.edu
jannah soliman- jannahsoliman9@aucegypt.edu
* Description: 4x1 mux
*  
20/4/23 - implemented forwarding unit
               
*  **********************************************************************/


module forwardingunit
(
input [4:0] ID_EX_RegisterRs1,
  input [4:0] ID_EX_RegisterRs2,
  input [4:0] MEMWB_rd,
  input MEM_WB_RegWrite,
  output reg forwardA,
  output reg forwardB);


always @(*)
begin
  // MEM hazard (Fwd from MEM/WB pipeline reg)
  if (MEM_WB_RegWrite && (MEMWB_rd != 0) && (MEMWB_rd == ID_EX_RegisterRs1))
    forwardA = 1'b1;
  else
    forwardA = 1'b0;
  if (MEM_WB_RegWrite && (MEMWB_rd != 0) && (MEMWB_rd == ID_EX_RegisterRs2))
    forwardB = 1'b1;
  else
    forwardB = 1'b0;  
end
endmodule

