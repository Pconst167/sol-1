module fpu(
  input logic [7:0] int_in,

  output logic [31:0] fp_out
);

  logic sign_in;
  logic [7:0] exp_in;
  logic [22:0] mantissa_in;
  logic [3:0] leading_zeroes;

  logic [31:0] one_over_255 = 32'h3b808081;

  logic [22:0] c_mantissa;
  logic [7:0] c_exp;
  logic [47:0] mul_result;

  logic [7:0] result_exp;
  logic [23:0] result_mantissa;

  logic [31:0] error;

  logic [23:0] m1;
  logic [23:0] m2;

  logic a, b, c, d, e, f, g, h;

  always_comb begin
    a = !int_in[7];
    b = a && !int_in[6];
    c = b && !int_in[5];
    d = c && !int_in[4];
    e = d && !int_in[3];
    f = e && !int_in[2];
    g = f && !int_in[1];
    h = g && !int_in[0];

    if(h) leading_zeroes = 8;
    else if(g) leading_zeroes = 7;
    else if(f) leading_zeroes = 6;
    else if(e) leading_zeroes = 5;
    else if(d) leading_zeroes = 4;
    else if(c) leading_zeroes = 3;
    else if(b) leading_zeroes = 2;
    else if(a) leading_zeroes = 1;
    else leading_zeroes = 0;
  end
  
  always_comb begin
    sign_in = 1'b0;
    exp_in = 127 + 7 - leading_zeroes;
    mantissa_in = {int_in, 15'b0};
    mantissa_in = mantissa_in << leading_zeroes + 1;
    fp_out = {sign_in, exp_in, mantissa_in};

    // divide by 256
    fp_out = {sign_in, exp_in - 8, mantissa_in};

    // the error is n/65280
    // so add back n/65536 which is close to it
    error = {1'b0, exp_in - 16, mantissa_in}; // form 1/65536

    m1 = {1'b1, mantissa_in}; 
    m2 = {1'b1, mantissa_in} >> 8; // normalize for addition

    result_mantissa = m1 + m2;

    fp_out = {1'b0, exp_in - 8, result_mantissa[22:0]};

  end

/*  
  always_comb begin
    sign_in = 1'b0;
    exp_in = 127 + 7 - leading_zeroes;
    mantissa_in = {int_in, 15'b0};
    mantissa_in = mantissa_in << leading_zeroes + 1;
    fp_out = {sign_in, exp_in, mantissa_in};

    c_mantissa = one_over_255[22:0];
    c_exp = one_over_255[30:23];

    mul_result = {1'b1, c_mantissa} * {1'b1, mantissa_in};
    result_exp = exp_in - 127 + c_exp - 127;
    while(mul_result[47] == 1'b0) begin
      mul_result = mul_result << 1;
    end

    result_exp = result_exp + 127;

    fp_out = {1'b0, result_exp, mul_result[46:24]};
  end
*/
endmodule