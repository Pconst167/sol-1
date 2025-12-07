module exp_tb;

  logic [3:0] a = 4'b1111;
  logic [3:0] b = 4'b0001;

  logic [4:0] c;
  logic [4:0] d;
  logic clk = 0;

  logic A, B, C, D;

  initial begin
    $display("val: %d", $clog2(4));
    #20us;
    $stop;
  end

  always #1us clk = ~clk;

  always_ff @(posedge clk) begin

  end

  assign c = {1'b0, a} + {1'b0, b}; 

  sequence s1;
    1 ##1 1 ##1 0;
  endsequence
  sequence s2;
    1 ##1 1 ##1 0;
  endsequence

  property p1;
    @(posedge clk) s1 ##1 s2 ##2 s1 |=> s1 and s1;
  endproperty

  cover property(p1);
endmodule
