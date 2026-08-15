module top_processor (
    input clk, arst,
    output [31:0] PC,          // Program Counter
    output [31:0] ALUResult,   // Result from ALU
    output [31:0] Instruction, // Instruction from Instruction Memory
    output [31:0] WriteData,   // Data to be written to Data Memory (ReadData2)
    output        MemWrite,    // enable signal for Data Memory write operation
    output [31:0] ReadData     // Data read from Data Memory
);

wire [6:0] opcode;
wire [2:0] func3;
wire       func7;
wire       zero_flag;
wire       sign_flag;
wire       PCsrc, resultsrc, ALU_src, regwrite, load;
wire [1:0] immsrc;
wire [2:0] ALU_control;
wire [31:0] PCnext, PCtarget;
wire [31:0] immext;
wire [31:0] read_data1;

// Muxes
wire [31:0] srcB;
wire [31:0] result;

// 1. Control Unit
control_unit cu(
    .opcode(Instruction[6:0]),
    .func3(Instruction[14:12]),
    .func7(Instruction[30]),
    .zero_flag(zero_flag),
    .sign_flag(sign_flag),
    .PCsrc(PCsrc),
    .resultsrc(resultsrc),
    .mem_write(MemWrite),
    .ALU_src(ALU_src),
    .regwrite(regwrite),
    .load(load),
    .immsrc(immsrc),
    .ALU_control(ALU_control)
);

// 2. Instruction Memory
instr_mem imem(
    .PC(PC),
    .instruction(Instruction)
);

// 3. Program Counter 
counter pc_counter(
    .clk(clk),
    .arst(arst),
    .load(load),
    .PCsrc(PCsrc),
    .immext(immext),
    .PC(PC)
);

// 4. Sign Extend
sign_extend sx(
    .instruction(Instruction),
    .immsrc(immsrc),
    .immext(immext)
);

// 5. Multiplexers 
assign srcB   = (ALU_src == 1'b1) ? immext   : WriteData;
assign result = (resultsrc == 1'b1) ? ReadData : ALUResult;

// 6. Register File
register_file rf(
    .clk(clk),
    .rst(arst),
    .write_en(regwrite),
    .A1(Instruction[19:15]),
    .A2(Instruction[24:20]),
    .A3(Instruction[11:7]),
    .write_data(result),
    .read_data1(read_data1),
    .read_data2(WriteData) 
);

// 7. ALU 
ALU alu(
    .A(read_data1), 
    .B(srcB),
    .ALUControl(ALU_control),
    .Zero(zero_flag),
    .sign_flag(sign_flag),
    .ALUOut(ALUResult)
);

// 8. Data Memory
Data_memory dmem(
    .clk(clk),
    .rst(arst),
    .address(ALUResult),
    .write_data(WriteData),
    .write_en(MemWrite),
    .read_data(ReadData)
);

endmodule