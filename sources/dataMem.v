/*  * Module: dataMem.v  
* Project: milestone 2  
* Author: laila khashaba -lailakhashaba@aucegypt.edu
jannah soliman- jannahsoliman9@aucegypt.edu
* Description: data memory 
*  
* Change history: 10/4/23 -  implemeneted word adressable data memory 
15/4 implemented a byte adressable memory 
25/4 implemented a single memory for both instructions and data

               
*  **********************************************************************/
module dataMem (input clk, input MemRead, input MemWrite,
 input [31:0] addr, input[2:0] func3, input [31:0] data_in, output reg [31:0] data_out);
 
// reg [7:0] mem[0:255];
reg [7:0] mem[0:255];
always @(*)
begin 
    if (MemRead)
    begin 
        case(func3)
            3'b000: data_out = $signed(mem[addr]);//lb sign extend
            3'b001: data_out = $signed({mem[addr],mem[addr+1]});//lh sign extend
            3'b010: data_out = {mem[addr],mem[addr+1],mem[addr+2],mem[addr+3]};//lw
            3'b100: data_out = $unsigned(mem[addr+3]);//lbu
            3'b101: data_out = $unsigned({mem[addr+2],mem[addr+3]});//lhu
        endcase
    end
        else
        data_out=32'hZZZZZZZZ;
end
 always @ (posedge clk)
    begin
        if (MemWrite)
        begin
            case(func3)
              3'b000://lb
              begin
              mem[addr]=data_in[7:0];
              end
              3'b001:
              begin 
               mem[addr]=data_in[15:8];
               mem[addr+1]=data_in[7:0];
              end
              3'b010:
              begin 
               {mem[addr],mem[addr+1],mem[addr+2],mem[addr+3]}=data_in;
              end
            endcase
        end else        data_out=32'hZZZZZZZZ;

   
 end
 initial begin
//$readmemh("C://Users//jannahsoliman9//Downloads//MS1-20230430T063941Z-001//MS1//MS1.srcs//sources_1//new//Rtype.mem",mem);
//$readmemh("C://Users//jannahsoliman9//Downloads//MS1-20230430T063941Z-001//MS1//MS1.srcs//sources_1//new//itype.mem",mem);
//$readmemh("C://Users//jannahsoliman9//Downloads//MS1-20230430T063941Z-001//MS1//MS1.srcs//sources_1//new//loadtest.mem",mem);
// $readmemh("C://Users//jannahsoliman9//Downloads//MS1-20230430T063941Z-001//MS1//MS1.srcs//sources_1//new//hazardtestfromlab.mem",mem);
//$readmemh("C://Users//jannahsoliman9//Downloads//MS1-20230430T063941Z-001//MS1//MS1.srcs//sources_1//new//jaljalrauipclui_test.mem",mem);
$readmemh("C://Users//jannahsoliman9//Downloads//MS1-20230430T063941Z-001//MS1//MS1.srcs//sources_1//new//all.mem",mem);
 end
 

endmodule
