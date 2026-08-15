module instr_mem (
    input [31:0] PC,
    output reg [31:0] instruction
);

    reg [31:0] instruction_mem [0:63];  // 64 words of instruction memory

    initial begin
        $readmemh("instructions.txt", instruction_mem);  // Load instructions from a file
    end

    always @(*) begin
        instruction = instruction_mem[PC[31:2]]; // Word aligned [31:2]
    end

endmodule


