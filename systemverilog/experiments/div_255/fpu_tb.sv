`default_nettype none

module fpu_tb;

  logic [31:0] fp_out;
  logic [7:0] int_in;


  initial begin
    int_in = 8'b10101010; 
    #10us;

    $stop;
  end

  fpu fpu_top(
    .int_in,
    .fp_out
  );

endmodule