module sign_extend(
 input logic [11:0] imm,
 output logic [31:0] sign_extended_imm
);

always_comb begin

    // Sign extension by replicating the most significant bit of the 12-bit input (imm[11])
    sign_extended_imm = {{20{imm[11]}}, imm}; 
end

endmodule