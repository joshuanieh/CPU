module Hazard_Detection_Unit(
    MemRead_i,
    RDaddr_i,
    RS1addr_i,
    RS2addr_i,
    NoOp_o,
    Stall_o,
    PCWrite_o
);

// Ports
input        MemRead_i;
input  [4:0] RDaddr_i, RS1addr_i, RS2addr_i;
output       NoOp_o, Stall_o, PCWrite_o;

assign tmp       = (RDaddr_i == RS1addr_i) | (RDaddr_i == RS2addr_i);
assign NoOp_o    = (RDaddr_i !== 5'b0) & MemRead_i & tmp;
assign Stall_o   = NoOp_o;
assign PCWrite_o = ~ NoOp_o;
endmodule