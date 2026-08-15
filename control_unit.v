module control_unit (
    input [6:0] opcode,
    input [2:0] func3,
    input  func7,     // one bit
    input zero_flag,  // from ALU
    input sign_flag,  // from ALU
    output reg PCsrc, resultsrc, mem_write, ALU_src, regwrite, load,
    output reg [1:0] immsrc,
    output reg [2:0] ALU_control
);
   reg [1:0] ALU_op;
   reg branch;
   
   // 1. Main Decoder
   always @(*) begin
    case (opcode)
        7'b0000011 : // LW (Load Word)
        begin
            regwrite  = 1'b1;
            immsrc    = 2'b00;
            ALU_src   = 1'b1;
            mem_write = 1'b0;
            resultsrc = 1'b1;
            branch    = 1'b0;
            ALU_op    = 2'b00;
            load      = 1'b1;
        end
        
        7'b0100011 : // SW (Store Word)
        begin
            regwrite  = 1'b0;
            immsrc    = 2'b01;
            ALU_src   = 1'b1;
            mem_write = 1'b1;
            resultsrc = 1'bx;
            branch    = 1'b0;
            ALU_op    = 2'b00;
            load      = 1'b1;
        end

        7'b0110011 : // R-type
        begin
            regwrite  = 1'b1;
            immsrc    = 2'bxx;
            ALU_src   = 1'b0;
            mem_write = 1'b0;
            resultsrc = 1'b0;
            branch    = 1'b0;
            ALU_op    = 2'b10;
            load      = 1'b1;
        end
        
        7'b0010011 : // I-type ALU
        begin
            regwrite  = 1'b1;
            immsrc    = 2'b00;
            ALU_src   = 1'b1;
            mem_write = 1'b0;
            resultsrc = 1'b0;
            branch    = 1'b0;
            ALU_op    = 2'b10;
            load      = 1'b1;
        end

        7'b1100011 : // B-type (Branch)
        begin
            regwrite  = 1'b0;
            immsrc    = 2'b10;
            ALU_src   = 1'b0;
            mem_write = 1'b0;
            resultsrc = 1'bx;
            branch    = 1'b1;
            ALU_op    = 2'b01;
            load      = 1'b1;
        end

        default: // Default / HLT State
        begin
            regwrite  = 1'b0;
            immsrc    = 2'b00;
            ALU_src   = 1'b0;
            mem_write = 1'b0;
            resultsrc = 1'b0;
            branch    = 1'b0;
            ALU_op    = 2'b00;
            load      = 1'b0;
        end
    endcase
   end 

   // 2. ALU Decoder
   always @(*) begin
    case (ALU_op)
        2'b00: ALU_control = 3'b000; // ADD 
        2'b01: ALU_control = 3'b010; // SUB 
        
        2'b10: begin
            if (func3 == 3'b000) begin
                
                if (opcode[5] && func7)
                    ALU_control = 3'b010; // SUB
                else 
                    ALU_control = 3'b000; // ADD
            end
            else begin
                ALU_control = func3; 
            end
        end  
        
        default: ALU_control = 3'b000;
    endcase
   end

   // 3. Complete Branch Logic 
   always @(*) begin
    if (branch) begin
        case (func3)
            3'b000:  PCsrc = zero_flag;       // beq
            3'b001:  PCsrc = !zero_flag;      // bne
            3'b100:  PCsrc = sign_flag;      // blt
            default: PCsrc = 1'b0;
        endcase
    end 
    else begin
        PCsrc = 1'b0; 
    end
   end

endmodule