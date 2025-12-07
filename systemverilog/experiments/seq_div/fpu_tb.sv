`default_nettype none

module fpu_tb;

  logic arst;
  logic clk;
  logic [23:0] dividend;
  logic [23:0] divisor;
  logic [23:0] quotient;
  logic cmd_end;      
  logic start_operation_div_fsm;
  logic operation_done_div_fsm;

  initial begin
    clk = 0;
    forever #250ns clk = ~clk;
  end

  initial begin
    arst = 1;
    #500ns;
    arst = 0;
    dividend = 24'b100000010001001011111000;
    divisor  = 24'b11000011111101;
    start_operation_div_fsm = 1;

    @(posedge operation_done_div_fsm);
    #10us;
    $stop;
  end

  fpu fpu_top(
    .arst        (arst),
    .clk         (clk),
    .dividend(dividend),
    .divisor(divisor),
    .quotient(quotient),
    .start_operation_div_fsm(start_operation_div_fsm),
    .operation_done_div_fsm(operation_done_div_fsm)
    );


endmodule