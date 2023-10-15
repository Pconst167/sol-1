module uart(
  input logic arst,
  input logic clk,
  input logic ce_n,
  input logic oe_n,
  input logic we_n,
  input logic [2:0] address,
  input logic [7:0] data_in,

  output logic [7:0] data_out
);
  import pa_testbench::*;


  assign data_out = !ce_n && !oe_n && we_n ? 8'hFF : 'z;

endmodule

