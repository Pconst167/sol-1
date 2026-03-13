`default_nettype none

module comb_div_24_tb;

  logic [23:0] a;
  logic [23:0] b;
  logic [23:0] quotient;
  logic [23:0] remainder;

  initial begin
    a = 24'd215; 
    b = 24'd5; 
    #10us;

    $stop;
  end

  comb_div_24 #(
    .WIDTH(24)
  ) div24 (
    .a(a),
    .b(b),
    .quotient(quotient),
    .remainder(remainder)
  );
endmodule
