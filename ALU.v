module ALU (
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALUControl,
    output reg [31:0] ALUOut,  
    output reg Zero,           
    output reg sign_flag       
);

always @(*) begin
    
    case(ALUControl) 
        3'b000  : ALUOut = A + B;          // Addition
        3'b001  : ALUOut = A << B;         // Shift left logical
        3'b010  : ALUOut = A - B;          // Subtraction
        3'b100  : ALUOut = A ^ B;          // XOR
        3'b101  : ALUOut = A >> B;         // Shift right logical
        3'b110  : ALUOut = A | B;          // OR
        3'b111  : ALUOut = A & B;          // AND
        default : ALUOut = 32'b0;          // Default case to prevent Latches
    endcase
   
    Zero = (ALUOut == 32'b0);
    sign_flag = ALUOut[31]; 
end   
endmodule
