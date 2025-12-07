  // fsm control
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

  // sqrt datapath
  logic [23:0] sqrt_xn_mantissa;
  logic  [7:0] sqrt_xn_exp;
  logic        sqrt_xn_sign;
  logic [23:0] sqrt_A_mantissa;
  logic  [7:0] sqrt_A_exp;
  logic        sqrt_A_sign;
  logic  [3:0] sqrt_counter;

  pa_fpu::e_sqrt_st  curr_state_sqrt_fsm;
  pa_fpu::e_sqrt_st  next_state_sqrt_fsm;

  // REGISTER LOADING
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
        // subnormal detection
        if(a_subnormal) begin // subnormal
          a_mantissa <= {2'b00, 1'b0, a_operand[22:0]};
          a_exp      <= 8'h01; // set exponent to -126 (1 - 127)
          a_sign     <= a_operand[31];
        end
        else begin // normal/zero
          a_mantissa <= {2'b00, ~a_zero, a_operand[22:0]};
          a_exp      <= a_operand[30:23];
          a_sign     <= a_operand[31];
        end
        // subnormal detection
        if(b_subnormal) begin // subnormal
          b_mantissa <= {2'b00, 1'b0, b_operand[22:0]};
          b_exp      <= 8'h01; // set exponent to -126 (1 - 127)
          b_sign     <= b_operand[31];
        end
        else begin // normal/zero
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



  // ---------------------------------------------------------------------------------------------------------------------------------------------------

  // SQRT DATAPATH
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
      // in exceptional_st, next state is sqrt_result_valid_st
      if(curr_state_sqrt_fsm == pa_fpu::sqrt_exceptional_st) begin
        if(a_nan || a_pos_inf || a_zero) 
          {sqrt_xn_sign, sqrt_xn_exp, sqrt_xn_mantissa[22:0]} = {a_sign, a_exp, a_mantissa[22:0]}; // a
        else if(a_sign) 
          {sqrt_xn_sign, sqrt_xn_exp, sqrt_xn_mantissa[22:0]} = {1'b0, 8'hFF, 23'h400000}; // NAN
      end
      if(sqrt_mov_xn_A) begin
        sqrt_xn_mantissa <= sqrt_A_mantissa;
        sqrt_xn_exp      <= sqrt_A_exp;
        sqrt_xn_sign     <= 1'b0;
      end
      else if(sqrt_mov_xn_a_approx) begin
        sqrt_xn_mantissa <= a_mantissa; 
        //sqrt_xn_exp      <= a_exp - 8'd1;
        // 9'b110000001 = -127 with 1 bit extended for signed arithmetic
        //sqrt_xn_exp      <= (({1'b0, a_exp} + 9'b110000001) >> 1) + 9'd127 ; // divide a_exp by 2. hence initial approx to A = m*2^E  is  m*e^(E/2) which is very close to its square root.
        // a_exp is biased. shifting it by 1 divides the bias 127 by 2 as well, hence add back 127/2 = 63
        sqrt_xn_exp      <= (a_exp >> 1) + 9'd63 ; // divide a_exp by 2. hence initial approx to A = m*2^E  is  m*e^(E/2) which is very close to its square root.
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

  // ---------------------------------------------------------------------------------------------------------------------------------------------------

  // SQRT FSM
  // next state assignments
  // xn = 0.5(xn + A/xn)
  always_comb begin
    next_state_sqrt_fsm = curr_state_sqrt_fsm;

    case(curr_state_sqrt_fsm)
      pa_fpu::sqrt_idle_st: 
        // NOTE: exceptional states added because then the sqrt FSM will jump any computation states that make changes to a_sign/a_exp/a_mantissa, 
        // as making changes to those when we are trying to check for nan/inf etc will change the final result assigned to the result regiters.
        if(start_operation_sqrt_fsm) next_state_sqrt_fsm = pa_fpu::sqrt_check_exceptional_st; 
      // check if 'a' is a special value
      pa_fpu::sqrt_check_exceptional_st:
        if(a_nan || a_inf || a_zero) next_state_sqrt_fsm = pa_fpu::sqrt_exceptional_st;
        else next_state_sqrt_fsm = pa_fpu::sqrt_start_st;
      // set A = a_mantissa (A = number whose sqrt is requested)
      // set xn to initial guess 
      // set counter for number of steps
      pa_fpu::sqrt_start_st: 
        next_state_sqrt_fsm = pa_fpu::sqrt_div_st;
      // set a_mantissa = A, a_exp = A_exp
      // set b_mantissa = xn, b_exp = xn_exp
      pa_fpu::sqrt_div_st: begin
        next_state_sqrt_fsm = pa_fpu::sqrt_add_st;
      end
      // set a_mantissa <= xn, a_exp = xn_exp
      // set b_mantissa <= result_mantissa_div, b_exp = result_exp_div
      pa_fpu::sqrt_add_st: begin
        next_state_sqrt_fsm = pa_fpu::sqrt_mov_xn_a_dec_exp_dec_ctr_st;
      end
      // perform addition during this clock cycle
      // set xn = result_m_addsub, while decreasing xn_exp by 1
      // dec sqrt_counter when entering this state
      // check sqrt_counter == 4
      pa_fpu::sqrt_mov_xn_a_dec_exp_dec_ctr_st: begin
        if(sqrt_counter == 4'd4) next_state_sqrt_fsm = pa_fpu::sqrt_result_valid_st;
        else next_state_sqrt_fsm = pa_fpu::sqrt_div_st;
      end
      // if 'a' was a exceptional value then set final result to exceptionl value
      pa_fpu::sqrt_exceptional_st:
        next_state_sqrt_fsm = pa_fpu::sqrt_result_valid_st;
      pa_fpu::sqrt_result_valid_st:
        if(start_operation_sqrt_fsm == 1'b0) next_state_sqrt_fsm = pa_fpu::sqrt_idle_st;
      default:
        next_state_sqrt_fsm = pa_fpu::sqrt_idle_st;
    endcase
  end

  // SQRT FSM
  // output assignments
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
        // set A = a_mantissa (A = number whose sqrt is requested)
        // set xn to initial guess
        // set counter for number of steps
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
        // set a_mantissa = A, a_exp = A_exp
        // set b_mantissa = xn, b_exp = xn_exp
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
        // set a_mantissa <= xn, a_exp = xn_exp
        // set b_mantissa <= result_mantissa_div, b_exp = result_exp_div
        // perform addition during this clock cycle
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
        // transfer addition result to xn, while decreasing xn_exp by 1
        // inc sqrt_counter
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

  // next state clocking
  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      curr_state_sqrt_fsm  <= pa_fpu::sqrt_idle_st;
    end
    else begin
      curr_state_sqrt_fsm  <= next_state_sqrt_fsm;
    end
  end