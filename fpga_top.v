module fpga_top (
    input clk_50mhz,     
    input rst_n,         
    output [5:0] leds    // لمبات LED الموجودة على البوردة لطباعة النتيجة
);

    // الأسلاك الداخلية التي تنقل 163 إشارة للمعالج
    wire [31:0] pc_out;
    wire [31:0] alu_result;
    // أضيفي باقي الأسلاك الكبيرة هنا حسب المخرجات الموجودة في top_processor

    // استدعاء المعالج كاملاً بالداخل (Instantiate)
    top_processor processor_inst (
        .clk(clk_50mhz),
        .arst(rst_n),
        .PC(pc_out),
        .ALUResult(alu_result),
        .Instruction() // ترك الأقواس فارغة يعني صراحة للمترجم أنك تتعمد عدم توصيلها
        // اربطي بقية البورتات بالأسلاك الداخلية
    );

    // عرض أول 6 بت من النتيجة على الـ LEDs فقط لتخفيف الأرجل الخارجية
    assign leds = ~alu_result[5:0]; 

endmodule
