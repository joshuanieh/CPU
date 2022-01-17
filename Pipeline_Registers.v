module IFID(
	clk_i,
	instr_i,
	Stall_i,
	Flush_i,
	pc_i,
	Miss_stall_i,
	instr_o,
	pc_o
);
input             Stall_i, Flush_i, clk_i, Miss_stall_i;
input      [31:0] pc_i;
input      [31:0] instr_i;
output reg [31:0] instr_o, pc_o;

always @(posedge clk_i) begin
	if (Stall_i | Miss_stall_i) begin
		instr_o <= instr_o;
		pc_o    <= pc_o;
	end
	else if (Flush_i) begin
		instr_o <= 32'b0;
		pc_o    <= 32'b0;
	end
	else begin
		instr_o <= instr_i;
		pc_o    <= pc_i;
	end
end
endmodule

module IDEX(
	clk_i,
    ALUOp_i,
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
	Miss_stall_i,
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
input             clk_i, ALUSrc_i, RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i, Miss_stall_i;
input      [1:0]  ALUOp_i;
input      [31:0] RS1data_i, RS2data_i, SE_i;
input      [9:0]  funct_i;
input      [4:0]  RS1addr_i, RS2addr_i, RDaddr_i;
output reg [1:0]  ALUOp_o;
output reg        ALUSrc_o, RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o;
output reg [31:0] RS1data_o, RS2data_o, SE_o;
output reg [9:0]  funct_o;
output reg [4:0]  RS1addr_o, RS2addr_o, RDaddr_o;

always @(posedge clk_i) begin
	if (Miss_stall_i) begin
		RegWrite_o <= RegWrite_o;
	    MemtoReg_o <= MemtoReg_o;
	    MemRead_o  <= MemRead_o;
	    MemWrite_o <= MemWrite_o;
		ALUOp_o    <= ALUOp_o;
		ALUSrc_o   <= ALUSrc_o;
		RS1data_o  <= RS1data_o;
		RS2data_o  <= RS2data_o;
		SE_o       <= SE_o;
		funct_o    <= funct_o;
		RS1addr_o  <= RS1addr_o;
		RS2addr_o  <= RS2addr_o;
		RDaddr_o   <= RDaddr_o;
	end
	else begin
		RegWrite_o <= RegWrite_i;
	    MemtoReg_o <= MemtoReg_i;
	    MemRead_o  <= MemRead_i;
	    MemWrite_o <= MemWrite_i;
		ALUOp_o    <= ALUOp_i;
		ALUSrc_o   <= ALUSrc_i;
		RS1data_o  <= RS1data_i;
		RS2data_o  <= RS2data_i;
		SE_o       <= SE_i;
		funct_o    <= funct_i;
		RS1addr_o  <= RS1addr_i;
		RS2addr_o  <= RS2addr_i;
		RDaddr_o   <= RDaddr_i;
	end
end
endmodule

module EXMEM(
	clk_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
	ALUResult_i,
	RS2data_i,
	RDaddr_i,
	Miss_stall_i,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
	ALUResult_o,
	RS2data_o,
	RDaddr_o
);
input             clk_i, RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i, Miss_stall_i;
input      [31:0] ALUResult_i, RS2data_i;
input      [4:0]  RDaddr_i;
output reg        RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o;
output reg [31:0] ALUResult_o, RS2data_o;
output reg [4:0]  RDaddr_o;

always @(posedge clk_i) begin
	if (Miss_stall_i) begin
		RegWrite_o  <= RegWrite_o;
	    MemtoReg_o  <= MemtoReg_o;
	    MemRead_o   <= MemRead_o;
	    MemWrite_o  <= MemWrite_o;
		ALUResult_o <= ALUResult_o;
		RS2data_o   <= RS2data_o;
		RDaddr_o    <= RDaddr_o;
	end
	else begin
		RegWrite_o  <= RegWrite_i;
	    MemtoReg_o  <= MemtoReg_i;
	    MemRead_o   <= MemRead_i;
	    MemWrite_o  <= MemWrite_i;
		ALUResult_o <= ALUResult_i;
		RS2data_o   <= RS2data_i;
		RDaddr_o    <= RDaddr_i;
	end
end
endmodule

module MEMWB(
	clk_i,
    RegWrite_i,
    MemtoReg_i,
	ALUResult_i,
	MemData_i,
	RDaddr_i,
	Miss_stall_i,
    RegWrite_o,
    MemtoReg_o,
	ALUResult_o,
	MemData_o,
	RDaddr_o
);
input             clk_i, RegWrite_i, MemtoReg_i, Miss_stall_i;
input      [31:0] ALUResult_i, MemData_i;
input      [4:0]  RDaddr_i;
output reg        RegWrite_o, MemtoReg_o;
output reg [31:0] ALUResult_o, MemData_o;
output reg [4:0]  RDaddr_o;

always @(posedge clk_i) begin
	if (Miss_stall_i) begin
		RegWrite_o  <= RegWrite_o;
	    MemtoReg_o  <= MemtoReg_o;
		ALUResult_o <= ALUResult_o;
		MemData_o   <= MemData_o;
		RDaddr_o    <= RDaddr_o;	
	end
	else begin
		RegWrite_o  <= RegWrite_i;
	    MemtoReg_o  <= MemtoReg_i;
		ALUResult_o <= ALUResult_i;
		MemData_o   <= MemData_i;
		RDaddr_o    <= RDaddr_i;
	end
end
endmodule