module Control(
    Op_i,
    NoOp_i,
    ALUOp_o,
    ALUSrc_o,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    Branch_o
);

// Ports
input   [6:0]       Op_i;
output  [2:0]       ALUOp_o;
output              ALUSrc_o, RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o;

assign Branch_o   = (~ NoOp_i) && Op_i[6];
assign ALUSrc_o   = (~ NoOp_i) && ((~ Op_i[5]) || (~ Op_i[4]));
assign ALUOp_o    = (~ NoOp_i) & Op_i[6:4];
assign MemWrite_o = (~ NoOp_i) && ((~ Op_i[6]) && Op_i[5] && (~ Op_i[4]));
assign MemRead_o  = (~ NoOp_i) && ((~ Op_i[5]) && (~ Op_i[4]));
assign MemtoReg_o = MemRead_i;
assign RegWrite_o = (~ NoOp_i) && ((~ Op_i[5]) || Op_i[4]);

endmodule
