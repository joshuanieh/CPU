module ALU_Control(
    funct_i,
    ALUOp_i,
    ALUCtrl_o
);

// Ports
input   [1:0]       ALUOp_i;
input   [9:0]       funct_i;
output  [2:0]       ALUCrtl_o;

if(ALUOp_i === 2'b01)
  if(funct_i[2:0] === 3'b000)
    ALUCrtl_o = 3'b110;
  else
    ALUCrtl_o = 3'b111;
else
  if(funct_i[2:0] === 3'b111)
    ALUCrtl_o = 3'b000;
  else if(funct_i[2:0] === 3'b100)
    ALUCrtl_o = 3'b001;
  else if(funct_i[2:0] === 3'b001)
    ALUCrtl_o = 3'b010;
  else
    if(funct_i[8] === 1'b1)
      ALUCrtl_o = 3'b100;
    else if(funct_i[3] === 1'b1)
      ALUCrtl_o = 3'b101;
    else
      ALUCrtl_o = 3'b011;
endmodule