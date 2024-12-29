module data_mem(
  input logic [31:0] addr,
  input logic [31:0] wdata,
  output logic [31:0] rdata,
  input logic dm_rd,
  input logic dm_wr,
  input logic [2:0] func3, // Additional input to differentiate load types
  input logic clk
);

logic [31:0] data_mem [32]; //32 registers of 32 bit size

//async read
always_comb //can also use assign
begin
     if(dm_rd)
     case (func3)
        3'b000: rdata = {{24{data_mem[addr][7]}}, data_mem[addr][7:0]};           // LB (Load Byte, sign-extended)
        3'b001: rdata = {{16{data_mem[addr][15]}}, data_mem[addr][15:0]};         // LH (Load Halfword, sign-extended)
        3'b010: rdata = data_mem[addr];                                           // LW (Load Word)
         3'b100: rdata = {24'b0, data_mem[addr][7:0]};                             // LBU (Load Byte Unsigned, zero-extended)
         3'b101: rdata = {16'b0, data_mem[addr][15:0]};                            // LHU (Load Halfword Unsigned, zero-extended)
        default: rdata = 32'b0;                                                    // Default case for unsupported loads
    endcase
end


//synchronous write
always_ff @(posedge clk)
begin
    if(dm_wr)
    begin
        data_mem[addr]<=wdata;
    end
end

endmodule