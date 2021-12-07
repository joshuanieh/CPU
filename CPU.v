module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input       clk_i;
input       rst_i;
input       start_i;

//Wire
//Control signals
wire        ALUSrc_1, ALUSrc_2, RegWrite_2, RegWrite_3, RegWrite_4, RegWrite_5, MemtoReg_2, MemtoReg_3, MemRead_2, MemRead_3, MemWrite_2, MemWrite_3, Branch;
wire [1:0]  ALUOp_2, ALUOp_3;
//Module I/O
wire        NoOp, Zero;
wire [2:0]  ALUCrtl_3;
wire [4:0]  RS1addr_2, RS1addr_3, RS2addr_2, RS2addr_3, RDaddr_2, RDaddr_3;
wire [6:0]  Op;
wire [9:0]  funct_2, funct_3;
wire [11:0] SE_21, SE_22, SE_3;
wire [31:0] ALUResult_3, instr_1, instr_2, RS1data_2, RS1data_31, RS1data_32, RS2data_2, RS2data_31, RS2data_32, SE_21, SE_22, SE_3, MUX_3, RDdata_5, pc_0, pc_1, pc_2;


//Assigning
assign Op        = instr_2[6:0];
assign RS1addr_2 = instr_2[19:15];
assign RS2addr_2 = instr_2[24:20];
assign RDaddr_2  = instr_2[11:7];
assign SE_21      = instr_2[31:20];
assign funct_2   = {instr_2[31:25], instr_2[14:12]};

IFID IFID(
    .clk_i      (clk_i),
    .instr_i    (instr_1),
    .Stall_i    (Stall),
    .Flush_i    (Flush),
    .pc_i       (pc_1),
    .instr_o    (instr_2),
    .pc_o       (pc_2)
);

IDEX IDEX(
    clk_i       (clk_i),
    ALUOp_i     (ALUOp_2),
    ALUSrc_i    (ALUSrc_2),
    RegWrite_i  (RegWrite_2),
    MemtoReg_i  (MemtoReg_2),
    MemRead_i   (MemRead_2),
    MemWrite_i  (MemWrite_2),
    RS1data_i   (RS1data_2),
    RS2data_i   (RS2data_2),
    SE_i        (SE_22),
    funct_i     (funct_2),
    RS1addr_i   (RS1addr_2),
    RS2addr_i   (RS2addr_2),
    RDaddr_i    (RDaddr_2),
    RegWrite_o  (RegWrite_3),
    MemtoReg_o  (MemtoReg_3),
    MemRead_o   (MemRead_3),
    MemWrite_o  (MemWrite_3),
    ALUOp_o     (ALUOp_3),
    ALUSrc_o    (ALUSrc_3),
    RS1data_o   (RS1data_31),
    RS2data_o   (RS2data_31),
    SE_o        (SE_3),
    funct_o     (funct_3),
    RS1addr_o   (RS1addr_3),
    RS2addr_o   (RS2addr_3),
    RDaddr_o    (RDaddr_3)
);

EXMEM EXMEM(
    clk_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    ALUResult_i,
    RS2data_i,
    RDaddr_i,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUResult_o,
    RS2data_o,
    RDaddr_o
);

MEMWB MEMWB(
    clk_i,
    RegWrite_i,
    MemtoReg_i,
    ALUResult_i,
    MemData_i,
    RDaddr_i,
    RegWrite_o,
    MemtoReg_o,
    ALUResult_o,
    MemData_o,
    RDaddr_o
);
Control Control(
    .Op_i       (Op),
    .NoOp_i     (NoOp),
    .ALUOp_o    (ALUOp_2),
    .ALUSrc_o   (ALUSrc_2),
    .MemtoReg_o (MemtoReg_2),
    .MemRead_o  (MemRead_2),
    .MemWrite_o (MemWrite_2),
    .Branch_o   (Branch),
    .RegWrite_o (RegWrite_2)
);


Adder Add_PC(
    .data1_in   (pc_1),
    .data2_in   (3'b100),
    .data_o     (pc_0)
);


PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (pc_0),
    .pc_o       (pc_1)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (pc_1), 
    .instr_o    (instr_1)
);

Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i   (RS1addr_2),
    .RS2addr_i   (RS2addr_2),
    .RDaddr_i   (RDaddr_2), 
    .RDdata_i   (RDdata_5),
    .RegWrite_i (RegWrite_5), 
    .RS1data_o   (RS1data_2), 
    .RS2data_o   (RS2data_2) 
);


MUX32 MUX_ALUSrc(
    .data1_i    (RS2data_31),
    .data2_i    (SE_3),
    .select_i   (ALUSrc_3),
    .data_o     (RS2data_32)
);



Sign_Extend Sign_Extend(
    .data_i     (SE_21),
    .data_o     (SE_22)
);

  

ALU ALU(
    .data1_i    (RS1data_32),
    .data2_i    (MUX_3),
    .ALUCtrl_i  (ALUCrtl_3),
    .data_o     (ALUResult_3)
);



ALU_Control ALU_Control(
    .funct_i    (funct_3),
    .ALUOp_i    (ALUOp_3),
    .ALUCtrl_o  (ALUCrtl_3)
);


endmodule

