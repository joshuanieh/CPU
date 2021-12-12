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
input        NoOp_i;
input  [6:0] Op_i;
output [1:0] ALUOp_o;
output       ALUSrc_o, RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, Branch_o;

assign Branch_o   = (~ NoOp_i) && Op_i[6];
assign ALUSrc_o   = (~ NoOp_i) && ((~ Op_i[5]) || (~ Op_i[4]));
assign ALUOp_o    = (~ NoOp_i) & Op_i[5:4];
assign MemWrite_o = (~ NoOp_i) && ((~ Op_i[6]) && Op_i[5] && (~ Op_i[4]));
assign MemRead_o  = (~ NoOp_i) && ((~ Op_i[5]) && (~ Op_i[4]));
assign MemtoReg_o = MemRead_o;
assign RegWrite_o = (~ NoOp_i) && ((~ Op_i[5]) || Op_i[4]);

endmodule
