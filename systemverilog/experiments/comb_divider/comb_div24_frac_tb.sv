`default_nettype none

module comb_div24_frac_tb;

  logic [23:0] a;
  logic [23:0] b;
  logic [23:0] quotient;

  initial begin
    a = 24'b10000000_00000000_11111111; 
    b = 24'b11111111_11111111_00000000;
    #10us;
    $display("quotient: %b", quotient);
    $stop;
  end

  comb_div24_frac div24_frac(
    .a(a),
    .b(b),
    .quotient(quotient)
  );

endmodule
