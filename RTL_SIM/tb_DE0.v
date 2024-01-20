`include "DE0_NANO.v"

`timescale 1ns/100ps
`default_nettype none

module tb_DE0_NANO;
reg clk;
reg rst_n;


wire spi_cs_n_w;
wire spi_clk_w;
wire spi_miso;
wire spi_mosi;


ADC128S022 adc1(
    .CLK(spi_clk_w),
    .MOSI(spi_mosi),
    .MISO(spi_miso),
    .CS_N(spi_cs_n_w),
    .i_rst_n(rst_n)
);

DE0_NANO de0
(
    .KEY ({1'b1,rst_n}),
    .CLOCK_50(clk),
    .ADC_CS_N(spi_cs_n_w),
	.ADC_SADDR(spi_miso),
	.ADC_SCLK(spi_clk_w),
	.ADC_SDAT(spi_mosi)
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


module ADC128S022 (
    input CLK,
    input MOSI,
    output reg MISO,
    input CS_N,
    input i_rst_n
);

reg [11:0] adc_mem;
reg [4:0] cnt;
reg [4:0] cnt_nex;

initial begin
    adc_mem <= 12'b1000_0100_1111;
end

    always @(negedge CLK or negedge i_rst_n) begin
        if(i_rst_n == 0)begin
            cnt <= 0;
        end
        else begin
            cnt <= cnt_nex;
        end
    end

    always @(*) begin
        if(!CS_N)begin
            cnt_nex = cnt + 1;
        end
        else begin
            cnt_nex = 0;
        end
    end


    
    always @(*) begin
        case (cnt)
            5:MISO = adc_mem[11];
            6:MISO = adc_mem[10];
            7:MISO = adc_mem[9];
            8:MISO = adc_mem[8];
            9:MISO = adc_mem[7];
            10:MISO = adc_mem[6];
            11:MISO = adc_mem[5];
            12:MISO = adc_mem[4];
            13:MISO = adc_mem[3];
            14:MISO = adc_mem[2];
            15:MISO = adc_mem[1];
            16:MISO = adc_mem[0]; 
                
            default: 
                MISO = 0;
        endcase
    end
endmodule


`default_nettype wire