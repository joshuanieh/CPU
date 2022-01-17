module CPU
(
    clk_i, 
    rst_i,
    start_i,
    mem_data_i, 
    mem_ack_i,     
    mem_data_o, 
    mem_addr_o,     
    mem_enable_o, 
    mem_write_o
);

// Ports
input          clk_i, rst_i, start_i, mem_ack_i;
input [255:0]  mem_data_i;
output         mem_enable_o, mem_write_o;
output [255:0] mem_data_o;
output [31:0]  mem_addr_o;


//Wire
//Control signals
wire        ALUSrc_1, ALUSrc_2, ALUSrc_3, RegWrite_2, RegWrite_3, RegWrite_4, RegWrite_5, RegWrite_tmp, MemtoReg_2, MemtoReg_3, MemtoReg_4, MemtoReg_tmp, MemRead_2, MemRead_3, MemRead_4, MemRead_tmp, MemWrite_2, MemWrite_3, MemWrite_4, MemWrite_tmp, Branch, Branch_tmp;
wire [1:0]  ALUOp_2, ALUOp_3;
//Module I/O
wire        Equal, PCWrite, PCWrite_tmp, NoOp, NoOp_tmp;
wire [1:0]  ForwardA, ForwardB;
wire [2:0]  ALUCrtl_3;
wire [4:0]  RS1addr_2, RS1addr_3, RS2addr_2, RS2addr_3, RDaddr_2, RDaddr_3, RDaddr_4, RDaddr_5, RDaddr_5_tmp;
wire [6:0]  Op;
wire [9:0]  funct_2, funct_3;
wire [31:0] tmpA, tmpB, SE_21, SE_22, SE_23, SE_3, ALUResult_3, ALUResult_4, ALUResult_5, instr_1, instr_2, RS1data_2, RS1data_31, RS1data_32, RS2data_2, RS2data_31, RS2data_32, RS2data_4, MUX_3, RDdata_5, RDdata_5_tmp, pc_branch, pc_predicted, pc_0, pc_1, pc_2, MemData_4, MemData_5;


//Assigning
assign Op        = instr_2[6:0];
assign RS1addr_2 = instr_2[19:15];
assign RS2addr_2 = instr_2[24:20];
assign RDaddr_2  = instr_2[11:7];
assign SE_21     = instr_2;
assign funct_2   = {instr_2[31:25], instr_2[14:12]};
assign SE_23     = SE_22 << 1;
assign Equal     = (RS1data_2 == RS2data_2);
assign PCWrite   = (counter <= 1) ? 1'b1 : PCWrite_tmp;
assign Flush     = Equal & Branch;
assign RegWrite_2 = pc_1 === 0 ? 1'b0 : RegWrite_tmp;
assign MemRead_2 = pc_1 === 0 ? 1'b0 : MemRead_tmp;
assign MemWrite_2 = pc_1 === 0 ? 1'b0 : MemWrite_tmp;
assign Branch = pc_1 === 0 ? 1'b0 : Branch_tmp;
assign RDaddr_5 = (counter <= 3) ? 5'b0 : RDaddr_5_tmp;
assign RDdata_5 = (counter <= 3) ? 32'b0 : RDdata_5_tmp;
assign MemtoReg_2 = pc_1 === 0 ? 1'b0 : MemtoReg_tmp;
assign pc_predicted = pc_1 + 3'b100;
assign pc_branch = pc_2 + SE_23;
assign NoOp = instr_2 === 32'b0 ? 1 : NoOp_tmp;

reg [31:0] counter;
always @(posedge clk_i) begin
    counter <= counter + 1;
end
IFID IFID(
    .clk_i       (clk_i),
    .instr_i     (instr_1),
    .Stall_i     (Stall | Miss_stall),
    .Flush_i     (Flush),
    .pc_i        (pc_1),
    .instr_o     (instr_2),
    .pc_o        (pc_2)
);

