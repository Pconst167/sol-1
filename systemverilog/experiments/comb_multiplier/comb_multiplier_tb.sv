module comb_multiplier_tb;

  logic [7:0] a;
  logic [7:0] b;
  logic [15:0] result;

  initial begin
    a = '1; 
    b = '1; 
    #10us;
    $display("%d(%b) * %d(%b) = %d(%b)", (a), a, (b), b, (result), result);
    $stop;
  end


  wallace_mul multiplier(
    .a(a),
    .b(b),
    .result(result)
  );

endmodule
