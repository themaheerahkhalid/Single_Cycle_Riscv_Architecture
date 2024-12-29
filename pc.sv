module pc(
    input logic clk,
    input logic rst,
    input logic [31:0] pc_in,
    output logic [31:0] pc_out
);

always_ff @(posedge clk or posedge rst ) 
begin
    if(rst)
    begin
        pc_out<=0;
    end
    else
    begin
        pc_out<=pc_in;
    end
end

endmodule