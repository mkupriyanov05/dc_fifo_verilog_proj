`timescale 1ns/1ps

module dc_fifo_tb;

    reg [31:0] data_in;
    reg clk_in;
    reg clk_out;
    reg enable_in;
    reg enable_out;
    reg rst;
    wire [31:0] data_out;


    dc_fifo dut(
        .data_in(data_in),
        .clk_in(clk_in),
        .clk_out(clk_out),
        .enable_in(enable_in),
        .enable_out(enable_out),
        .rst(rst),
        .data_out(data_out)
    );

    initial begin
        $dumpfile("sim/wave.vcd");
        $dumpvars(0, dc_fifo_tb);

        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

    initial begin
        clk_out = 0;
        forever #7 clk_out = ~clk_out;
    end

    initial begin
        rst = 0;
        data_in = 32'd52;
        enable_in = 0;
        enable_out = 0;

        repeat (3)
            @(negedge clk_in);
        rst = 1;

        repeat (2)
            @(negedge clk_in);
        enable_in = 1;

            @(negedge clk_out);
        enable_out = 1;

        repeat (4)
            @(posedge clk_in);
        data_in = 32'd69;


        #100;
        $finish;
    end

    initial begin
        $monitor(
            "time=%0t clk_in=%b clk_out=%b rst=%b data_in=%d data_out=%d enable_in=%b enable_out=%b addr_in=%d addr_out=%d",
            $time,
            clk_in,
            clk_out,
            rst,
            data_in,
            data_out,
            enable_in,
            enable_out,
            dut.addr_in,
            dut.addr_out
        );
    end


endmodule