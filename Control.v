module Control(
    Op_i,
    ALUOp_o,
    ALUSrc_o,
    RegWrite_o
);

// Ports
input   [6:0]       Op_i;
output  [1:0]       ALUOp_o;
output              ALUSrc_o;
output              RegWrite_o;

assign RegWrite_o = 1'b1;
assign ALUSrc_o = ~ Op_i[5];
assign ALUOp_o = Op_i[6:5];

endmodule
