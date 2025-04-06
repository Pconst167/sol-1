module comb_div #(
  parameter int WIDTH = 24
)(
  input  logic [WIDTH - 1 : 0] a,
  input  logic [WIDTH - 1 : 0] b,
  output logic [WIDTH - 1 : 0] quotient,
  output logic [WIDTH - 1 : 0] remainder
);
  logic signed [WIDTH : 0] partial;

  always_comb begin
    partial = {{(WIDTH - 1){1'b0}}, a[WIDTH - 1]};
    for(int i = WIDTH - 1; i >= 1; i--) begin
      partial = $signed(partial) - $signed(b);
      quotient[i] = ~partial[WIDTH];
      if(quotient[i])
        partial = {1'b0, partial[WIDTH - 2 : 0], a[i-1]};
      else begin
        partial = partial + b;
        partial = {1'b0, partial[WIDTH - 2 : 0], a[i-1]};
      end
    end
    partial = $signed(partial) - $signed(b);
    quotient[0] = ~partial[WIDTH];
    if(~quotient[0]) 
      partial = partial + b;

    remainder = partial[WIDTH - 1 : 0];
  end

endmodule

