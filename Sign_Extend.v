module Sign_Extend(
    data_i,
    data_o
);

// Ports
input   [11:0]      data_i;
output  [31:0]      data_o;

assign data_o = data_i[11] ? {{20{1'b1}}, data_i} : {{20{1'b0}}, data_i};

endmodule