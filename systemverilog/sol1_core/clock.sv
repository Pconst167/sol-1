module clock #(
  parameter FREQ = 2.75 // MHz
)(
	input logic arst,
	input logic stop_clk_req,
	output logic clk_out
);
  logic clk;
  logic stop_clk;
  real period = 1.0 / FREQ;
  real halfperiod = period / 2.0;

  initial begin
    clk = 1'b0;
    forever #(halfperiod / 2.0 * 1us) clk = ~clk; // Use halfperiod / 2 instead of halfperiod because clock_out is clk / 2
  end

  always @(negedge clk) begin
    stop_clk <= stop_clk_req;
  end

	always @(posedge clk, posedge arst) begin
    if(arst) clk_out <= 1'b1; // clock starts HIGH so that control bits can be written on the first falling edge.
		else if(!stop_clk) clk_out <= ~clk_out;
	end

endmodule
