module fpu(
  input  logic           arst,
  input  logic           clk,
  input  logic    [31:0] a_operand,
  input  logic    [31:0] b_operand,
  input pa_fpu::e_fpu_op operation, 
  input  logic           start,
  output logic    [31:0] ieee_packet_out,
  output logic           cmd_end, 
  output logic           busy     
);

  logic  [25:0] a_mantissa; 
  logic [25:-3] a_mantissa_shifted;
  logic [25:-3] a_mantissa_adjusted;
  logic   [7:0] a_exp;
  logic   [7:0] a_exp_adjusted;
  logic         a_sign;

  logic  [25:0] b_mantissa;  
  logic [25:-3] b_mantissa_shifted;  
  logic [25:-3] b_mantissa_adjusted; 
  logic   [7:0] b_exp;
  logic   [7:0] b_exp_adjusted;
  logic         b_sign;

  logic              sticky_bit; 
  logic signed [8:0] ab_exp_diff;
  logic        [8:0] ab_shift_amount;

  
  
  
  
  logic [25:-3] result_m_addsub_prenorm;  
  logic [25:-3] result_m_addsub_prenorm_abs;      
  logic [25:-3] result_m_addsub_prenorm_abs_24;   
  logic [25:-3] result_m_addsub_norm;     
  logic [25:-3] result_m_addsub_subnorm_check;
  logic  [25:0] result_m_addsub_rounded;  
  logic  [25:0] result_m_addsub_renorm;   
  logic  [22:0] result_m_addsub;          
  logic   [7:0] result_e_addsub_prenorm_abs_24;
  logic   [7:0] result_e_addsub_norm;  
  logic   [7:0] result_e_addsub_renorm;   
  logic   [7:0] result_e_addsub;
  logic         result_s_addsub;
  logic         result_addsub_is_subnormal;    
  logic   [5:0] zcount_addsub;
  logic   [4:0] addsub_effective_normalization_shift;

  logic         addsub_guard; 
  logic         addsub_round; 
  logic         addsub_sticky;

  
  logic [47:0] product_pre_norm;     
  logic [48:0] product_norm;         
  logic [48:0] product_renorm;       
  logic [48:0] product_rounded;      
  logic [22:0] result_mantissa_mul;  
  logic [ 7:0] result_exp_mul;       
  logic        result_sign_mul;      
  logic [ 7:0] mul_exp;              
  logic [ 7:0] mul_exp_norm;         
  logic [ 7:0] mul_exp_renorm;       

  
  logic [7:0]  exp_div_prenorm;
  logic [7:0]  exp_div_norm;
  logic [23:0] div_quotient_prenorm_out;
  logic [23:0] quotient_mantissa_div_norm;
  logic [4:0]  zcount_div;
  logic [22:0] result_mantissa_div;
  logic [ 7:0] result_exp_div;
  logic        result_sign_div;
  
  
  logic [23:0] sqrt_xn_mantissa;
  logic  [7:0] sqrt_xn_exp;
  logic        sqrt_xn_sign;
  logic [23:0] sqrt_A_mantissa;
  logic  [7:0] sqrt_A_exp;
  logic        sqrt_A_sign;
  logic  [3:0] sqrt_counter;

  
  logic start_operation_sqrt_fsm;  
  logic operation_done_sqrt_fsm;   
  logic sqrt_mov_xn_A;
  logic sqrt_mov_xn_a_approx;
  logic sqrt_mov_xn_a;
  logic sqrt_mov_xn_add;
  logic sqrt_mov_A_a;
  logic sqrt_mov_a_xn;
  logic sqrt_mov_a_A;
  logic sqrt_mov_b_xn;
  logic sqrt_mov_b_div;

  
  logic [31:0] result_float2int;

  logic start_operation_ar_fsm;  
  logic operation_done_ar_fsm;   

  
  logic [30:0] log2_prenorm;       
  logic [30:0] log2_norm;       
  logic [30:0] log2_abs;       
  logic  [7:0] log2_exp_prenorm;       
  logic  [7:0] log2_exp_norm;       
  logic  [5:0] log2_zcount;
  logic        log2_sign;

  
  logic a_neg;
  logic a_overflow, a_underflow;
  logic a_nan, a_inf, a_pos_inf, a_neg_inf, a_zero;
  logic a_subnormal;
  logic b_overflow, b_underflow;
  logic b_nan, b_inf, b_pos_inf, b_neg_inf, b_zero;
  logic b_subnormal;
  
  logic zero_inf_or_inf_zero;
  logic inf_or_inf;
  logic zero_or_zero;
  
  logic zero_and_zero;
  logic zero_inf;
  logic inf_zero;
  
  logic nan_or_nan;
  logic nan_inf_or_inf_nan;
  logic zero_nan_or_nan_zero;

  
  pa_fpu::e_main_st  curr_state_main_fsm;
  pa_fpu::e_main_st  next_state_main_fsm;
  pa_fpu::e_arith_st curr_state_arith_fsm;
  pa_fpu::e_arith_st next_state_arith_fsm;
  pa_fpu::e_sqrt_st  curr_state_sqrt_fsm;
  pa_fpu::e_sqrt_st  next_state_sqrt_fsm;

  

  function integer min(integer a, integer b);
    return a < b ? a : b;
  endfunction

  function integer unsigned abs(integer a);
    return a < 0 ? -a : a;
  endfunction

  
  function logic [5 : 0] lzc(
    input logic [31:0] a
  );
    for(int unsigned i = 0; i < 32; i++) begin
      if(a[31 - i]) return (6)'(i);
    end

    return (6)'(32);    
  endfunction

  assign a_nan       = a_exp == 8'hff && |a_mantissa[22:0];
  assign a_zero      = a_exp == 8'h00 &&  a_mantissa[22:0] == 23'h0;
  assign a_inf       = a_exp == 8'hff &&  a_mantissa[22:0] == 23'h0;
  assign a_pos_inf   = a_sign == 1'b0 &&  a_inf;
  assign a_neg_inf   = a_sign == 1'b1 &&  a_inf;
  assign a_subnormal = a_operand[30:23] == 8'h00 && |a_operand[22:0];

  assign b_nan       = b_exp == 8'hff && |b_mantissa[22:0];
  assign b_zero      = b_exp == 8'h00 &&  b_mantissa[22:0] == 23'h0;
  assign b_inf       = b_exp == 8'hff &&  b_mantissa[22:0] == 23'h0;
  assign b_pos_inf   = b_sign == 1'b0 &&  b_inf;
  assign b_neg_inf   = b_sign == 1'b1 &&  b_inf;
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
                     
  assign ab_exp_diff = 9'(a_exp) - 9'(b_exp); 
  assign ieee_packet_out = operation == pa_fpu::op_add          ? {result_s_addsub, result_e_addsub, result_m_addsub[22:0]} :
                           operation == pa_fpu::op_sub          ? {result_s_addsub, result_e_addsub, result_m_addsub[22:0]} :
                           operation == pa_fpu::op_mul          ? {result_sign_mul, result_exp_mul,  result_mantissa_mul[22:0]} :
                           operation == pa_fpu::op_square       ? {result_sign_mul, result_exp_mul,  result_mantissa_mul[22:0]} :
                           operation == pa_fpu::op_div          ? {result_sign_div, result_exp_div,  result_mantissa_div[22:0]} :
                           operation == pa_fpu::op_sqrt         ? {sqrt_xn_sign,    sqrt_xn_exp,     sqrt_xn_mantissa[22:0]} :
                           operation == pa_fpu::op_log2         ? {log2_sign,       log2_exp_norm,   log2_norm[29:7]} :
                           operation == pa_fpu::op_float_to_int ? result_float2int : 
                                                                  32'h00000000;
  assign ab_shift_amount = 9'(abs(ab_exp_diff));
  assign sticky_bit = ab_shift_amount <   3 ? 1'b0                                                    :
                      ab_shift_amount ==  3 ? (a_exp < b_exp ?  a_mantissa[0]    :  b_mantissa[0]   ) :
                      ab_shift_amount ==  4 ? (a_exp < b_exp ? |a_mantissa[1:0]  : |b_mantissa[1:0] ) :
                      ab_shift_amount ==  5 ? (a_exp < b_exp ? |a_mantissa[2:0]  : |b_mantissa[2:0] ) :
                      ab_shift_amount ==  6 ? (a_exp < b_exp ? |a_mantissa[3:0]  : |b_mantissa[3:0] ) :
                      ab_shift_amount ==  7 ? (a_exp < b_exp ? |a_mantissa[4:0]  : |b_mantissa[4:0] ) :
                      ab_shift_amount ==  8 ? (a_exp < b_exp ? |a_mantissa[5:0]  : |b_mantissa[5:0] ) :
                      ab_shift_amount ==  9 ? (a_exp < b_exp ? |a_mantissa[6:0]  : |b_mantissa[6:0] ) :
                      ab_shift_amount == 10 ? (a_exp < b_exp ? |a_mantissa[7:0]  : |b_mantissa[7:0] ) :
                      ab_shift_amount == 11 ? (a_exp < b_exp ? |a_mantissa[8:0]  : |b_mantissa[8:0] ) :
                      ab_shift_amount == 12 ? (a_exp < b_exp ? |a_mantissa[9:0]  : |b_mantissa[9:0] ) :
                      ab_shift_amount == 13 ? (a_exp < b_exp ? |a_mantissa[10:0] : |b_mantissa[10:0]) :
                      ab_shift_amount == 14 ? (a_exp < b_exp ? |a_mantissa[11:0] : |b_mantissa[11:0]) :
                      ab_shift_amount == 15 ? (a_exp < b_exp ? |a_mantissa[12:0] : |b_mantissa[12:0]) :
                      ab_shift_amount == 16 ? (a_exp < b_exp ? |a_mantissa[13:0] : |b_mantissa[13:0]) :
                      ab_shift_amount == 17 ? (a_exp < b_exp ? |a_mantissa[14:0] : |b_mantissa[14:0]) :
                      ab_shift_amount == 18 ? (a_exp < b_exp ? |a_mantissa[15:0] : |b_mantissa[15:0]) :
                      ab_shift_amount == 19 ? (a_exp < b_exp ? |a_mantissa[16:0] : |b_mantissa[16:0]) :
                      ab_shift_amount == 20 ? (a_exp < b_exp ? |a_mantissa[17:0] : |b_mantissa[17:0]) :
                      ab_shift_amount == 21 ? (a_exp < b_exp ? |a_mantissa[18:0] : |b_mantissa[18:0]) :
                      ab_shift_amount == 22 ? (a_exp < b_exp ? |a_mantissa[19:0] : |b_mantissa[19:0]) :
                      ab_shift_amount == 23 ? (a_exp < b_exp ? |a_mantissa[20:0] : |b_mantissa[20:0]) :
                      ab_shift_amount == 24 ? (a_exp < b_exp ? |a_mantissa[21:0] : |b_mantissa[21:0]) :
                      ab_shift_amount == 25 ? (a_exp < b_exp ? |a_mantissa[22:0] : |b_mantissa[22:0]) :
                      ab_shift_amount == 26 ? (a_exp < b_exp ? |a_mantissa[23:0] : |b_mantissa[23:0]) :
                      ab_shift_amount == 27 ? (a_exp < b_exp ? |a_mantissa[24:0] : |b_mantissa[24:0]) :
                      ab_shift_amount >= 28 ? (a_exp < b_exp ? |a_mantissa[25:0] : |b_mantissa[25:0]) : 
                                              1'b0;
  assign a_mantissa_shifted[25:-3] = a_exp < b_exp ? {{a_mantissa, 2'b00} >> ab_shift_amount, sticky_bit} : {a_mantissa, 3'b000};
  assign b_mantissa_shifted[25:-3] = b_exp < a_exp ? {{b_mantissa, 2'b00} >> ab_shift_amount, sticky_bit} : {b_mantissa, 3'b000};
  assign a_exp_adjusted = a_exp < b_exp ? b_exp : a_exp;
  assign b_exp_adjusted = b_exp < a_exp ? a_exp : b_exp;
  assign a_mantissa_adjusted = a_sign ? ~a_mantissa_shifted + 1'b1 : a_mantissa_shifted;
  assign b_mantissa_adjusted = b_sign ? ~b_mantissa_shifted + 1'b1 : b_mantissa_shifted;
  assign result_m_addsub_prenorm = operation == pa_fpu::op_add || operation == pa_fpu::op_sqrt ? a_mantissa_adjusted + b_mantissa_adjusted :
  assign result_m_addsub_prenorm_abs = result_m_addsub_prenorm[25] ? -result_m_addsub_prenorm : result_m_addsub_prenorm;
  assign result_e_addsub_prenorm_abs_24 = a_exp_adjusted + (result_m_addsub_prenorm_abs[24] ? 1'b1 : 1'b0);
  assign result_m_addsub_prenorm_abs_24 = result_m_addsub_prenorm_abs[24] ? result_m_addsub_prenorm_abs >> 1 : result_m_addsub_prenorm_abs; 
  assign zcount_addsub = lzc({3'b000, result_m_addsub_prenorm_abs_24}) - 6'd5;
  assign result_addsub_is_subnormal = $signed(9'(result_e_addsub_prenorm_abs_24)) - $signed(9'(zcount_addsub)) <= 9'sd0; 
  assign addsub_effective_normalization_shift = min(9'(result_e_addsub_prenorm_abs_24), 9'(zcount_addsub)); 
  assign result_e_addsub_norm = result_e_addsub_prenorm_abs_24 - addsub_effective_normalization_shift;
  assign result_m_addsub_norm = result_m_addsub_prenorm_abs_24 << addsub_effective_normalization_shift;
  assign result_m_addsub_subnorm_check = result_m_addsub_norm >> (result_addsub_is_subnormal ? 1'b1 : 0);
  assign {addsub_guard, addsub_round, addsub_sticky} = result_m_addsub_subnorm_check[-1:-3];
  assign result_m_addsub_rounded = (addsub_guard && (addsub_round || addsub_sticky)) || 
                                   (addsub_guard && ~addsub_round && ~addsub_sticky && result_m_addsub_subnorm_check[0]) ? result_m_addsub_subnorm_check[25:0] + 1'b1 : result_m_addsub_subnorm_check[25:0];
  assign result_m_addsub_renorm = result_m_addsub_rounded[24] ? result_m_addsub_rounded >> 1 : result_m_addsub_rounded;
  assign result_e_addsub_renorm = result_m_addsub_rounded[24] ? result_e_addsub_norm + 1'b1 : result_e_addsub_norm;
  assign {result_s_addsub, 
          result_e_addsub, 
          result_m_addsub[22:0]} = a_nan                                                   ? {a_sign, a_exp, a_mantissa[22:0]} : 
                                   b_nan                                                   ? {b_sign, b_exp, b_mantissa[22:0]} : 
                                   operation == pa_fpu::op_add && a_pos_inf && b_neg_inf   ? {1'b0, 8'hFF, 23'h400000} : 
                                   operation == pa_fpu::op_add && a_neg_inf && b_pos_inf   ? {1'b0, 8'hFF, 23'h400000} : 
                                   operation == pa_fpu::op_add && a_pos_inf && b_pos_inf   ? {1'b0, 8'hFF, 23'h000000} : 
                                   operation == pa_fpu::op_add && a_neg_inf && b_neg_inf   ? {1'b1, 8'hFF, 23'h000000} : 
                                   operation == pa_fpu::op_sub && a_pos_inf && b_neg_inf   ? {1'b0, 8'hFF, 23'h000000} : 
                                   operation == pa_fpu::op_sub && a_neg_inf && b_pos_inf   ? {1'b1, 8'hFF, 23'h000000} : 
                                   operation == pa_fpu::op_sub && a_pos_inf && b_pos_inf   ? {1'b0, 8'hFF, 23'h400000} : 
                                   operation == pa_fpu::op_sub && a_neg_inf && b_neg_inf   ? {1'b0, 8'hFF, 23'h400000} : 
                                   a_inf                                                   ? {a_sign, 8'hFF, 23'h000000} : 
                                   operation == pa_fpu::op_add && b_inf                    ? {b_sign, 8'hFF, 23'h000000} : 
                                   operation == pa_fpu::op_sub && b_inf                    ? {~b_sign, 8'hFF, 23'h000000} : 
                                   result_m_addsub_renorm == '0                            ? {1'b0, 8'h00, 23'h0}        : 
                                                                                             {result_m_addsub_prenorm[25], result_e_addsub_renorm, result_m_addsub_renorm[22:0]};
  
  comb_mul mantissa_mul(
    .a(a_mantissa[23:0]),
    .b(b_mantissa[23:0]),
    ._signed(1'b0),
    .result(product_pre_norm)
  );
  assign mul_exp = (a_exp - 8'd127) + b_exp;
  
  assign mul_exp_norm =  product_pre_norm[47] ? mul_exp + 1'b1 : mul_exp;                  
  assign product_norm = ~product_pre_norm[47] ? product_pre_norm << 1 : product_pre_norm;  
  assign product_rounded[48:24] = product_norm[23] || 
                                 (product_norm[23:0] == '0 && ~{product_norm[47:24] + 1'b1}[0]) || 
                                (~product_norm[23] && |product_norm[22:0]) ? product_norm[47:24] + 1'b1 : product_norm[47:24];
  assign product_renorm = product_rounded[48] ? product_rounded >> 1 : product_rounded; 
  assign mul_exp_renorm = product_rounded[48] ? mul_exp_norm + 1'b1  : mul_exp_norm;    
  assign {result_sign_mul, 
          result_exp_mul, 
          result_mantissa_mul} = a_nan                ?  {a_sign, a_exp, a_mantissa[22:0]}    : 
                                 b_nan                ?  {b_sign, b_exp, b_mantissa[22:0]}    : 
                                 zero_inf_or_inf_zero ?  {1'b0, 8'hFF, 23'h400000}            : 
                                 inf_or_inf           ?  {a_sign ^ b_sign, 8'hFF, 23'h000000} : 
                                 zero_or_zero         ?  {a_sign ^ b_sign, 8'h00, 23'h000000} : 
                                                         {a_sign ^ b_sign, mul_exp_renorm, product_renorm[46:24]};           
  
  comb_div24_frac div24_frac(
    .a(a_mantissa[23:0]),
    .b(b_mantissa[23:0]),
    .quotient(div_quotient_prenorm_out[23:0])
  );
  assign exp_div_prenorm            = (a_exp - b_exp) + 8'd127;
  assign zcount_div                 = lzc({8'b00000000, div_quotient_prenorm_out[23:0]}) - 4'd8;
  assign quotient_mantissa_div_norm = div_quotient_prenorm_out << zcount_div;
  assign exp_div_norm               = exp_div_prenorm - zcount_div;
  assign {result_sign_div, 
          result_exp_div, 
          result_mantissa_div[22:0]} = a_nan         ?  {a_sign, a_exp, a_mantissa[22:0]}    : 
                                       b_nan         ?  {b_sign, b_exp, b_mantissa[22:0]}    : 
                                       zero_inf      ?  {a_sign ^ b_sign, 8'h00, 23'h000000} : 
                                       inf_zero      ?  {a_sign ^ b_sign, 8'hFF, 23'h000000} : 
                                       a_inf         ?  {a_sign ^ b_sign, 8'hFF, 23'h000000} : 
                                       b_inf         ?  {a_sign ^ b_sign, 8'h00, 23'h000000} : 
                                       zero_and_zero ?  {1'b0, 8'hFF, 23'h400000}            : 
                                       a_zero        ?  {a_sign ^ b_sign, 8'h00, 23'h000000} : 
                                       b_zero        ?  {1'b0, 8'hFF, 23'h000000}            : 
                                                        {a_sign ^ b_sign, exp_div_norm, quotient_mantissa_div_norm[22:0]};           
  
  assign log2_prenorm = {a_operand[30:23] - 8'd127, a_operand[22:0]} + {8'b0, 23'b00001011000001000110011};
  assign log2_exp_prenorm = 8'd7;
  assign log2_abs = log2_prenorm[30] ? -log2_prenorm : log2_prenorm;
  assign log2_sign = log2_prenorm[30];
  assign log2_zcount = lzc({1'b0, log2_abs}) - 1;
  assign log2_norm = log2_abs << log2_zcount;
  assign log2_exp_norm = 8'(9'(log2_exp_prenorm) - 9'(log2_zcount)) + 8'd127;
  
  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      a_mantissa <= '0;
      a_exp      <= '0;
      a_sign     <= '0;
      b_mantissa <= '0;
      b_exp      <= '0;
      b_sign     <= '0;
    end   
    else begin
      if(next_state_arith_fsm == pa_fpu::arith_load_operands_st) begin
        
        if(a_subnormal) begin 
          a_mantissa <= {2'b00, 1'b0, a_operand[22:0]};
          a_exp      <= 8'h01; 
          a_sign     <= a_operand[31];
        end
        else begin 
          a_mantissa <= {2'b00, ~a_zero, a_operand[22:0]};
          a_exp      <= a_operand[30:23];
          a_sign     <= a_operand[31];
        end
        
        if(b_subnormal) begin 
          b_mantissa <= {2'b00, 1'b0, b_operand[22:0]};
          b_exp      <= 8'h01; 
          b_sign     <= b_operand[31];
        end
        else begin 
          b_mantissa <= {2'b00, ~b_zero, b_operand[22:0]};
          b_exp      <= b_operand[30:23];
          b_sign     <= b_operand[31];
        end
      end
      if(sqrt_mov_a_xn) begin
        a_mantissa <= {2'b00, sqrt_xn_mantissa};
        a_exp      <= sqrt_xn_exp;
        a_sign     <= sqrt_xn_sign;
      end
      else if(sqrt_mov_a_A) begin
        a_mantissa <= {2'b00, sqrt_A_mantissa};
        a_exp      <= sqrt_A_exp;
        a_sign     <= sqrt_A_sign;
      end
      if(sqrt_mov_b_xn) begin
        b_mantissa <= {2'b00, sqrt_xn_mantissa};
        b_exp      <= sqrt_xn_exp;
        b_sign     <= sqrt_xn_sign;
      end
      else if(sqrt_mov_b_div) begin
        b_mantissa <= {2'b00, 1'b1, result_mantissa_div};
        b_exp      <= result_exp_div;
        b_sign     <= result_sign_div;
      end
    end
  end

  

  
  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      sqrt_xn_mantissa <= '0;
      sqrt_xn_exp      <= '0;
      sqrt_xn_sign     <= '0;
      sqrt_A_mantissa  <= '0;
      sqrt_A_exp       <= '0;
      sqrt_A_sign      <= '0;
      sqrt_counter     <= '0;
    end
    else begin
      if(next_state_sqrt_fsm == pa_fpu::sqrt_start_st) begin
        sqrt_counter <= 0;
      end
      else if(next_state_sqrt_fsm == pa_fpu::sqrt_mov_xn_a_dec_exp_dec_ctr_st) begin
        sqrt_counter <= sqrt_counter + 4'd1;
      end
      
      if(curr_state_sqrt_fsm == pa_fpu::sqrt_exceptional_st) begin
        if(a_nan || a_pos_inf || a_zero) 
          {sqrt_xn_sign, sqrt_xn_exp, sqrt_xn_mantissa[22:0]} = {a_sign, a_exp, a_mantissa[22:0]}; 
        else if(a_sign) 
          {sqrt_xn_sign, sqrt_xn_exp, sqrt_xn_mantissa[22:0]} = {1'b0, 8'hFF, 23'h400000}; 
      end
      if(sqrt_mov_xn_A) begin
        sqrt_xn_mantissa <= sqrt_A_mantissa;
        sqrt_xn_exp      <= sqrt_A_exp;
        sqrt_xn_sign     <= 1'b0;
      end
      else if(sqrt_mov_xn_a_approx) begin
        sqrt_xn_mantissa <= a_mantissa; 
        
        
        
        
        sqrt_xn_exp      <= (a_exp >> 1) + 9'd63 ; 
        sqrt_xn_sign     <= a_sign;
      end
      else if(sqrt_mov_xn_a) begin
        sqrt_xn_mantissa <= a_mantissa;
        sqrt_xn_exp      <= a_exp;
        sqrt_xn_sign     <= a_sign;
      end
      else if(sqrt_mov_xn_add) begin
        sqrt_xn_mantissa <= {1'b1, result_m_addsub[22:0]};
        sqrt_xn_exp      <= result_e_addsub - 8'd1;
        sqrt_xn_sign     <= result_s_addsub;
      end
      if(sqrt_mov_A_a) begin
        sqrt_A_mantissa <= a_mantissa;
        sqrt_A_exp      <= a_exp;
        sqrt_A_sign     <= a_sign;
      end
    end
  end

  

  
  
  
  
  
  always_comb begin
    logic [8:0] shift;
    logic [31:0] intval;
    intval = '0;
    if(9'(a_exp) - 9'd127 < 0) result_float2int = 32'b0;
    else begin
      shift = 9'(a_exp) - 9'd127;
      for(int i = 0; i <= shift; i++) begin
        if(i > 23)
          intval[shift - i] = 1'b0; 
        else
          intval[shift - i] = a_mantissa[23 - i];
      end
      result_float2int = intval;
    end
  end

  
  
  
  

  

  
  
  always_comb begin
    next_state_main_fsm = curr_state_main_fsm;

    case(curr_state_main_fsm)
      pa_fpu::main_idle_st: 
        if(start) next_state_main_fsm = pa_fpu::main_wait_st;
      
      pa_fpu::main_wait_st: 
        if(operation_done_ar_fsm == 1'b1) next_state_main_fsm = pa_fpu::main_finish_st;

      pa_fpu::main_finish_st:
        if(operation_done_ar_fsm == 1'b0) next_state_main_fsm = pa_fpu::main_wait_start_low_st;

      pa_fpu::main_wait_start_low_st:
        if(start == 1'b0) next_state_main_fsm = pa_fpu::main_idle_st;

      default:
        next_state_main_fsm = pa_fpu::main_idle_st;
    endcase
  end

  
  
  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      start_operation_ar_fsm <= 1'b0;
      cmd_end                <= 1'b0;             
      busy                   <= 1'b0;         
    end
    else begin
      case(next_state_main_fsm)
        pa_fpu::main_idle_st: begin
          start_operation_ar_fsm <= 1'b0;
          cmd_end                <= 1'b0;             
          busy                   <= 1'b0;         
        end
        pa_fpu::main_wait_st: begin
          start_operation_ar_fsm <= 1'b1;
          cmd_end                <= 1'b0;             
          busy                   <= 1'b1;         
        end
        pa_fpu::main_finish_st: begin
          start_operation_ar_fsm <= 1'b0;
          cmd_end                <= 1'b0;             
          busy                   <= 1'b1;         
        end
        pa_fpu::main_wait_start_low_st: begin
          start_operation_ar_fsm <= 1'b0;
          cmd_end                <= 1'b1;             
          busy                   <= 1'b1;         
        end
      endcase  
    end
  end

  

  
  
  always_comb begin
    next_state_arith_fsm = curr_state_arith_fsm;

    case(curr_state_arith_fsm)
      pa_fpu::arith_idle_st: 
        if(start_operation_ar_fsm)
          next_state_arith_fsm = pa_fpu::arith_load_operands_st;

      pa_fpu::arith_load_operands_st:
        case(operation)
          pa_fpu::op_add:
            next_state_arith_fsm = pa_fpu::arith_add_st;
          pa_fpu::op_sub:
            next_state_arith_fsm = pa_fpu::arith_sub_st;
          pa_fpu::op_mul:
            next_state_arith_fsm = pa_fpu::arith_mul_st;
          pa_fpu::op_div:
            next_state_arith_fsm = pa_fpu::arith_div_st;
          pa_fpu::op_sqrt:
            next_state_arith_fsm = pa_fpu::arith_sqrt_st;
          pa_fpu::op_log2:
            next_state_arith_fsm = pa_fpu::arith_log2_st;
          pa_fpu::op_float_to_int:
            next_state_arith_fsm = pa_fpu::arith_float2int_st;
        endcase

      pa_fpu::arith_add_st:
        next_state_arith_fsm = pa_fpu::arith_result_valid_st;

      pa_fpu::arith_sub_st:
        next_state_arith_fsm = pa_fpu::arith_result_valid_st;

      pa_fpu::arith_mul_st:
        next_state_arith_fsm = pa_fpu::arith_result_valid_st;

      pa_fpu::arith_div_st:
        next_state_arith_fsm = pa_fpu::arith_result_valid_st;

      pa_fpu::arith_sqrt_st:
        if(operation_done_sqrt_fsm == 1'b1) next_state_arith_fsm = pa_fpu::arith_sqrt_done_st;
      pa_fpu::arith_sqrt_done_st:
        if(operation_done_sqrt_fsm == 1'b0) next_state_arith_fsm = pa_fpu::arith_result_valid_st;

      pa_fpu::arith_log2_st:
        next_state_arith_fsm = pa_fpu::arith_result_valid_st;

      pa_fpu::arith_float2int_st:
        next_state_arith_fsm = pa_fpu::arith_result_valid_st;

      pa_fpu::arith_result_valid_st:
        if(start_operation_ar_fsm == 1'b0) next_state_arith_fsm = pa_fpu::arith_idle_st;

      default:
        next_state_arith_fsm = pa_fpu::arith_idle_st;
    endcase
  end

  
  
  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      operation_done_ar_fsm <= 1'b0;
      start_operation_sqrt_fsm <= 1'b0;
    end
    else begin
      case(next_state_arith_fsm)
        pa_fpu::arith_idle_st: begin
          operation_done_ar_fsm <= 1'b0;
          start_operation_sqrt_fsm <= 1'b0;
        end
        pa_fpu::arith_load_operands_st: begin
          operation_done_ar_fsm <= 1'b0;
          start_operation_sqrt_fsm <= 1'b0;
        end
        pa_fpu::arith_add_st: begin
          operation_done_ar_fsm <= 1'b0;
          start_operation_sqrt_fsm <= 1'b0;
        end
        pa_fpu::arith_sub_st: begin
          operation_done_ar_fsm <= 1'b0;
          start_operation_sqrt_fsm <= 1'b0;
        end
        pa_fpu::arith_mul_st: begin
          operation_done_ar_fsm   <= 1'b0;
          start_operation_sqrt_fsm <= 1'b0;
        end
        pa_fpu::arith_div_st: begin
          operation_done_ar_fsm <= 1'b0;
          start_operation_sqrt_fsm <= 1'b0;
        end
        pa_fpu::arith_sqrt_st: begin
          operation_done_ar_fsm <= 1'b0;
          start_operation_sqrt_fsm <= 1'b1;
        end
        pa_fpu::arith_sqrt_done_st: begin
          operation_done_ar_fsm <= 1'b0;
          start_operation_sqrt_fsm <= 1'b0;
        end
        pa_fpu::arith_log2_st: begin
          operation_done_ar_fsm <= 1'b0;
          start_operation_sqrt_fsm <= 1'b0;
        end
        pa_fpu::arith_float2int_st: begin
          operation_done_ar_fsm <= 1'b0;
          start_operation_sqrt_fsm <= 1'b0;
        end
        pa_fpu::arith_result_valid_st: begin
          operation_done_ar_fsm <= 1'b1;
          start_operation_sqrt_fsm <= 1'b0;
        end
      endcase  
    end
  end

  

  
  
  
  always_comb begin
    next_state_sqrt_fsm = curr_state_sqrt_fsm;

    case(curr_state_sqrt_fsm)
      pa_fpu::sqrt_idle_st: 
        
        
        if(start_operation_sqrt_fsm) next_state_sqrt_fsm = pa_fpu::sqrt_check_exceptional_st; 
      
      pa_fpu::sqrt_check_exceptional_st:
        if(a_nan || a_inf || a_zero) next_state_sqrt_fsm = pa_fpu::sqrt_exceptional_st;
        else next_state_sqrt_fsm = pa_fpu::sqrt_start_st;
      
      
      
      pa_fpu::sqrt_start_st: 
        next_state_sqrt_fsm = pa_fpu::sqrt_div_st;
      
      
      pa_fpu::sqrt_div_st: begin
        next_state_sqrt_fsm = pa_fpu::sqrt_add_st;
      end
      
      
      pa_fpu::sqrt_add_st: begin
        next_state_sqrt_fsm = pa_fpu::sqrt_mov_xn_a_dec_exp_dec_ctr_st;
      end
      
      
      
      
      pa_fpu::sqrt_mov_xn_a_dec_exp_dec_ctr_st: begin
        if(sqrt_counter == 4'd4) next_state_sqrt_fsm = pa_fpu::sqrt_result_valid_st;
        else next_state_sqrt_fsm = pa_fpu::sqrt_div_st;
      end
      
      pa_fpu::sqrt_exceptional_st:
        next_state_sqrt_fsm = pa_fpu::sqrt_result_valid_st;
      pa_fpu::sqrt_result_valid_st:
        if(start_operation_sqrt_fsm == 1'b0) next_state_sqrt_fsm = pa_fpu::sqrt_idle_st;
      default:
        next_state_sqrt_fsm = pa_fpu::sqrt_idle_st;
    endcase
  end

  
  
  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      operation_done_sqrt_fsm <= 1'b0;
      sqrt_mov_xn_A           <= 1'b0;
      sqrt_mov_xn_a_approx    <= 1'b0;
      sqrt_mov_xn_a           <= 1'b0;
      sqrt_mov_xn_add         <= 1'b0;
      sqrt_mov_A_a            <= 1'b0;
      sqrt_mov_a_xn           <= 1'b0;
      sqrt_mov_a_A            <= 1'b0;
      sqrt_mov_b_xn           <= 1'b0;
      sqrt_mov_b_div          <= 1'b0;
    end
    else begin
      case(next_state_sqrt_fsm)
        pa_fpu::sqrt_idle_st: begin
          operation_done_sqrt_fsm <= 1'b0;
          sqrt_mov_xn_A           <= 1'b0;
          sqrt_mov_xn_a_approx    <= 1'b0;
          sqrt_mov_xn_a           <= 1'b0;
          sqrt_mov_xn_add         <= 1'b0;
          sqrt_mov_A_a            <= 1'b0;
          sqrt_mov_a_xn           <= 1'b0;
          sqrt_mov_a_A            <= 1'b0;
          sqrt_mov_b_xn           <= 1'b0;
          sqrt_mov_b_div          <= 1'b0;
        end
        pa_fpu::sqrt_check_exceptional_st: begin
          operation_done_sqrt_fsm <= 1'b0;
          sqrt_mov_xn_A           <= 1'b0;
          sqrt_mov_xn_a           <= 1'b0;
          sqrt_mov_xn_a_approx    <= 1'b0;
          sqrt_mov_xn_add         <= 1'b0;
          sqrt_mov_A_a            <= 1'b0;
          sqrt_mov_a_xn           <= 1'b0;
          sqrt_mov_a_A            <= 1'b0;
          sqrt_mov_b_xn           <= 1'b0;
          sqrt_mov_b_div          <= 1'b0;
        end
        
        
        
        pa_fpu::sqrt_start_st: begin
          operation_done_sqrt_fsm <= 1'b0;
          sqrt_mov_xn_A           <= 1'b0;
          sqrt_mov_xn_a           <= 1'b0;
          sqrt_mov_xn_a_approx    <= 1'b1;
          sqrt_mov_xn_add         <= 1'b0;
          sqrt_mov_A_a            <= 1'b1;
          sqrt_mov_a_xn           <= 1'b0;
          sqrt_mov_a_A            <= 1'b0;
          sqrt_mov_b_xn           <= 1'b0;
          sqrt_mov_b_div          <= 1'b0;
        end
        
        
        pa_fpu::sqrt_div_st: begin
          operation_done_sqrt_fsm <= 1'b0;
          sqrt_mov_xn_A           <= 1'b0;
          sqrt_mov_xn_a           <= 1'b0;
          sqrt_mov_xn_a_approx    <= 1'b0;
          sqrt_mov_xn_add         <= 1'b0;
          sqrt_mov_A_a            <= 1'b0;
          sqrt_mov_a_xn           <= 1'b0;
          sqrt_mov_a_A            <= 1'b1;
          sqrt_mov_b_xn           <= 1'b1;
          sqrt_mov_b_div          <= 1'b0;
        end
        
        
        
        pa_fpu::sqrt_add_st: begin
          operation_done_sqrt_fsm <= 1'b0;
          sqrt_mov_xn_A           <= 1'b0;
          sqrt_mov_xn_a           <= 1'b0;
          sqrt_mov_xn_a_approx    <= 1'b0;
          sqrt_mov_xn_add         <= 1'b0;
          sqrt_mov_A_a            <= 1'b0;
          sqrt_mov_a_xn           <= 1'b1;
          sqrt_mov_a_A            <= 1'b0;
          sqrt_mov_b_xn           <= 1'b0;
          sqrt_mov_b_div          <= 1'b1;
        end
        
        
        pa_fpu::sqrt_mov_xn_a_dec_exp_dec_ctr_st: begin
          operation_done_sqrt_fsm <= 1'b0;
          sqrt_mov_xn_A           <= 1'b0;
          sqrt_mov_xn_a           <= 1'b0;
          sqrt_mov_xn_a_approx    <= 1'b0;
          sqrt_mov_xn_add         <= 1'b1;
          sqrt_mov_A_a            <= 1'b0;
          sqrt_mov_a_xn           <= 1'b0;
          sqrt_mov_a_A            <= 1'b0;
          sqrt_mov_b_xn           <= 1'b0;
          sqrt_mov_b_div          <= 1'b0;
        end
        pa_fpu::sqrt_exceptional_st: begin
          operation_done_sqrt_fsm <= 1'b0;
          sqrt_mov_xn_A           <= 1'b0;
          sqrt_mov_xn_a           <= 1'b0;
          sqrt_mov_xn_a_approx    <= 1'b0;
          sqrt_mov_xn_add         <= 1'b0;
          sqrt_mov_A_a            <= 1'b0;
          sqrt_mov_a_xn           <= 1'b0;
          sqrt_mov_a_A            <= 1'b0;
          sqrt_mov_b_xn           <= 1'b0;
          sqrt_mov_b_div          <= 1'b0;
        end
        pa_fpu::sqrt_result_valid_st: begin
          operation_done_sqrt_fsm <= 1'b1;
          sqrt_mov_xn_A           <= 1'b0;
          sqrt_mov_xn_a           <= 1'b0;
          sqrt_mov_xn_a_approx    <= 1'b0;
          sqrt_mov_xn_add         <= 1'b0;
          sqrt_mov_A_a            <= 1'b0;
          sqrt_mov_a_xn           <= 1'b0;
          sqrt_mov_a_A            <= 1'b0;
          sqrt_mov_b_xn           <= 1'b0;
          sqrt_mov_b_div          <= 1'b0;
        end
      endcase  
    end
  end

  
  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      curr_state_main_fsm  <= pa_fpu::main_idle_st;
      curr_state_arith_fsm <= pa_fpu::arith_idle_st;
      curr_state_sqrt_fsm  <= pa_fpu::sqrt_idle_st;
    end
    else begin
      curr_state_main_fsm  <= next_state_main_fsm;
      curr_state_arith_fsm <= next_state_arith_fsm;
      curr_state_sqrt_fsm  <= next_state_sqrt_fsm;
    end
  end

endmodule
