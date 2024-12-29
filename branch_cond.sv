module branch_cond(
    input logic  [31:0] rdata1, 
    input logic  [31:0] rdata2, 
    input logic [2:0] func3,          // Branch condition selector
    output logic br_taken             // Branch taken flag
);

always_comb begin
    case(func3)
        3'b000: // BEQ (Branch if Equal)
            br_taken = (rdata1 == rdata2);

        3'b001: // BNE (Branch if Not Equal)
            br_taken = (rdata1 != rdata2);

        3'b100: // BLT (Branch if Less Than, signed)
            br_taken = (rdata1 < rdata2);

        3'b101: // BGE (Branch if Greater or Equal, signed)
            br_taken = (rdata1 >= rdata2);

        3'b110: // BLTU (Branch if Less Than, unsigned)
            br_taken = ($unsigned(rdata1) < $unsigned(rdata2));

        3'b111: // BGEU (Branch if Greater or Equal, unsigned)
            br_taken = ($unsigned(rdata1) >= $unsigned(rdata2));

        default: // Default case (no branch)
            br_taken = 1'b0;
    endcase
end

endmodule
