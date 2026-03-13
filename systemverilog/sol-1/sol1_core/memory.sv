module memory #(
  parameter MEM_SIZE
)(
  input logic ce_n,
  input logic oe_n,
  input logic we_n,
  input logic [$clog2(MEM_SIZE) - 1 : 0] address,
  input logic [7:0] data_in,
  output logic [7:0] data_out
);

  logic [7:0] mem [MEM_SIZE - 1 : 0];

  assign data_out = !ce_n && !oe_n && we_n ? mem[address] : 'z;

  always @(ce_n, we_n, data_in) begin
    if(!ce_n && !we_n) mem[address] = data_in;
  end

endmodule
