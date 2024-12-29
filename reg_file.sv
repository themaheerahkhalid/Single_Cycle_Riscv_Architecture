module reg_file(
    input logic clk,
    input logic rf_en,
    input logic [4:0] rs1, //address of register
    input logic [4:0] rs2,
    input logic [4:0] rd,
    input logic [31:0] wdata,
    output logic [31:0] rdata1, //value of register
    output logic [31:0] rdata2
);

logic [31:0] reg_mem [32]; //32 registers of 32 bit size


//async read
always_comb //can also use assign
begin
    rdata1=reg_mem[rs1];
    rdata2=reg_mem[rs2];
end

//synchronous write
always_ff @(posedge clk)
begin
    if(rf_en)
    begin
        reg_mem[rd]<=wdata;
    end
end
endmodule