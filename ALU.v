module ALU(
    data1_i,
    data2_i,
    ALUCtrl_i,
    data_o,
    Zero_o
);

// Ports
input   [31:0]      data1_i, data2_i;
input   [2:0]       ALUCtrl_i;
output  [31:0]      data_o;
output              Zero_o;

reg     [31:0]      data_o;
data_o = data1_i & data2_i;
'define AND  3'b000
'define XOR  3'b001
'define SLL  3'b010
'define ADD  3'b011
'define SUB  3'b100
'define MUL  3'b101
'define ADDI 3'b110
'define SRAI 3'b111

always @ (data1_i or data2_i or ALUCtrl_i)
begin
  case (ALUCtrl_i)
    'AND: data_o = data1_i & data2_i;
    'XOR: data_o = data1_i ^ data2_i;
    'SLL: data_o = data1_i << data2_i;
    'ADD: data_o = data1_i + data2_i;
    'SUB: data_o = data1_i - data2_i;
    'MUL: data_o = data1_i * data2_i;
    'ADDI: data_o = data1_i + data2_i;
    'SRAI: 
      reg [31:0] tmp;
      tmp = data1_i >> data2_i;
      data_o = data1_i[31] ? {data2_i{1'b1}, tmp[31-data2_i:0]} : tmp;
end

endmodule