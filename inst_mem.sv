module inst_mem(
    input logic [31:0] addr,
    output logic [31:0] data
);

logic[31:0] mem [100]; //instruction mem with 100 rows, each row 32 bits

always_comb 
begin 
    //word addressable memory
    data=mem[addr[31:2]]; //right shift for division by 4
    //$display("Data at addr %b," data)
    
end

endmodule