IDEX IDEX(
    .clk_i       (clk_i),
    .Miss_stall_i(Miss_stall),
    .ALUOp_i     (ALUOp_2),
    .ALUSrc_i    (ALUSrc_2),
    .RegWrite_i  (RegWrite_2),
    .MemtoReg_i  (MemtoReg_2),
    .MemRead_i   (MemRead_2),
    .MemWrite_i  (MemWrite_2),
    .RS1data_i   (RS1data_2),
    .RS2data_i   (RS2data_2),
    .SE_i        (SE_22),
    .funct_i     (funct_2),
    .RS1addr_i   (RS1addr_2),
    .RS2addr_i   (RS2addr_2),
    .RDaddr_i    (RDaddr_2),
    .RegWrite_o  (RegWrite_3),
    .MemtoReg_o  (MemtoReg_3),
    .MemRead_o   (MemRead_3),
    .MemWrite_o  (MemWrite_3),
    .ALUOp_o     (ALUOp_3),
    .ALUSrc_o    (ALUSrc_3),
    .RS1data_o   (RS1data_31),
    .RS2data_o   (RS2data_31),
    .SE_o        (SE_3),
    .funct_o     (funct_3),
    .RS1addr_o   (RS1addr_3),
    .RS2addr_o   (RS2addr_3),
    .RDaddr_o    (RDaddr_3)
);

EXMEM EXMEM(
    .clk_i       (clk_i),
    .Miss_stall_i(Miss_stall),
    .RegWrite_i  (RegWrite_3),
    .MemtoReg_i  (MemtoReg_3),
    .MemRead_i   (MemRead_3),
    .MemWrite_i  (MemWrite_3),
    .ALUResult_i (ALUResult_3),
    .RS2data_i   (RS2data_32),
    .RDaddr_i    (RDaddr_3),
    .RegWrite_o  (RegWrite_4),
    .MemtoReg_o  (MemtoReg_4),
    .MemRead_o   (MemRead_4),
    .MemWrite_o  (MemWrite_4),
    .ALUResult_o (ALUResult_4),
    .RS2data_o   (RS2data_4),
    .RDaddr_o    (RDaddr_4)
);

MEMWB MEMWB(
    .clk_i       (clk_i),
    .Miss_stall_i(Miss_stall),
    .RegWrite_i  (RegWrite_4),
    .MemtoReg_i  (MemtoReg_4),
    .ALUResult_i (ALUResult_4),
    .MemData_i   (MemData_4),
    .RDaddr_i    (RDaddr_4),
    .RegWrite_o  (RegWrite_5),
    .MemtoReg_o  (MemtoReg_5),
    .ALUResult_o (ALUResult_5),
    .MemData_o   (MemData_5),
    .RDaddr_o    (RDaddr_5_tmp)
);

Control Control(
    .Op_i        (Op),
    .NoOp_i      (NoOp),
    .ALUOp_o     (ALUOp_2),
    .ALUSrc_o    (ALUSrc_2),
    .MemtoReg_o  (MemtoReg_tmp),
    .MemRead_o   (MemRead_tmp),
    .MemWrite_o  (MemWrite_tmp),
    .Branch_o    (Branch_tmp),
    .RegWrite_o  (RegWrite_tmp)
);

PC PC(
    .clk_i       (clk_i),
    .rst_i       (rst_i),
    .start_i     (start_i),
    .stall_i     (Miss_stall),
    .PCWrite_i   (PCWrite),
    .pc_i        (pc_0),
    .pc_o        (pc_1)
);

Instruction_Memory Instruction_Memory(
    .addr_i      (pc_1), 
    .instr_o     (instr_1)
);

Hazard_Detection_Unit Hazard_Detection_Unit(
    .MemRead_i   (MemRead_3),
    .RDaddr_i    (RDaddr_3),
    .RS1addr_i   (RS1addr_2),
    .RS2addr_i   (RS2addr_2),
    .NoOp_o      (NoOp_tmp),
    .Stall_o     (Stall),
    .PCWrite_o   (PCWrite_tmp)
);

