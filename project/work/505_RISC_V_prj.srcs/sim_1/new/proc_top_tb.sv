`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/15/2023 07:34:02 PM
// Design Name: 
// Module Name: proc_top_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module proc_top_tb(
);

logic clk;
logic rst_n;

initial begin
    clk = 1'b0;
    rst_n = 1'b0;
    #20;
    rst_n = 1'b1;
end

always begin
    #5;
    clk <= ~clk;
end

proc_top #(
    .DWIDTH(32)
)
proc_top (
    .Clk_Core(clk),
    .Rst_Core_N(rst_n)
);

endmodule
