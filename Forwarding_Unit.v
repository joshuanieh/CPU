module Forwarding_Unit(
    RS1addr_i,
    RS2addr_i,
    RDaddrM_i,
    RegWriteM_i,
    RDaddrW_i,
    RegWriteW_i,
    ForwardA_o,
    ForwardB_o
);

// Ports
input        RegWriteM_i, RegWriteW_i;
input  [4:0] RDaddrM_i, RDaddrW_i, RS1addr_i, RS2addr_i;
output [1:0] ForwardA_o, ForwardB_o;
/*
if (EX/MEM.RegWrite
and (EX/MEM.RegisterRd != 0)
and (EX/MEM.RegisterRd == ID/EX.RegisterRs1)) ForwardA = 10
*/
wire cA1 = RegWriteM_i & (RDaddrM_i !== 5'b0) & (RDaddrM_i === RS1addr_i);
wire cB1 = RegWriteM_i & (RDaddrM_i !== 5'b0) & (RDaddrM_i === RS2addr_i);

/*
if (MEM/WB.RegWrite
and (MEM/WB.RegisterRd != 0)
and not(EX/MEM.RegWrite and (EX/MEM.RegisterRd != 0)
and (EX/MEM.RegisterRd == ID/EX.RegisterRs1))
and (MEM/WB.RegisterRd == ID/EX.RegisterRs1)) ForwardA = 01
*/
wire cA2 = RegWriteW_i & (RDaddrW_i !== 5'b0) & (RDaddrW_i === RS1addr_i);
wire cB2 = RegWriteW_i & (RDaddrW_i !== 5'b0) & (RDaddrW_i === RS2addr_i);

wire [1:0] tmpA = cA2 ? 2'b01 : 2'b00;
assign ForwardA_o = cA1 ? 2'b10 : tmpA;
wire [1:0] tmpB = cB2 ? 2'b01 : 2'b00;
assign ForwardB_o = cB1 ? 2'b10 : tmpB;
endmodule