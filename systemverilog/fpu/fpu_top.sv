module fpu(
  input  logic    [31:0] a_operand,
  input  logic    [31:0] b_operand,
  input pa_fpu::e_fpu_op operation, // arithmetic operation to be performed
  output logic    [31:0] ieee_packet_out
);

  logic  [25:0] a_mantissa; // 24 bits plus 2 upper guard bits for dealing with signed arithmetic
  logic [25:-3] a_mantissa_adjusted;
  logic [25:-3] a_mantissa_signed;
  logic   [7:0] a_exp;
  logic   [7:0] a_exp_adjusted;
  logic         a_sign;

  logic  [25:0] b_mantissa;  // 24 bits plus 2 upper guard bits for dealing with signed arithmetic
  logic [25:-3] b_mantissa_adjusted;  // 24 mantissa, 2 upper guards for signed arithmetic, 3 lower rounding guard bits
  logic [25:-3] b_mantissa_signed; // 24 mantissa, 2 upper guards for signed arithmetic, 3 lower rounding guard bits
  logic   [7:0] b_exp;
  logic   [7:0] b_exp_adjusted;
  logic         b_sign;

  logic              sticky_bit; // sticky bit is used for whichever number has the smallest exponent and is shifted right for alignment during add or sub operations
  logic signed [8:0] ab_exp_diff;

  // sign bit for result_m_addsub is at bit 25, so that we have an extra bit position at bit 24 which is the carry bit from bit 23 
  // so the idea is that we don't simply extend a mantissa value by one bit, we extend it by 2 bits so we always have one bit of space for the carry
  // that can come out of bit 23
  // addition/subtraction datapath
  logic [25:-3] result_m_addsub_prenorm;  // 24 bits plus carry plus 3 guard bits
  logic [25:-3] result_m_addsub_prenorm_abs;      // 24 bits plus carry plus 3 guard bits
  logic [25:-3] result_m_addsub_prenorm_24;   // 24 bits plus carry plus 3 guard bits
  logic [25:-3] result_m_addsub_norm;     // after first normalization
  logic [25:-3] result_m_addsub_subnorm_check;
  logic  [25:0] result_m_addsub_rounded;  // after rounding
  logic  [25:0] result_m_addsub_renorm;   // renormalization after rounding (if there is a carry after rounding up)
  logic  [22:0] result_m_addsub;          // 23 bits for final mantissa
  logic   [7:0] result_e_addsub_prenorm_24;
  logic   [7:0] result_e_addsub_norm;  
  logic   [7:0] result_e_addsub_renorm;   
  logic   [7:0] result_e_addsub;
  logic         result_s_addsub;
  logic   [5:0] zcount_addsub;
  logic   [4:0] addsub_effective_normalization_shift;

  logic         addsub_guard; // guard bits
  logic         addsub_round; 
  logic         addsub_sticky;

  // multiplication datapath
  logic [47:0] product_pre_norm;     // result after multiplication
  logic [47:0] product_norm;         // after first normalization
  logic [48:0] product_norm2;        // after first normalization
  logic [22:0] product_renorm;       // after second normalization (after rounding)
  logic [24:0] product_rounded;      // after rounding
  logic [22:0] result_mantissa_mul;  // final value
  logic [ 7:0] result_exp_mul;       // final exponent
  logic        result_sign_mul;      // resulting sign
  logic [ 8:0] mul_exp_sum;          // exponent sum for checking exponents smaller than -127
  logic [ 8:0] mul_exp_shift1;         // normalized exponent
  logic [ 8:0] mul_exp_renorm;       // exponent after renormalization
  logic        mul_is_subnormal;

  // division datapath 
  logic [7:0]  exp_div_prenorm;
  logic [7:0]  exp_div_norm;
  logic [23:0] div_quotient_prenorm_out;
  logic [23:0] quotient_mantissa_div_norm;
  logic [4:0]  zcount_div;
  logic [22:0] result_mantissa_div;
  logic [ 7:0] result_exp_div;
  logic        result_sign_div;
  
  // float2int
  logic [31:0] result_float2int;

  logic start_operation_ar_fsm;  // ...
  logic operation_done_ar_fsm;   // for handshake between main fsm and arithmetic fsm

  // logarithm
  logic [30:0] log2_prenorm;       
  logic [30:0] log2_norm;       
  logic [30:0] log2_abs;       
  logic  [7:0] log2_exp_prenorm;       
  logic  [7:0] log2_exp_norm;       
  logic  [5:0] log2_zcount;
  logic        log2_sign;

  // status
  logic a_nan, a_one, a_inf, a_pos_inf, a_neg_inf, a_zero;
  logic a_subnormal;
  logic b_nan, b_one, b_inf, b_pos_inf, b_neg_inf, b_zero;
  logic b_subnormal;
  // for multiplication
  logic zero_inf_or_inf_zero;
  logic inf_or_inf;
  logic zero_or_zero;
  // for division
  logic zero_and_zero;
  logic zero_inf;
  logic inf_zero;
  // unused
  logic nan_or_nan;
  logic nan_inf_or_inf_nan;
  logic zero_nan_or_nan_zero;

  // ---------------------------------------------------------------------------------------------------------------------------------------------------

  function integer min(integer a, integer b);
    return a < b ? a : b;
  endfunction

  function integer unsigned abs(integer a);
    return a < 0 ? -a : a;
  endfunction

  // counts number of leading zeroes
  function logic [5 : 0] lzc32(
    input logic [31:0] a
  );
    for(int unsigned i = 0; i < 32; i++) begin
      if(a[31 - i]) return (6)'(i);
    end

    return (6)'(32);    
  endfunction

  // counts number of leading zeroes
  function logic [5 : 0] lzc48(
    input logic [47:0] a
  );
    for(int unsigned i = 0; i < 48; i++) begin
      if(a[47 - i]) return (6)'(i);
    end

    return (6)'(48);    
  endfunction

  assign a_nan       = a_operand[30:23] == 8'hff && |a_operand[22:0];
  assign a_one       = a_operand == 32'h3f800000;
  assign a_zero      = a_operand[30:23] == 8'h00 &&  a_operand[22:0] == 23'h0;
  assign a_inf       = a_operand[30:23] == 8'hff &&  a_operand[22:0] == 23'h0;
  assign a_pos_inf   = a_operand[31] == 1'b0 &&  a_inf;
  assign a_neg_inf   = a_operand[31] == 1'b1 &&  a_inf;
  assign a_subnormal = a_operand[30:23] == 8'h00 && |a_operand[22:0];

  assign b_nan       = b_operand[30:23] == 8'hff && |b_operand[22:0];
  assign b_one       = b_operand == 32'h3f800000;
  assign b_zero      = b_operand[30:23] == 8'h00 &&  b_operand[22:0] == 23'h0;
  assign b_inf       = b_operand[30:23] == 8'hff &&  b_operand[22:0] == 23'h0;
  assign b_pos_inf   = b_operand[31] == 1'b0 &&  b_inf;
  assign b_neg_inf   = b_operand[31] == 1'b1 &&  b_inf;
  assign b_subnormal = b_operand[30:23] == 8'h00 && |b_operand[22:0];

  assign zero_or_zero         = a_zero || b_zero;
  assign zero_and_zero        = a_zero && b_zero;
  assign zero_nan_or_nan_zero = a_zero && b_nan || a_nan && b_zero;
  assign zero_inf_or_inf_zero = a_zero && b_inf || a_inf && b_zero;
  assign nan_or_nan           = a_nan  || b_nan;
  assign nan_inf_or_inf_nan   = a_nan  && b_inf || a_inf && b_nan;
  assign inf_or_inf           = a_inf  || b_inf;
  assign zero_inf             = a_zero && b_inf;
  assign inf_zero             = a_inf  && b_zero;

  assign a_mantissa = a_subnormal ? {2'b00, 1'b0, a_operand[22:0]} : {2'b00, ~a_zero, a_operand[22:0]};
  assign a_exp      = a_subnormal ? 8'h01 : a_operand[30:23];
  assign a_sign     = a_operand[31];
  assign b_mantissa = b_subnormal ? {2'b00, 1'b0, b_operand[22:0]} : {2'b00, ~b_zero, b_operand[22:0]};
  assign b_exp      = b_subnormal ? 8'h01 : b_operand[30:23];
  assign b_sign     = b_operand[31];

  assign ieee_packet_out = operation == pa_fpu::op_add          ? {result_s_addsub, result_e_addsub, result_m_addsub[22:0]} :
                           operation == pa_fpu::op_sub          ? {result_s_addsub, result_e_addsub, result_m_addsub[22:0]} :
                           operation == pa_fpu::op_mul          ? {result_sign_mul, result_exp_mul,  result_mantissa_mul[22:0]} :
                           operation == pa_fpu::op_square       ? {result_sign_mul, result_exp_mul,  result_mantissa_mul[22:0]} :
                           operation == pa_fpu::op_div          ? {result_sign_div, result_exp_div,  result_mantissa_div[22:0]} :
                           operation == pa_fpu::op_log2         ? {log2_sign,       log2_exp_norm,   log2_norm[29:7]} :
                           operation == pa_fpu::op_float_to_int ? result_float2int : 
                                                                  32'h00000000;

  // ---------------------------------------------------------------------------------------------------------------------------------------------------

  // ADDITION & SUBTRACTION COMBINATIONAL DATAPATH
  assign ab_exp_diff = abs($signed(9'(a_exp)) - $signed(9'(b_exp))); // (a|b)_exp is 8bit, ab_exp_diff is 9bit. thus (a|b)_exp are zero-extended to 9bit first and then subtraction is performed
  // sticky bit (guard -3) = OR of all bits from index (s-3) down to 0
  assign sticky_bit = ab_exp_diff <=  2 ? 1'b0                                                    :
                      ab_exp_diff ==  3 ? (a_exp < b_exp ?  a_mantissa[0]    :  b_mantissa[0]   ) :
                      ab_exp_diff ==  4 ? (a_exp < b_exp ? |a_mantissa[1:0]  : |b_mantissa[1:0] ) :
                      ab_exp_diff ==  5 ? (a_exp < b_exp ? |a_mantissa[2:0]  : |b_mantissa[2:0] ) :
                      ab_exp_diff ==  6 ? (a_exp < b_exp ? |a_mantissa[3:0]  : |b_mantissa[3:0] ) :
                      ab_exp_diff ==  7 ? (a_exp < b_exp ? |a_mantissa[4:0]  : |b_mantissa[4:0] ) :
                      ab_exp_diff ==  8 ? (a_exp < b_exp ? |a_mantissa[5:0]  : |b_mantissa[5:0] ) :
                      ab_exp_diff ==  9 ? (a_exp < b_exp ? |a_mantissa[6:0]  : |b_mantissa[6:0] ) :
                      ab_exp_diff == 10 ? (a_exp < b_exp ? |a_mantissa[7:0]  : |b_mantissa[7:0] ) :
                      ab_exp_diff == 11 ? (a_exp < b_exp ? |a_mantissa[8:0]  : |b_mantissa[8:0] ) :
                      ab_exp_diff == 12 ? (a_exp < b_exp ? |a_mantissa[9:0]  : |b_mantissa[9:0] ) :
                      ab_exp_diff == 13 ? (a_exp < b_exp ? |a_mantissa[10:0] : |b_mantissa[10:0]) :
                      ab_exp_diff == 14 ? (a_exp < b_exp ? |a_mantissa[11:0] : |b_mantissa[11:0]) :
                      ab_exp_diff == 15 ? (a_exp < b_exp ? |a_mantissa[12:0] : |b_mantissa[12:0]) :
                      ab_exp_diff == 16 ? (a_exp < b_exp ? |a_mantissa[13:0] : |b_mantissa[13:0]) :
                      ab_exp_diff == 17 ? (a_exp < b_exp ? |a_mantissa[14:0] : |b_mantissa[14:0]) :
                      ab_exp_diff == 18 ? (a_exp < b_exp ? |a_mantissa[15:0] : |b_mantissa[15:0]) :
                      ab_exp_diff == 19 ? (a_exp < b_exp ? |a_mantissa[16:0] : |b_mantissa[16:0]) :
                      ab_exp_diff == 20 ? (a_exp < b_exp ? |a_mantissa[17:0] : |b_mantissa[17:0]) :
                      ab_exp_diff == 21 ? (a_exp < b_exp ? |a_mantissa[18:0] : |b_mantissa[18:0]) :
                      ab_exp_diff == 22 ? (a_exp < b_exp ? |a_mantissa[19:0] : |b_mantissa[19:0]) :
                      ab_exp_diff == 23 ? (a_exp < b_exp ? |a_mantissa[20:0] : |b_mantissa[20:0]) :
                      ab_exp_diff == 24 ? (a_exp < b_exp ? |a_mantissa[21:0] : |b_mantissa[21:0]) :
                      ab_exp_diff == 25 ? (a_exp < b_exp ? |a_mantissa[22:0] : |b_mantissa[22:0]) :
                      ab_exp_diff == 26 ? (a_exp < b_exp ? |a_mantissa[23:0] : |b_mantissa[23:0]) :
                      ab_exp_diff == 27 ? (a_exp < b_exp ? |a_mantissa[24:0] : |b_mantissa[24:0]) :
                      ab_exp_diff >= 28 ? (a_exp < b_exp ? |a_mantissa[25:0] : |b_mantissa[25:0]) : 1'b0;
  // if aexp < bexp, then increase aexp and right-shift a_mantissa by same number
  // else if aexp > bexp, then increase bexp and right-shift b_mantissa by same number
  // else, exponents are the same
  assign a_mantissa_adjusted[25:-3] = a_exp < b_exp ? {{a_mantissa, 2'b00} >> ab_exp_diff, sticky_bit} : {a_mantissa, 3'b000};
  assign b_mantissa_adjusted[25:-3] = b_exp < a_exp ? {{b_mantissa, 2'b00} >> ab_exp_diff, sticky_bit} : {b_mantissa, 3'b000};
  assign a_exp_adjusted = a_exp < b_exp ? b_exp : a_exp;
  assign b_exp_adjusted = a_exp;
  assign a_mantissa_signed = a_sign ? ~a_mantissa_adjusted + 1'b1 : a_mantissa_adjusted;
  assign b_mantissa_signed = b_sign ? ~b_mantissa_adjusted + 1'b1 : b_mantissa_adjusted;
  // sign bit for result_m_addsub is at bit 25, so that we have an extra bit position at bit 24 which is the carry bit from bit 23 
  // so the idea is that we don't simply extend a mantissa value by one bit, we extend it by 2 bits so we always have one bit of space for the carry
  // that can come out of bit 23
  // here we need to be careful, because some other operations make use of the internal add/sub circuit, for example op_sqrt makes use
  // of the addition operation. so here we make it such that if the current operation is sqrt, then we select addition instead of
  // subtraction. 
  assign result_m_addsub_prenorm = operation == pa_fpu::op_add ? (a_mantissa_signed + b_mantissa_signed) : (a_mantissa_signed - b_mantissa_signed);
  assign result_m_addsub_prenorm_abs = result_m_addsub_prenorm[25] ? -result_m_addsub_prenorm : result_m_addsub_prenorm;
  // NORMALIZE THE RESULT
  assign result_e_addsub_prenorm_24 = a_exp_adjusted + (result_m_addsub_prenorm_abs[24] ? 1'b1 : 1'b0);
  assign result_m_addsub_prenorm_24 = result_m_addsub_prenorm_abs[24] ? (result_m_addsub_prenorm_abs >> 1) : result_m_addsub_prenorm_abs; // if there was a carry bit after the addition then shift right

  // lzc32 function is 32bit and result_m_addsub_prenorm_abs is 29 wide, hence need to add extra 3bits to left of the argument. 
  // also, the variable result_m_addsub_prenorm_24 itself has the extra sign bit and the possible carry bit which after the shift will be zero
  // so for counting leading zeroes we need to subtract the extra count of 2. hence we subtract a total of 5 from the result.
  assign zcount_addsub = lzc32({3'b000, result_m_addsub_prenorm_24}) - 6'd5;
  // CHECK FOR SUBNORMALS
  // if decreasing the exponent by zcount makes it <= -127(or 0 when biased), this means it would create a subnormal
  // hence we only shift up to the point where it makes it -126(1 biased). this gives a subnormal default exponent
  // and also keeps the mantissa in the form 0.xxx...
  assign addsub_effective_normalization_shift = min(9'(result_e_addsub_prenorm_24), 9'(zcount_addsub)); // check whats smallest, the number of shifts from current exp till -126(01 biased), or leading zero count.
                                                                                             // the current exponent indicates how many shifts we can perform before the exponent becomes 0 (which would make it subnormal)
                                                                                             // hence if zcount > current exponent, this means we would need to shift the number (and correspondingly subtract from exponent)
                                                                                             // more times than the exponent can be decreased before becoming 0.
                                                                                             // thus we can only shift as many times as the minimum of the exponent value, and the number of leading zeroes, in order
                                                                                             // to avoid the exponent becoming -127 (00 biased)
  assign result_e_addsub_norm = result_e_addsub_prenorm_24 - addsub_effective_normalization_shift;
  assign result_m_addsub_norm = result_m_addsub_prenorm_24 << addsub_effective_normalization_shift;
  // if the exponent became -127(00) after the shifting, this number is subnormal, hence we need to shift the mantissa right once
  // to set the correct subnormal value of 0.xxx E-126
  assign result_m_addsub_subnorm_check = result_e_addsub_norm == 8'h00 ? (result_m_addsub_norm >> 1) : result_m_addsub_norm;
  // ROUND TO NEAREST TIE TO EVEN
  // set the guard bits
  assign {addsub_guard, addsub_round, addsub_sticky} = result_m_addsub_subnorm_check[-1:-3];
  // if G is 0, round down
  // else if G is 1 and at least one bit after G is 1 then round up
  // else if G is 1 and all bits after that are 0 then there's a tie: if L = 0 round down else if L = 1 round up
  assign result_m_addsub_rounded = (addsub_guard && (addsub_round || addsub_sticky)) || 
                                   (addsub_guard && ~addsub_round && ~addsub_sticky && result_m_addsub_subnorm_check[0]) ? result_m_addsub_subnorm_check[25:0] + 1'b1 : result_m_addsub_subnorm_check[25:0];
  // RENORMALIZE IF ROUNDING CAUSED A CARRY
  assign result_m_addsub_renorm = result_m_addsub_rounded[24] ? (result_m_addsub_rounded >> 1) : result_m_addsub_rounded;
  assign result_e_addsub_renorm = result_m_addsub_rounded[24] ? (result_e_addsub_norm + 1'b1)  : result_e_addsub_norm;
  // FINAL RESULT AND CHECK FOR SPECIAL CASES
  assign {result_s_addsub, 
          result_e_addsub, 
          result_m_addsub[22:0]} = a_nan                                                   ? {a_sign, a_exp, a_mantissa[22:0]} : // 'a' as NAN
                                   b_nan                                                   ? {b_sign, b_exp, b_mantissa[22:0]} : // 'b' as NAN
                                   operation == pa_fpu::op_add && a_pos_inf && b_neg_inf   ? {1'b0, 8'hFF, 23'h400000} : // NAN
                                   operation == pa_fpu::op_add && a_neg_inf && b_pos_inf   ? {1'b0, 8'hFF, 23'h400000} : // NAN
                                   operation == pa_fpu::op_add && a_pos_inf && b_pos_inf   ? {1'b0, 8'hFF, 23'h000000} : // inf
                                   operation == pa_fpu::op_add && a_neg_inf && b_neg_inf   ? {1'b1, 8'hFF, 23'h000000} : // -inf
                                   operation == pa_fpu::op_sub && a_pos_inf && b_neg_inf   ? {1'b0, 8'hFF, 23'h000000} : // inf
                                   operation == pa_fpu::op_sub && a_neg_inf && b_pos_inf   ? {1'b1, 8'hFF, 23'h000000} : // -inf
                                   operation == pa_fpu::op_sub && a_pos_inf && b_pos_inf   ? {1'b0, 8'hFF, 23'h400000} : // NAN
                                   operation == pa_fpu::op_sub && a_neg_inf && b_neg_inf   ? {1'b0, 8'hFF, 23'h400000} : // NAN
                                   a_inf                                                   ? {a_sign, 8'hFF, 23'h000000} : // inf with same sign as a
                                   operation == pa_fpu::op_add && b_inf                    ? {b_sign, 8'hFF, 23'h000000} : // inf with same sign as b
                                   operation == pa_fpu::op_sub && b_inf                    ? {~b_sign, 8'hFF, 23'h000000} : // inf with inverted b sign
                                   result_m_addsub_renorm == '0                            ? {1'b0, 8'h00, 23'h0}        : // if mantissa result is '0, then set entire result to zero including exponents
                                                                                             {result_m_addsub_prenorm[25], result_e_addsub_renorm, result_m_addsub_renorm[22:0]};

  // MULTIPLICATION DATAPATH
  // for multiplication an example follows:
  //     1.00   minimum possible multiplication
  //     1.00
  //  01.0000   
  //   1.00     normalized and truncated

  //     1.11   maximum possible multiplication
  //     1.11
  //  11.0001
  //   1.10     normalized and truncated

  // rounding example with carry after rounding is performed: 
  //  1.11101
  //  1.11|101  bit after machine epsilon is 1, hence round up
  // 10.00      rounding up causes a carry, hence it needs another normalization
  //  1.00 * 2  hence exponent increases by 1

  // rounding example:
  //      1.111
  //      1.000
  //   01111000 multiplication result
  //   11110000 msb is 0 hence shift left
  //  100000000 rounding: bits after epsilon are all zero and adding epsilon to lsb results in even lsb, hence add epsilon, which creates a carry out
  //   10000000 finally, shift right to renormalize
  comb_mul mantissa_mul(
    .a(a_mantissa[23:0]),
    .b(b_mantissa[23:0]),
    ._signed(1'b0),
    .result(product_pre_norm[47:0])
  );
  logic [5:0] mul_zcount;
  logic [47:0] mul_m_shift_left;
  logic [9:0] mul_e_shift_left;
  logic [9:0] mul_e_norm;
  logic [47:0] mul_m_norm;
  // NORMALIZE FLOATING POINT RESULT
  assign mul_exp_sum = ($signed(9'(a_exp)) - 9'sd127) + ($signed(9'(b_exp)) - 9'sd127); // calculate result's exponent, which could be <= -127
  // for multiplication, MSB of result is actually the 2^1 position, bit MSB-1 is 2^0, and so on. so we need to do a first stage of normalization before doing the rest
  assign mul_exp_shift1 =  product_pre_norm[47] ? mul_exp_sum + 1'b1 : mul_exp_sum; // if MSB is 1, then increment exp by one to normalize because in this case, we have two digits before the decimal point, 
                                                                                    // and so really the result we had was 10.xxx or 11.xxx for example, and so the final exponent needs to be incremented
  assign product_norm   = ~product_pre_norm[47] ? product_pre_norm << 1 : product_pre_norm;  // else if MSB==0, then shift left once to keep 2^0 position as the MSB bit
  // CHECK FOR SUBNORMAL NUMBERS
  // 1. if exp <= -127, then shift mant right by exp - -127. it doesnt matter whether msb==1 or not
  // 2. if exp >  -127, then if there are any leading zeroes, shift left by min(leading zeroes, exo - -127)
  // finally if the number is subnormal(exp == 0) then shift right once (because subnormals are interpreted as 0.xxx e-126(E 01), so we need to divide the man by 2 since the interpreted exp is larger than -127 by 1)
  // 2ND APPROACH:
  // check number of leading zeroes. shift mant left by nbr leading zeroes(which will make msb of mant ==1),and subtract from exp at same time.
  // then: if new exp <= -127, then shift mant right by -127 - exp. 
  // finally if the number is subnormal(exp == 0) then shift right once (because subnormals are interpreted as 0.xxx e-126(E 01), so we need to divide the man by 2 since the interpreted exp is larger than -127 by 1)
  // this approach is the same as above but in opposite order
  assign mul_zcount       = lzc48(product_norm);
  assign mul_e_shift_left = 10'($signed(mul_exp_shift1)) - $signed(10'(mul_zcount));
  assign mul_m_shift_left = product_norm << mul_zcount;
  assign mul_e_norm       = $signed(mul_e_shift_left) < -10'sd126 ? -10'sd127 : mul_e_shift_left;
  assign mul_m_norm       = $signed(mul_e_shift_left) < -10'sd126 ? mul_m_shift_left >> (-10'sd126 - $signed(mul_e_shift_left)) : mul_m_shift_left;

  // rounding: round to nearest ties to even
  // if first bit after epsilon is 1, then round up (and account for possible carry out)
  // if all bits after epsilon are 0, we have a tie
  // if rounding up produces an even result, then round up (and account for possible carry out)
  // else if first bit after epsilon is 0, and at least one bit after that is a 1, then round up (and account for possible carry out)
  assign product_rounded[24:0] = mul_m_norm[23] || (mul_m_norm[23:0] == '0 && ~{mul_m_norm[47:24] + 1'b1}[0]) || 
                                (~mul_m_norm[23] && |mul_m_norm[22:0]) ? mul_m_norm[47:24] + 1'b1 : mul_m_norm[47:24];
  // now check whether there was a carry out after rounding up
  // if there was a carry, then re-normalize
  assign product_renorm = product_rounded[24] ? product_rounded >> 1 : product_rounded; // if there was a carry, then shift right (divided by 2)
  assign mul_exp_renorm = product_rounded[24] ? mul_e_norm + 1'b1  : mul_e_norm;    // and increase exponent

  // output result to final variables. but before that, test for special cases.
  assign {result_sign_mul, 
          result_exp_mul, 
          result_mantissa_mul} = a_nan                          ? {32'h7fc00000}    : // QNaN
                                 b_nan                          ? {32'h7fc00000}    : // QNaN
                                 zero_inf_or_inf_zero           ? {1'b0, 8'hFF, 23'h400000}            : // NAN
                                 inf_or_inf                     ? {a_sign ^ b_sign, 8'hFF, 23'h000000} : // inf
                                 zero_or_zero                   ? {a_sign ^ b_sign, 8'h00, 23'h000000} : // zero
                                 a_one                          ? {a_sign ^ b_sign, b_operand[30:23], b_mantissa[22:0]} : // if either operand is 1.0, set result to other operand as a special case
                                 b_one                          ? {a_sign ^ b_sign, a_operand[30:23], a_mantissa[22:0]} : // "
                                 $signed(mul_exp_sum) > 9'sd127 ? {a_sign ^ b_sign, 8'hFF, 23'h000000} : // if the result's exponent is larger than the maximum of 127, set result to +-infinity
                                                                  {a_sign ^ b_sign, mul_exp_renorm[7:0] + 8'd127, product_renorm[22:0]};           

  // ---------------------------------------------------------------------------------------------------------------------------------------------------

  // DIVISION DATAPATH
  comb_div24_frac div24_frac(
    .a(a_mantissa[23:0]),
    .b(b_mantissa[23:0]),
    .quotient(div_quotient_prenorm_out[23:0])
  );
  assign exp_div_prenorm            = (a_exp - b_exp) + 8'd127;
  assign zcount_div                 = lzc32({8'b00000000, div_quotient_prenorm_out[23:0]}) - 4'd8;
  assign quotient_mantissa_div_norm = div_quotient_prenorm_out << zcount_div;
  assign exp_div_norm               = exp_div_prenorm - zcount_div;
  assign {result_sign_div, 
          result_exp_div, 
          result_mantissa_div[22:0]} = a_nan         ?  {a_sign, a_exp, a_mantissa[22:0]}    : // a
                                       b_nan         ?  {b_sign, b_exp, b_mantissa[22:0]}    : // b
                                       zero_inf      ?  {a_sign ^ b_sign, 8'h00, 23'h000000} : // zero
                                       inf_zero      ?  {a_sign ^ b_sign, 8'hFF, 23'h000000} : // inf
                                       a_inf         ?  {a_sign ^ b_sign, 8'hFF, 23'h000000} : // inf
                                       b_inf         ?  {a_sign ^ b_sign, 8'h00, 23'h000000} : // zero
                                       zero_and_zero ?  {1'b0, 8'hFF, 23'h400000}            : // NAN
                                       a_zero        ?  {a_sign ^ b_sign, 8'h00, 23'h000000} : // zero
                                       b_zero        ?  {1'b0, 8'hFF, 23'h000000}            : // inf
                                                        {a_sign ^ b_sign, exp_div_norm, quotient_mantissa_div_norm[22:0]};           

  // ---------------------------------------------------------------------------------------------------------------------------------------------------

  // LOGARITHM TO BASE 2
  // aliasing the floating point number as a new number such that (exponent-127) is the integral part, and mantissa is the fractional part
  // then adding a fractional error term gives the approximate log2 of the floating point.
  assign log2_prenorm = {a_operand[30:23] - 8'd127, a_operand[22:0]} + {8'b0, 23'b00001011000001000110011};
  assign log2_exp_prenorm = 8'd7;
  assign log2_abs = log2_prenorm[30] ? -log2_prenorm : log2_prenorm;
  assign log2_sign = log2_prenorm[30];
  assign log2_zcount = lzc32({1'b0, log2_abs}) - 1;
  assign log2_norm = log2_abs << log2_zcount;
  assign log2_exp_norm = 8'(9'(log2_exp_prenorm) - 9'(log2_zcount)) + 8'd127;

  // ---------------------------------------------------------------------------------------------------------------------------------------------------

  // TODO: fix
  // FLOAT2INT
  // if exponent < 0, return 0
  // else truncate the number 1.mantissa after #exponent places and that is the integer
  // example: 1.1101010 * 2^3 = 1110. 
  always_comb begin
    logic [8:0] shift;
    logic [31:0] intval;
    intval = '0;
    if(9'(a_exp) - 9'd127 < 0) result_float2int = 32'b0;
    else begin
      shift = 9'(a_exp) - 9'd127;
      for(int i = 0; i <= shift; i++) begin
        if(i > 23)
          intval[shift - i] = 1'b0; // if exponent larger than 23, then the 2^shift factor moves the decimal point beyond bit 0 of mantissa, hence fill with 0's
        else
          intval[shift - i] = a_mantissa[23 - i];
      end
      result_float2int = intval;
    end
  end

  // sin x
  // x - x^3/6 + x^5/120 - x^7/5040
  // 
  // 

endmodule