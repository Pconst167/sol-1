// fractional combinational divider designed specifically for dividing mantissas together.
// mantissas necessarily have their MSB be 1.
// 24bits divided by 24bits. result is 1 integer bit plus 23 fractional bits

module comb_div24_frac(
  input logic [23:0] a,
  input logic [23:0] b,
  output logic [23:0] quotient
);
  logic signed [25:0] partial; // 1 extra bit for sign, 1 extra bit for fractional operations

  // since operads are 24 bits each, the partials are formed by adding one extra 'sign' bit to it, so that we can perform
  // a signed subtraction for each run. this extra sign bit is then checked to decide whether the result was positive or negative.
  // if positive(0) then the corresponding quotient bit is 1.
  // the bit after MSB is also exra and exists in order for the divider to be able to perform fractional divisions.
  always_comb begin
    partial = {2'b0, a};
    for(int i = 23; i >= 1; i--) begin
      // IMPORTANT: b needs explicit size casting. if the expression was just $signed(partial)-$signed(b), then the sign extension combined with width extension would change the value of the subtraend if the MSB of subtraend was 1.
      // for example if b = 1000, sign extending it to 6bits makes it 111000, and that would be the value that would be subtracted instead of 001000.
      // so we need to first cast it to a larger width, and then apply $signed(). this casts 1000 to 001000 first, and then does a signed subtraction.
      partial = $signed(partial) - $signed($bits(partial)'(b)); 
      quotient[i] = ~partial[25];
      if(quotient[i]) begin
        partial = {1'b0, partial[23:0], a[i - 1]}; // form a new partial by using ever decreasing indexed bits of 'a'. after bit0, use 0 instead
      end
      else begin
        partial = partial + b;
        partial = {1'b0, partial[23:0], a[i - 1]};  // form a new partial by using ever decreasing indexed bits of 'a'. after bit0, use 0 instead
      end
    end
    partial = $signed(partial) - $signed($bits(partial)'(b));
    quotient[0] = ~partial[25];
    if(~quotient[0]) 
      partial = partial + b;
  end

endmodule

