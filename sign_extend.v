module sign_extend (
    input [31:0] instruction,
    input [1:0] immsrc,
    output reg [31:0] immext
);
   always @(*) begin    
        case (immsrc)  // Determine the type of immediate based on immsrc
            
               2'b00: begin
               immext  = { {20{instruction[31]}}, instruction[31:20] };
            end
            
                2'b01: begin
                immext = { {20{instruction[31]}}, instruction[31:25], instruction[11:7] };
            end
            
                2'b10: begin
                immext = { {20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0 };
            end
            
            default: begin
                immext = 32'b0;
            end
            
        endcase
    end
endmodule
