import pa_fpu::*;

module fpu(
  input  logic arst,
  input  logic clk,
  input  logic [7:0] databus_in,
  output logic [7:0] databus_out,
  input  logic [5:0] addr, 
  input  logic cs,
  input  logic rd,
  input  logic wr,
  input  logic end_ack,      // acknowledge end
  output logic cmd_end,      // end of command / irq
  output logic busy   // active high when an operation is in progress
);

  logic agtb;
  logic bgta;

  logic [31:0] operand_a;
  logic unsigned [24:0] a_mantissa;
  logic [ 7:0] a_exp;
  logic        a_sign;
  logic [31:0] operand_b;
  logic unsigned [24:0] b_mantissa;
  logic [ 7:0] b_exp;
  logic        b_sign;
  logic [31:0] result;
  logic unsigned [47:0] result_mantissa;
  logic unsigned [47:0] result_mantissa_before_shift;
  logic unsigned [47:0] result_mantissa_before_inv;
  logic [ 7:0] result_exp;
  logic        result_sign;
  logic [ 7:0] aexp_no_bias;
  logic [ 7:0] bexp_no_bias;

  logic [ 7:0] ab_exp_diff;
  logic [ 7:0] ba_exp_diff;

  logic [ 7:0] status;
  e_fpu_operation operation; // arithmetic operation to be performed

  logic op_written;

  logic [7:0] aexp_after_adjust;
  logic [7:0] bexp_after_adjust;
  logic [24:0] a_mantissa_after_adjust;
  logic [24:0] b_mantissa_after_adjust;
  logic [24:0] a_mantissa_after_adjust_abs;
  logic [24:0] b_mantissa_after_adjust_abs;

  logic overflow;

  pa_fpu::e_fpu_state curr_state_fpu_fsm;
  pa_fpu::e_fpu_state next_state_fpu_fsm;

  assign a_mantissa      = {!(a_exp == 8'd0), operand_a[22:0]};
  assign a_exp           = operand_a[30:23];
  assign a_sign          = operand_a[31];
  assign b_mantissa      = {!(b_exp == 8'd0), operand_b[22:0]};
  assign b_exp           = operand_b[30:23];
  assign b_sign          = operand_b[31];

  assign result[22:0]    = result_mantissa[22:0];
  assign result[30:23]   = result_exp;
  assign result[31]      = result_sign;

  assign aexp_no_bias    = a_exp - 127;
  assign bexp_no_bias    = b_exp - 127;

  assign ab_exp_diff     = aexp_no_bias - bexp_no_bias;
  assign ba_exp_diff     = bexp_no_bias - aexp_no_bias;

  assign agtb            = a_mantissa > b_mantissa;
  assign bgta            = b_mantissa > a_mantissa;

  // if aexp < bexp, then increase aexp and right-shift a_mantissa by same number
  // else if aexp > bexp, then increase bexp and right-shift b_mantissa by same number
  // else, exponents are the same and we are ok
  always_comb begin
    if(operation == op_add || operation == op_sub) begin
      if(aexp_no_bias  < bexp_no_bias) begin
        a_mantissa_after_adjust = a_mantissa >> ba_exp_diff;
        b_mantissa_after_adjust = b_mantissa;
        aexp_after_adjust       = aexp_no_bias + ba_exp_diff;
        bexp_after_adjust       = bexp_no_bias;
      end   
      else if(aexp_no_bias  > bexp_no_bias) begin
        a_mantissa_after_adjust = a_mantissa;
        b_mantissa_after_adjust = b_mantissa >> ab_exp_diff;
        aexp_after_adjust       = aexp_no_bias;
        bexp_after_adjust       = bexp_no_bias + ab_exp_diff;
      end   
      else begin
        a_mantissa_after_adjust = a_mantissa;
        b_mantissa_after_adjust = b_mantissa;
        aexp_after_adjust       = aexp_no_bias;
        bexp_after_adjust       = bexp_no_bias;
      end

      a_mantissa_after_adjust_abs = a_mantissa_after_adjust;
      b_mantissa_after_adjust_abs = b_mantissa_after_adjust;

      if(a_sign == 1'b1) 
        a_mantissa_after_adjust = ~a_mantissa_after_adjust + 1;
      if(b_sign == 1'b1) 
        b_mantissa_after_adjust = ~b_mantissa_after_adjust + 1;
    end

    if(operation == op_add) begin
      result_mantissa            = a_mantissa_after_adjust + b_mantissa_after_adjust;
      if(result_mantissa[23:0] == 23'd0) begin
        result_exp = 8'd0; 
        result_mantissa_before_inv   = result_mantissa;
        result_mantissa_before_shift = result_mantissa;
        result_sign                  = 1'b0;
      end
      else begin
        result_mantissa_before_inv = result_mantissa;
        result_exp                 = aexp_after_adjust;
        result_sign                = result_mantissa[24];
        if(result_sign) result_mantissa = -result_mantissa;
        result_mantissa_before_shift = result_mantissa;
        if(result_mantissa[24]) begin 
          result_mantissa = result_mantissa >> 1;
          result_exp = result_exp + 1;
        end
        if(op_written) 
          while(!result_mantissa[23]) begin
            result_mantissa = result_mantissa << 1;
            result_exp = result_exp - 1;
          end
        result_exp = result_exp + 8'd127;
      end
    end
    else if(operation == op_sub) begin
      result_mantissa = a_mantissa_after_adjust - b_mantissa_after_adjust; 
      result_exp      = aexp_after_adjust;
      result_mantissa_before_inv = result_mantissa;
      /*
      a    b     a-b  negative
      +    +     if b>a  
      +    -     
      -    +     always
      -    -     if a > b
      */
      result_sign     = a_sign == 0 && b_sign == 0 && b_mantissa_after_adjust > a_mantissa_after_adjust ||
                        a_sign == 1 && b_sign == 0 ||
                        a_sign == 1 && b_sign == 1 && a_mantissa_after_adjust > b_mantissa_after_adjust;
      if(result_mantissa[24]) begin
        result_mantissa = -result_mantissa;
        result_sign = 1'b1;
      end
      else result_sign = 1'b0;
      result_mantissa_before_shift = result_mantissa;
      while(!result_mantissa[23]) begin
        result_mantissa = result_mantissa << 1;
        result_exp = result_exp - 1;
      end
      result_exp = result_exp + 8'd127;
    end
    else if(operation == op_mul) begin
      result_exp  = aexp_no_bias + bexp_no_bias;
      result_sign = a_sign ^ b_sign;
      result_mantissa = a_mantissa_after_adjust * b_mantissa_after_adjust;
      while(!result_mantissa[47]) begin
        result_mantissa = result_mantissa << 1;
        result_exp = result_exp - 1;
      end
      result_mantissa = result_mantissa >> 24;
      result_exp = result_exp + 8'd24;
      result_exp = result_exp + 8'd127;
    end
  end
           
  always_comb begin
    if(cs == 1'b0 && rd == 1'b0) begin
      case(addr)
        6'h0: databus_out = operand_a[7:0];
        6'h1: databus_out = operand_a[15:8];
        6'h2: databus_out = operand_a[23:16];
        6'h3: databus_out = operand_a[31:24];

        6'h4: databus_out = operand_b[7:0];
        6'h5: databus_out = operand_b[15:8];
        6'h6: databus_out = operand_b[23:16];
        6'h7: databus_out = operand_b[31:24];

        6'h8: databus_out = operation;

        6'h9: databus_out = result[7:0];
        6'hA: databus_out = result[15:8];
        6'hB: databus_out = result[23:16];
        6'hC: databus_out = result[31:24];

        default: databus_out = '0;
      endcase      
    end
    else databus_out = 'z;
  end

  always_latch begin
    if(arst) begin
      operand_a  = '0;
      operand_b  = '0;
      operation  = op_add;  
      op_written = 1'b0;
    end
    else if(cs == 1'b0 && wr == 1'b0) begin
      case(addr)
        6'h0: operand_a[7:0]   = databus_in;
        6'h1: operand_a[15:8]  = databus_in;
        6'h2: operand_a[23:16] = databus_in;
        6'h3: operand_a[31:24] = databus_in;

        6'h4: operand_b[7:0]   = databus_in;
        6'h5: operand_b[15:8]  = databus_in;
        6'h6: operand_b[23:16] = databus_in;
        6'h7: operand_b[31:24] = databus_in;

        6'h8: begin
          operation            = e_fpu_operation'(databus_in[3:0]);
          op_written           = 1'b1;
        end
      endcase      
    end
    else if(
      curr_state_fpu_fsm == pa_fpu::start_add_st ||
      curr_state_fpu_fsm == pa_fpu::start_sub_st ||
      curr_state_fpu_fsm == pa_fpu::start_mul_st ||
      curr_state_fpu_fsm == pa_fpu::start_div_st
    ) 
      op_written = 1'b0;
  end

  always_comb begin
    next_state_fpu_fsm = curr_state_fpu_fsm;

    case(curr_state_fpu_fsm)
      pa_fpu::idle_st: 
        if(op_written && wr)
          case(operation)
            pa_fpu::op_add:
              next_state_fpu_fsm = pa_fpu::start_add_st;
            pa_fpu::op_sub:
              next_state_fpu_fsm = pa_fpu::start_sub_st;
            pa_fpu::op_mul:
              next_state_fpu_fsm = pa_fpu::start_mul_st;
            pa_fpu::op_div:
              next_state_fpu_fsm = pa_fpu::start_div_st;
          endcase

      default:
        next_state_fpu_fsm = pa_fpu::idle_st;
    endcase
  end

  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      cmd_end <= 1'b0;
      status <= '0;
    end
    else begin
      case(next_state_fpu_fsm)
        pa_fpu::start_add_st: begin
          
        end
        default: begin
          
        end
      endcase  

    end
  end

  always_ff @(posedge clk, posedge arst) begin
    if(arst) 
      curr_state_fpu_fsm <= idle_st;
    else 
      curr_state_fpu_fsm <= next_state_fpu_fsm;
  end

endmodule
