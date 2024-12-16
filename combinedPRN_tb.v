module Combined_tb;
  reg clk;
  
  // Instantiate PRN_tb2
  PRN_tb2 prn_tb2_inst ();

  // Instantiate PRN_tb
  PRN_tb prn_tb_inst ();

  // Instantiate PRNO_tb
  PRNO_tb prno_tb_inst ();

  
  initial begin
    // Initialize clock
    clk = 0;
    forever #5 clk = ~clk;  // Generate a clock with period 10 time units
  end

  initial begin
    // Run simulation
    $dumpfile("Combined_tb.vcd");
    $dumpvars(0, Combined_tb);

    // Simulation time
    #1000 $finish;
  end
endmodule

