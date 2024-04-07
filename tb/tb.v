`timescale 1ns / 1ps
/*  * Module: tb.v  
* Project: milestone 2  
* Author: laila khashaba -lailakhashaba@aucegypt.edu
jannah soliman- jannahsoliman9@aucegypt.edu
* Description: testbench
*  
* Change history: 10/4/23 -  
               
*  **********************************************************************/

module tb;
reg clk;
reg rst;

initial begin
clk=0;
forever #5  clk=~clk;
end

CPU uut(.clk(clk),.rst(rst) , .SSDclk(SSDclk), .SSDsel(SSDclk)
 ,.LEDSelect(LEDSelect), .LEDout(LEDout),.Anode(Anode), 
 .SSDLED_out(SSDLED_out) );
 
 /*wire slowclk;
 slowclock uut(.clk(clk),.rst(rst),.slowclk(slowclk));*/

initial 
begin 
rst=1'b1;
#10;
rst=1'b0;
#37000 ;

$finish;
end
endmodule
