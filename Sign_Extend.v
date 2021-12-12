module Sign_Extend(
    data_i,
    data_o
);

// Ports
input   [31:0]      data_i;
output  [31:0]      data_o;

wire [31:0] data_678 = {{20{data_i[31]}}, data_i[31:20]};
wire [31:0] data_9   = {{20{data_i[31]}}, data_i[31:25], data_i[11:7]};
wire [31:0] data_10  = {{20{data_i[31]}}, data_i[31], data_i[7], data_i[30:25], data_i[11:8]};

assign data_o = data_i[5] ? (data_i[13] ? data_9 : data_10) : data_678;
endmodule