Registers Registers(
    .clk_i       (clk_i),
    .RS1addr_i   (RS1addr_2),
    .RS2addr_i   (RS2addr_2),
    .RDaddr_i    (RDaddr_5),
    .RDdata_i    (RDdata_5),
    .RegWrite_i  (RegWrite_5), 
    .RS1data_o   (RS1data_2), 
    .RS2data_o   (RS2data_2) 
);


MUX32 MUX_ALUSrc(
    .data1_i     (RS2data_32),
    .data2_i     (SE_3),
    .select_i    (ALUSrc_3),
    .data_o      (MUX_3)
);

MUX32 MUX_Zero(
    .data1_i     (pc_predicted),
    .data2_i     (pc_branch),
    .select_i    (Flush),
    .data_o      (pc_0)
);

MUX32 MUX_WB(
    .data1_i     (ALUResult_5),
    .data2_i     (MemData_5),
    .select_i    (MemtoReg_5),
    .data_o      (RDdata_5_tmp)
);

//4 to 1 MUX
MUX32 MUX_A(
    .data1_i     (RS1data_31),
    .data2_i     (RDdata_5),
    .select_i    (ForwardA[0]),
    .data_o      (tmpA)
);
MUX32 MUX_AA(
    .data1_i     (tmpA),
    .data2_i     (ALUResult_4),
    .select_i    (ForwardA[1]),
    .data_o      (RS1data_32)
);

//4 to 1 MUX
MUX32 MUX_B(
    .data1_i     (RS2data_31),
    .data2_i     (RDdata_5),
    .select_i    (ForwardB[0]),
    .data_o      (tmpB)
);
MUX32 MUX_BB(
    .data1_i     (tmpB),
    .data2_i     (ALUResult_4),
    .select_i    (ForwardB[1]),
    .data_o      (RS2data_32)
);

Sign_Extend Sign_Extend(
    .data_i      (SE_21),
    .data_o      (SE_22)
);

ALU ALU(
    .data1_i     (RS1data_32),
    .data2_i     (MUX_3),
    .ALUCtrl_i   (ALUCrtl_3),
    .data_o      (ALUResult_3)
);

ALU_Control ALU_Control(
    .funct_i     (funct_3),
    .ALUOp_i     (ALUOp_3),
    .ALUCtrl_o   (ALUCrtl_3)
);

// Data_Memory Data_Memory(
//     .clk_i       (clk_i),
//     .addr_i      (ALUResult_4),
//     .MemRead_i   (MemRead_4),
//     .MemWrite_i  (MemWrite_4),
//     .data_i      (RS2data_4),
//     .data_o      (MemData_4)
// );

dcache_controller dcache(
    // System clock, reset and stall
    .clk_i          (clk_i), 
    .rst_i          (rst_i),
    
    // to Data Memory interface        
    .mem_data_i     (mem_data_i), 
    .mem_ack_i      (mem_ack_i),     
    .mem_data_o     (mem_data_o), 
    .mem_addr_o     (mem_addr_o),     
    .mem_enable_o   (mem_enable_o), 
    .mem_write_o    (mem_write_o), 
    
    // to CPU interface    
    .cpu_data_i     (RS2data_4), 
    .cpu_addr_i     (ALUResult_4),     
    .cpu_MemRead_i  (MemRead_4), 
    .cpu_MemWrite_i (MemWrite_4), 
    .cpu_data_o     (MemData_4), 
    .cpu_stall_o    (Miss_stall)
);

Forwarding_Unit Forwarding_Unit(
    .RS1addr_i   (RS1addr_3),
    .RS2addr_i   (RS2addr_3),
    .RDaddrM_i   (RDaddr_4),
    .RegWriteM_i (RegWrite_4),
    .RDaddrW_i   (RDaddr_5),
    .RegWriteW_i (RegWrite_5),
    .ForwardA_o  (ForwardA),
    .ForwardB_o  (ForwardB)
);
endmodule