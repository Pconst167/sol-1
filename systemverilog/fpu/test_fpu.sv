module test_fpu;
  timeunit 1ns;
  timeprecision 1ps;

  logic arst;
  logic clk;
  logic [7:0] databus_in;
  logic [7:0] databus_out;
  logic [3:0] addr; 
  logic cs;
  logic rd;
  logic wr;
  logic end_ack;      // acknowledge end
  logic cmd_end;      // end of command / irq
  logic busy;   // active high when an operation is in progress
  interface_fpu in_fpu();

  // Test program
  test_program test_program_fpu(
    .in_fpu (in_fpu)
  );

  assign in_fpu.arst = `p_fpu.arst;
  assign in_fpu.clk  = `p_fpu.clk;
  assign in_fpu.errorCount = in_fpu.errorCntTb + in_fpu.errorCntAs;

  fpu fpu_top(
    .arst        (arst),
    .clk         (clk),
    .databus_in  (databus_in),
    .databus_out (databus_out),
    .addr        (addr),
    .cs          (cs),
    .rd          (rd),
    .wr          (wr),
    .end_ack     (end_ack),
    .cmd_end     (cmd_end),
    .busy        (busy)
  );

endmodule