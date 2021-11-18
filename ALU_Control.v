module ALU_Control(
    funct_i,
    ALUOp_i,
    ALUCtrl_o
);

// Ports
input   [1:0]       ALUOp_i;
input   [9:0]       funct_i;
output  [2:0]       ALUCtrl_o;

assign ALUCtrl_o[2] = funct_i[8] || funct_i[3] || !ALUOp_i[0];
assign ALUCtrl_o[1] = !ALUOp_i[0] || (!funct_i[8] && !funct_i[3] && !funct_i[2]);
assign ALUCtrl_o[0] = (funct_i[8] && funct_i[0]) || (!funct_i[8] && !funct_i[0] && ALUOp_i[0]);

endmodule