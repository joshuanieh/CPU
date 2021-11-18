module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

//Wire
wire [6:0]  Op_i;
wire [4:0]  RS1addr_i, RS2addr_i, RDaddr_i;
wire [11:0] ST_i;
wire [9:0]  funct_i;
wire [31:0] instr_o;
wire [1:0]  ALUOp;
wire ALUSrc, RegWrite;
wire  [31:0] pc_i, RS1data, RS2data, ST_o, MUX_o;
wire [2:0] ALUCrtl;
wire Zero;
wire  [31:0] RDdata, pc_o;

//Assigning
assign Op_i = instr_o[6:0];
assign RS1addr_i = instr_o[19:15];
assign RS2addr_i = instr_o[24:20];
assign RDaddr_i = instr_o[11:7];
assign ST_i = instr_o[31:20];
assign funct_i = {instr_o[31:25], instr_o[14:12]};


Control Control(
    .Op_i       (Op_i),
    .ALUOp_o    (ALUOp),
    .ALUSrc_o   (ALUSrc),
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
    .data_i     (ST_i),
    .data_o     (ST_o)
);

  

ALU ALU(
    .data1_i    (RS1data),
    .data2_i    (MUX_o),
    .ALUCtrl_i  (ALUCrtl),
    .data_o     (RDdata),
    .Zero_o     (Zero)
);



ALU_Control ALU_Control(
    .funct_i    (funct_i),
    .ALUOp_i    (ALUOp),
    .ALUCtrl_o  (ALUCrtl)
);


endmodule

