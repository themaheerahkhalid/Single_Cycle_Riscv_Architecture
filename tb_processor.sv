module tb_processor();
    logic clk;
    logic rst;

    processor dut
    (
        .clk(clk),
        .rst(rst)
    );

    // Clock Generator
    initial
    begin
        clk = 0;
        forever
        begin
            #5 clk = ~clk;
        end
    end

    // Reset generator
    initial
    begin
        rst = 1;
        #10;
        rst = 0;
        #5000; // Increased time for instruction execution
        $finish;
    end

    initial //initializng csr file
    begin
        #10 rst = 0; // Deassert reset
    #5 $readmemb("csr_file", dut.CSR_register_file_inst.csr_mem); // Initialize after reset
    end

    // Initializing memory
    initial
    begin
        $readmemb("instruction_memory", dut.imem.mem);
        $readmemb("register_file", dut.reg_file_inst.reg_mem);
        $readmemb("data_memory", dut.data_mem_inst.data_mem);
      
    end

    // Dumping output
    initial
    begin
        $dumpfile("processor.vcd");
        $dumpvars(0, tb_processor);
        $dumpvars(1, dut.reg_file_inst.reg_mem); // Dump register file values
        $dumpvars(2, dut.data_mem_inst.data_mem);
        $dumpvars(3, dut.CSR_register_file_inst.csr_mem);
    end

    // Monitor register outputs
    initial
    begin
        $monitor("Time: %0t | x3: %b | x4: %b | x2: %b", $time, dut.reg_file_inst.reg_mem[3], dut.reg_file_inst.reg_mem[4], dut.reg_file_inst.reg_mem[2]);
    end
endmodule
