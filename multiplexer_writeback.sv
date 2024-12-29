module multiplexer_writeback(

    input logic [31:0] rdata_from_datamem,
    input logic [31:0] wdata_from_alu,
    input logic [31:0] rdata_from_csr_file,
    input logic [31:0] pc,
    input logic [1:0] wb_sel, //write back selector to the register file
    output logic [31:0] wdata
);

always_comb
begin

    case(wb_sel)
    2'b00: wdata=wdata_from_alu;
    2'b01: wdata=rdata_from_datamem;
    2'b10: wdata=pc+32'd4;
    2'b11: wdata=rdata_from_csr_file;

    endcase
end


endmodule