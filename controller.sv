module controller(
    input logic [6:0] opcode,
    input logic [2:0] func3,
    input logic [6:0] func7,
    output logic [3:0] aluop, 
    output logic rf_en,
    output logic imm_en,
    output logic dm_rd,
    output logic dm_wr,
    output logic [1:0 ]wb_sel,
    output logic sel_a,
    output logic j_en,
    output logic csr_rd,
    output logic csr_wr,
    output logic trap,
    output logic is_mret

   // output logic shift_en
);

always_comb
begin
    // Default signal values (reset conditions)
   
    csr_rd = 1'b0;
    csr_wr = 1'b0;
    rf_en = 1'b0;
    imm_en = 1'b0;
    wb_sel = 2'b00;
    sel_a = 1'b0;
    aluop = 4'b0000;
    dm_rd = 1'b0;
    dm_wr = 1'b0;
    j_en=1'b0;
    trap = 1'b0;
    is_mret = 1'b0;
 
    case (opcode)
        7'b1110011: //CSR
            begin
                wb_sel=2'b11; //writeback value from csr
                unique case (func3)
                3'b001: csr_wr=1'b1;
                3'b010:  csr_rd=1'b1;
                3'b000: // Handle ECALL, EBREAK, MRET
                begin
                    unique case (func7)
                        7'b0000000: trap = 1'b1; // ECALL
                        7'b0000001: trap = 1'b1; // EBREAK
                        7'b0011000: is_mret = 1'b1; // MRET
                    endcase
                end
                
            endcase
            end

        7'b0110011: //R type
        begin
            rf_en=1'b1;
            imm_en=1'b0;
            unique case (func3) 
                3'b000:
                begin
                    unique case (func7)
                    7'b0000000: aluop=4'b0000; //ADD, four bits for 10 instructions
                    7'b0100000: aluop= 4'b0001; //SUB
                    7'b0000001: aluop=4'b1111; //MUL extension
                    endcase
                end

                3'b001: aluop=4'b0010; //SLL
                3'b010: aluop=4'b0011; //SLT
                3'b011: aluop=4'b0100; //SLTU
                3'b100: aluop= 4'b0101; //XOR
                3'b101: 
                    begin
                        
                        unique case(func7)
                            7'b0000000: aluop= 4'b0110; //SRL
                            7'b0100000: aluop= 4'b0111; //SRA
                        endcase
                    end
                    3'b110: aluop= 4'b1000; //OR
                    3'b111: aluop= 4'b1001; //AND
        endcase

        end
        

        7'b0010011: //I type
         begin
            rf_en = 1'b1;
            imm_en=1'b1;
            unique case (func3)
                3'b000: aluop = 4'b0000; // ADDI
                3'b001: begin
                            aluop = 4'b0010; // SLLI
                           // shift_en = 1'b1; // Enable shift
                        end
                 
                3'b010: aluop = 4'b0011; // SLTI (Set Less Than Immediate)
                3'b011: aluop = 4'b0100; // SLTIU (Set Less Than Unsigned Immediate)
                3'b100: aluop = 4'b0101; // XORI (XOR Immediate)
               
                3'b101: 
                begin
                   // shift_en=1'b1;
                    unique case (func7)
                        7'b0000000: aluop = 4'b0110; // SRLI (Shift Right Logical Immediate)
                        7'b0100000: aluop = 4'b0111; // SRAI (Shift Right Arithmetic Immediate)
                    endcase
                end
                3'b110: aluop = 4'b1000; // ORI (OR Immediate)
                3'b111: aluop = 4'b1001; // ANDI (AND Immediate)
              
            endcase
        end

        7'b0000011: // I-type Load
        begin
            rf_en = 1'b1;
            imm_en = 1'b1;
            wb_sel=2'b01;
            dm_rd = 1'b1;
            unique case (func3)
                3'b000: aluop = 4'b0000; // LB (Load Byte)
                3'b001: aluop = 4'b0000; // LH (Load Halfword)
                3'b010: aluop = 4'b0000; // LW (Load Word)
                3'b100: aluop = 4'b0000; // LBU (Load Byte Unsigned)
                3'b101: aluop = 4'b0000; // LHU (Load Halfword Unsigned)
            endcase
        end

        7'b0100011: // S-type Store
        begin
            rf_en = 1'b0;
            imm_en = 1'b1;
            dm_wr = 1'b1;
            unique case (func3)
                3'b000: aluop = 4'b0000; // SB (Store Byte)
                3'b001: aluop = 4'b0000; // SH (Store Halfword)
                3'b010: aluop = 4'b0000; // SW (Store Word)
            endcase
        end

        7'b0110111: // U-type LUI
        begin
            rf_en = 1'b1;
            imm_en = 1'b1;
            aluop = 4'b1100; // LUI
        end

        7'b0010111: // U-type AUIPC
        begin
            rf_en = 1'b1;
            imm_en = 1'b1;
            sel_a=1'b1;
            aluop = 4'b1101; // AUIPC
        end           
        default:
            rf_en = 1'b0; // Disable register file if unsupported opcode

        // Branch (B-type)
        7'b1100011: 
        begin
            imm_en = 1'b1; // Immediate is used for PC offset
            aluop = 4'b0000; // ADD
            sel_a=1'b1; //select pc addr for opr_a
            rf_en = 1'b0; // No register write-back
        end

        // Jump (J-type)
        7'b1101111: // JAL
        begin
            imm_en = 1'b1; // Immediate is used for PC offset
            aluop = 4'b0000; // ADD
            sel_a=1'b1;
            rf_en = 1'b1; // Write return address to rd
            wb_sel = 2'b10; // Select PC + 4 for write-back
            j_en=1'b1;
        end

        7'b1100111: // JALR
        begin
            imm_en = 1'b1; // Immediate is used for PC offset
            aluop = 4'b0000; // ADD
            rf_en = 1'b1; // Write return address to rd
            wb_sel = 2'b10; // Select PC + 4 for write-back
            j_en=1'b1;
        end

    endcase
end

// initial begin
//     $monitor("Time: %0t | opcode: %b | func3: %b | func7: %b" );
// end

endmodule