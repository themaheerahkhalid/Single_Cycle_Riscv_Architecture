module inst_dec
(
    input logic [31:0] inst,
    output logic [6:0] opcode,
    output logic [2:0] func3,
    output logic [6:0] func7,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [4:0] rd
);

//to controller
assign opcode =inst[6:0]; //because writing is synchronous and reading is asynchronous
assign func7=inst [31:25];
assign func3=inst[14:12];

//to register
assign rs1=inst[19:15];
assign rs2=inst[24:20];
assign rd=inst[11:7];

endmodule