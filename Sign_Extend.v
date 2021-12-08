module Sign_Extend(
    data_i,
    data_o
);

// Ports
input   [31:0]      data_i;
output  [31:0]      data_o;

wire data_789 = {{20{data_i[31]}}, data_i[31:20]};
wire data_10  = {{20{data_i[31]}}, data_i[31:25], data_i[11:7]};
wire data_11  = {{20{data_i[31]}}, data_i[31], data_i[7], data_i[30:25], data_i[11:8]};

assign data_o = data_i[5] ? (data_i[13] ? data_10 : data_11) : data_789;
endmodule