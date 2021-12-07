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
wire        ALUSrc, RegWrite, RegWrite, MemtoReg, MemRead, MemWrite, Branch;
wire [1:0]  ALUOp;
//Module I/O
wire        NoOp, Zero;
wire [2:0]  ALUCrtl;
wire [4:0]  RS1addr_i, RS2addr_i, RDaddr_i;
wire [6:0]  Op_i;
wire [9:0]  funct_i;
wire [11:0] SE_i;
wire [31:0] ALUResult, instr_o, pc_i, RS1data, RS2data, SE_o, MUX_o, RDdata, pc_o;


//Assigning
assign Op_i      = instr_o[6:0];
assign RS1addr_i = instr_o[19:15];
assign RS2addr_i = instr_o[24:20];
assign RDaddr_i  = instr_o[11:7];
assign ST_i      = instr_o[31:20];
assign funct_i   = {instr_o[31:25], instr_o[14:12]};

IFID IFID(
    .clk_i      (clk_i),
    .instr_i    (instr_o),
    .Stall_i    (Stall),
    .Flush_i    (Flush),
    .pc_i       (pc_o),
    .instr_o    (instr_ii),
    .pc_o       (pc_ii)
);

IDEX IDEX(
    clk_i       (clk_i),
    ALUOp_i     (),
    ALUSrc_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    RS1data_i,
    RS2data_i,
    SE_i,
    funct_i,
    RS1addr_i,
    RS2addr_i,
    RDaddr_i,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUOp_o,
    ALUSrc_o,
    RS1data_o,
    RS2data_o,
    SE_o,
    funct_o,
    RS1addr_o,
    RS2addr_o,
    RDaddr_o
);

Control Control(
    .Op_i       (Op_i),
    .NoOp_i     (NoOp),
    .ALUOp_o    (ALUOp),
    .ALUSrc_o   (ALUSrc),
    .MemtoReg_o (MemtoReg),
    .MemRead_o  (MemRead),
    .MemWrite_o (MemWrite),
    .Branch_o   (Branch),
    .RegWrite_o (RegWrite)
);


Adder Add_PC(
    .data1_in   (pc_o),
    .data2_in   (3'b100),
    .data_o     (pc_i)
);


PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (pc_i),
    .pc_o       (pc_o)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (pc_o), 
    .instr_o    (instr_o)
);

Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i   (RS1addr_i),
    .RS2addr_i   (RS2addr_i),
    .RDaddr_i   (RDaddr_i), 
    .RDdata_i   (RDdata),
    .RegWrite_i (RegWrite), 
    .RS1data_o   (RS1data), 
    .RS2data_o   (RS2data) 
);


MUX32 MUX_ALUSrc(
    .data1_i    (RS2data),
    .data2_i    (ST_o),
    .select_i   (ALUSrc),
    .data_o     (MUX_o)
);



Sign_Extend Sign_Extend(
    .data_i     (SE_i),
    .data_o     (SE_o)
);

  

ALU ALU(
    .data1_i    (RS1data),
    .data2_i    (MUX_o),
    .ALUCtrl_i  (ALUCrtl),
    .data_o     (ALUResult)
);



ALU_Control ALU_Control(
    .funct_i    (funct_i),
    .ALUOp_i    (ALUOp),
    .ALUCtrl_o  (ALUCrtl)
);


endmodule

