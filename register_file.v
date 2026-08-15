module register_file (
    input clk,rst,
    input [4:0] A1,A2,A3,
    input write_en,
    input [31:0] write_data,
    output reg [31:0] read_data1,read_data2  
);
    reg [31:0] reg_file [0:31];
    always @(posedge clk or negedge rst) begin
        if(!rst) begin : RESET_BLOCK   // Reset block to initialize the register file
            integer i;
            for (i = 0; i < 32; i = i + 1) begin
                reg_file[i] <= 32'b0;
            end
        end 

        else if(write_en) begin
            if (A3 != 5'b0) begin   // Prevent writing to register x0
                reg_file[A3] <= write_data;
            end
            
        end
    end
    always @(*) begin
        read_data1 = reg_file[A1];
        read_data2 = reg_file[A2];
    end 
    
endmodule
