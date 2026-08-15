module Data_memory (
    input clk,rst,
    input [31:0] address,
    input [31:0] write_data,
    input write_en,
    output reg [31:0] read_data
);
   reg [31:0] data_mem [0:63]; 
   always @( posedge clk or negedge rst ) begin 
    if(!rst) begin : RESET_BLOCK // Reset block to initialize the data memory
            integer i;
            for (i = 0; i <  64; i = i + 1) begin
                data_mem[i] <= 32'b0;
            end
    end
    else if(write_en) begin
        data_mem[address[7:2]] <= write_data; // Word aligned [7:2] for 64 words of memory
    end
   end

   always @(*) begin
        read_data = data_mem[address[7:2]];   // Word aligned [7:2] for 64 words of memory
    end
endmodule
