module alu(
  input logic [7:0] a,
  input logic [7:0] b,
  input logic cf_in,
  input logic [3:0] op,
  input logic mode,

  output logic [7:0] alu_out,
  output logic alu_cf_out
);
  logic temp_cf_out;

  always_comb begin
    case(op)
      4'b0000: begin
        {temp_cf_out, alu_out} = mode ? ~a : a + {7'b0, ~cf_in};
        alu_cf_out = ~temp_cf_out;
      end
      4'b0001: begin
        {temp_cf_out, alu_out} = mode ? ~(a | b) : (a | b) + {7'b0, ~cf_in};
        alu_cf_out = ~temp_cf_out;
      end
      4'b0010: begin
        {temp_cf_out, alu_out} = mode ? ~a & b : (a | ~b) + {7'b0, ~cf_in};
        alu_cf_out = ~temp_cf_out;
      end
      4'b0011: begin
        {temp_cf_out, alu_out} = mode ? 8'h00 : 8'hFF + {7'b0, ~cf_in}; // -1 + {7'b0, ~cf_in}
        alu_cf_out = ~temp_cf_out;
      end
      4'b0100: begin
        {temp_cf_out, alu_out} = mode ? ~(a & b) : a + (a & ~b) + {7'b0, ~cf_in};
        alu_cf_out = ~temp_cf_out;
      end
      4'b0101: begin
        {temp_cf_out, alu_out} = mode ? ~b : (a | b) + (a & ~b) + {7'b0, ~cf_in};
        alu_cf_out = ~temp_cf_out;
      end
      4'b0110: begin
        {temp_cf_out, alu_out} = mode ? a ^ b : a - b - {7'b0, cf_in};
        alu_cf_out = temp_cf_out;
      end
      4'b0111: begin
        {temp_cf_out, alu_out} = mode ? a & ~b : a & ~b - {7'b0, cf_in};
        alu_cf_out = temp_cf_out;
      end
      4'b1000: begin
        {temp_cf_out, alu_out} = mode ? ~a | b : a + (a & b) + {7'b0, ~cf_in};
        alu_cf_out = ~temp_cf_out;
      end
      4'b1001: begin
        {temp_cf_out, alu_out} = mode ? ~(a ^ b) : a + b + {7'b0, ~cf_in};
        alu_cf_out = ~temp_cf_out;
      end
      4'b1010: begin
        {temp_cf_out, alu_out} = mode ? b : (a | ~b) + (a & b) + {7'b0, ~cf_in};
        alu_cf_out = ~temp_cf_out;
      end
      4'b1011: begin
        {temp_cf_out, alu_out} = mode ? a & b : a & b - {7'b0, cf_in};
        alu_cf_out = temp_cf_out;
      end
      4'b1100: begin
        {temp_cf_out, alu_out} = mode ? 8'h01 : a + a + {7'b0, ~cf_in};
        alu_cf_out = ~temp_cf_out;
      end
      4'b1101: begin
        {temp_cf_out, alu_out} = mode ? a | ~b : (a | b) + a + {7'b0, ~cf_in};
        alu_cf_out = ~temp_cf_out;
      end
      4'b1110: begin
        {temp_cf_out, alu_out} = mode ? a | b : (a | ~b) + a + {7'b0, ~cf_in};
        alu_cf_out = ~temp_cf_out;
      end
      4'b1111: begin
        {temp_cf_out, alu_out} = mode ? a : a - {7'b0, cf_in};
        alu_cf_out = temp_cf_out;
      end
    endcase
  end


endmodule
