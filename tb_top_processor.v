module tb_top_processor;
    reg clk;
    reg arst;
    wire [31:0] PC;          // Program Counter
    wire [31:0] ALUResult;   // Result from ALU
    wire [31:0] Instruction; // Instruction from Instruction Memory
    wire [31:0] WriteData;   // Data to be written to Data Memory
    wire        MemWrite;    // Enable signal for Data Memory
    wire [31:0] ReadData;    // Data read from Data Memory

    // 2. (Instantiation)
    top_processor uut (
        .clk(clk),
        .arst(arst),
        .PC(PC),
        .ALUResult(ALUResult),
        .Instruction(Instruction),
        .WriteData(WriteData),
        .MemWrite(MemWrite),
        .ReadData(ReadData)
    );

    initial begin //clock generation
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        arst = 0; // reset the processor
        #12;         
        arst = 1;
        
        $monitor("Time=%0t | PC=%h | Instr=%h | ALU_Out=%h | MemWrite=%b | WriteData=%h | ReadData=%h", 
                 $time, PC, Instruction, ALUResult, MemWrite, WriteData, ReadData);
                 
        #800;
        $finish;
    end

endmodule
