

module dc_fifo #(
    parameter DSIZE = 32,
    parameter ASIZE = 3
)(
    input wire [DSIZE-1:0] data_in,
    input wire clk_in,
    input wire clk_out,

    input wire enable_in,
    input wire enable_out,
    input wire rst,
    output reg [DSIZE-1:0] data_out
);

    reg [DSIZE-1:0] memory [0:(1<<ASIZE)-1];

    reg [ASIZE:0] addr_in;
    reg [ASIZE:0] addr_out;

    wire [ASIZE:0] addr_in_gray;
    wire [ASIZE:0] addr_out_gray;

    assign addr_in_gray = addr_in ^ (addr_in >> 1);    
    assign addr_out_gray = addr_out ^ (addr_out >> 1);

    reg [ASIZE:0] addr_in_gray_buf1;
    reg [ASIZE:0] addr_in_gray_buf2;
    reg [ASIZE:0] addr_in_gray_buf3;

    reg [ASIZE:0] addr_out_gray_buf1;
    reg [ASIZE:0] addr_out_gray_buf2;
    reg [ASIZE:0] addr_out_gray_buf3;    

    wire full_in;
    wire empty_out;

    assign full_in   = (addr_in_gray == {~addr_out_gray_buf3[ASIZE:ASIZE-1], addr_out_gray_buf3[ASIZE-2:0]});
    assign empty_out = (addr_in_gray_buf3 == addr_out_gray);



    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            addr_in            <= 0;
            addr_out_gray_buf1 <= 0;
            addr_out_gray_buf2 <= 0;
            addr_out_gray_buf3 <= 0;
        end else begin
            addr_out_gray_buf1 <= addr_out_gray;
            addr_out_gray_buf2 <= addr_out_gray_buf1;
            addr_out_gray_buf3 <= addr_out_gray_buf2;

            if (enable_in && !full_in) begin
                memory[addr_in[ASIZE-1:0]] <= data_in;
                addr_in <= addr_in + 1'b1;
            end
        end
    end


always @(posedge clk_out or posedge rst) begin
    if (rst) begin
        addr_out          <= 0;
        data_out          <= 0;
        addr_in_gray_buf1 <= 0;
        addr_in_gray_buf2 <= 0;
        addr_in_gray_buf3 <= 0;
    end else begin
        addr_in_gray_buf1 <= addr_in_gray;
        addr_in_gray_buf2 <= addr_in_gray_buf1;
        addr_in_gray_buf3 <= addr_in_gray_buf2;

        if (enable_out && !empty_out) begin
            data_out <= memory[addr_out[ASIZE-1:0]];
            addr_out <= addr_out + 1'b1;
        end
    end
end




endmodule

