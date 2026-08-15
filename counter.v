module counter (
    input clk ,arst,load,
    input PCsrc,         // select between PC+4 and branch target
    input [31:0] immext, // immediate value for branch target
    output reg [31:0] PC // program counter
);
    reg [31:0] PCnext;
    wire [31:0] PCtarget;
    wire [31:0] PCplus4;

    assign PCtarget = PC+immext;
    assign PCplus4  = PC+32'd4;

    always @(*) begin
        if (PCsrc)
            PCnext = PCtarget;             
        else
            PCnext = PCplus4;              
    end
  
    always @(posedge clk or negedge arst) begin
        if(!arst)  PC <= 32'd0;
        
        else begin
            if(load) 
                PC<=PCnext;
            else 
                PC<=PC;
        end       
    end
endmodule
