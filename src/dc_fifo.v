

module dc_fifo(
    input wire [31:0] data_in,
    input wire clk_in,
    input wire clk_out,
    
    input wire enable_in,
    input wire enable_out,
    input wire rst,
    output reg [31:0] data_out
);

    reg [15:0] addr_in;
    reg [15:0] addr_out;

    wire [15:0] addr_in_gray;
    wire [15:0] addr_out_gray;

    assign addr_in_gray = addr_in ^ (addr_in >> 1);    
    assign addr_out_gray = addr_out ^ (addr_out >> 1);

    reg [15:0] addr_in_gray_buf1;
    reg [15:0] addr_in_gray_buf2;
    reg [15:0] addr_in_gray_buf3;

    reg [15:0] addr_out_gray_buf1;
    reg [15:0] addr_out_gray_buf2;
    reg [15:0] addr_out_gray_buf3;    

    always @(posedge rst) begin
        addr_in <= 16'b0;
        addr_out <= 16'b0;
    end


    always@(posedge clk_in) begin
        if (enable_in)
            begin
                if (addr_in == 16'hFFFF)
                    addr_in <= 16'b0;
                else addr_in <= addr_in + 1'b1;

        //         if (addr_in == max)
        //             addr_in = 0;
        //         else addr_in += 1;
        //         binary_to_gray(addr_in);
            end



    end

    always @(posedge clk_out) begin
        if (enable_out)
            begin
                addr_in_gray_buf1 <= addr_in_gray;
                addr_in_gray_buf2 <= addr_in_gray_buf1;
                addr_in_gray_buf3 <= addr_in_gray_buf2;

                addr_out_gray_buf1 <= addr_out_gray;
                addr_out_gray_buf2 <= addr_out_gray_buf1;
                addr_out_gray_buf3 <= addr_out_gray_buf2;

                if (addr_in_gray_buf3 != addr_out_gray_buf3)
                    begin
                        if (addr_out == 16'hFFFF)
                            addr_out = 16'b0;
                        else addr_out <= addr_out + 1;
                        data_out <= data_in;
                    end

                // buf3(addr_in);
                // binary_to_gray(addr_out);
                // if (addr_in != addr_out)
                //     if (addr_out == max)
                //         addr_out = 0;
                //     else addr_out += 1;
                //     data_out = data_in;
                

            end
    end




endmodule


