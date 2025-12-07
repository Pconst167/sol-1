package pa_fpu;

  typedef enum logic[3:0]{
    op_add = 4'h0,
    op_sub = 4'h1,
    op_mul,
    op_square,
    op_div,
    op_sqrt,
    op_log2,
    op_a_inv,
    op_sin,
    op_cos,
    op_tan,
    op_ln,
    op_exp,
    op_int_to_float,
    op_float_to_int
  } e_fpu_op;

  typedef enum logic[3:0]{
    main_idle_st,
    main_wait_st,
    main_finish_st,
    main_wait_start_low_st
  } e_main_st;

  typedef enum logic[3:0]{
    arith_idle_st,
    arith_load_operands_st,
    arith_add_st,
    arith_sub_st,
    arith_mul_st,
    arith_div_st,
    arith_sqrt_st,
    arith_sqrt_done_st,
    arith_log2_st,
    arith_float2int_st,
    arith_result_valid_st
  } e_arith_st;

  typedef enum logic [3:0]{
    sqrt_idle_st,
    sqrt_check_exceptional_st,
    sqrt_start_st,
    sqrt_div_st,
    sqrt_wait_div_done_st,
    sqrt_add_st,
    sqrt_mov_xn_a_dec_exp_dec_ctr_st,
    sqrt_exceptional_st,
    sqrt_result_valid_st
  } e_sqrt_st;

endpackage