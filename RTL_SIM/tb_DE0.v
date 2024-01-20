`include "DE0_NANO.v"
`timescale 1ns/100ps
`default_nettype none

module tb_DE0_NANO;
reg clk;
reg rst_n;

DE0_NANO de0
(
    .KEY ({1'b1,rst_n}),
    .CLOCK_50 (clk)
    
    //.KEY(),

);

localparam CLK_PERIOD = 20;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("tb_DE0_NANO.vcd");
    $dumpvars(0, tb_DE0_NANO);
end

initial begin
    #1 rst_n<=1'bx;clk<=1'bx;
    #(CLK_PERIOD*3) rst_n<=1;
    #(CLK_PERIOD*3) rst_n<=0;clk<=0;
    repeat(5000) @(posedge clk);
    rst_n<=1;
    @(posedge clk);
    repeat(100000) @(posedge clk);
    $finish(2);
end

endmodule
`default_nettype wire