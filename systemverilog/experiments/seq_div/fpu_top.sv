module fpu(
  input  logic arst,
  input  logic clk,
  input  logic [23:0] dividend,
  input  logic [23:0] divisor,
  input logic start_operation_div_fsm,
  output logic [23:0] quotient,
  output logic operation_done_div_fsm    
);

  typedef enum logic [2:0]{
    div_idle_st,
    div_start_st,
    div_shift_st,
    div_sub_divisor_test_st,
    div_set_a0_1_st,
    div_check_counter_st,
    div_result_valid_st
  } e_div_states;

  // division datapath signals
  logic [48:0] remainder_dividend; // one extra bit for when dividend < divisor
                                  
  logic  [5:0] div_counter;
  logic        div_shift;
  logic        div_sub_divisor;
  logic        div_set_a0_1;
  logic [24:0] minus_divisor;
  logic [47:0] q;

  e_div_states   curr_state_div_fsm;
  e_div_states   next_state_div_fsm;

  assign minus_divisor = ~{1'b0, divisor} + 1'b1;

  // if the divisor has a number of significant bits equal to the dividends, then it needs to be shifted left by that number of bits
  //  before the first subtraction can happen, so that when it does happen the q0 bit is set. then we shift the extra 24 times and the quotient will be located
  // at the lower 24 bits of the quotient.
  // but if the divisor has a number of significant bits less than the dividends say by N, then after 24-N shifts we can do the first subtraction.
  // thus q0 will be first set to 1 at that moment. since we have a total of 47 shifts, the final qotient will be shifted left by N positions from the lower 24 bits.
  // this needs to be taken into account. perhaps we need to count the number of significant bits in both numbers and do some arithmetic with that
  // to guarantee we know where the quotients significant bits will be located in the end. 
  // division datapath
  always @(posedge clk, posedge arst) begin
    if(arst) begin
      remainder_dividend <= '0;
      div_counter        <= '0;
      quotient <= '0;
      q <= '0;
    end
    else begin
      if(next_state_div_fsm == div_start_st) begin
        if(dividend > divisor) div_counter <= 48;
        else div_counter <= 47;
        remainder_dividend <= {25'b0, dividend};  // dividend starts at lower 24 bits. this needs to be the case for the subtractions to make sense when the divisor is very small such as 1
      end
      if(div_shift) begin
        remainder_dividend <= remainder_dividend << 1;
        q <= q << 1;
      end
      if(div_set_a0_1) begin
        q[0] <= 1'b1;
        remainder_dividend[48:24] <= remainder_dividend[48:24] + minus_divisor;
      end
      if(next_state_div_fsm == div_sub_divisor_test_st)  
        div_counter <= div_counter - 1;
      if(next_state_div_fsm == div_result_valid_st) begin
        quotient <= q[47:24];
      end
    end
  end

  // divide fsm
  // next state assignments
  always_comb begin
    logic [25:0] intermediary;
    next_state_div_fsm = curr_state_div_fsm;

    case(curr_state_div_fsm)
      div_idle_st: 
        if(start_operation_div_fsm) next_state_div_fsm = div_start_st;

      div_start_st:
        next_state_div_fsm = div_shift_st;

      div_shift_st:
        next_state_div_fsm = div_sub_divisor_test_st;
      
      div_sub_divisor_test_st: begin
        intermediary = remainder_dividend[48:24] + minus_divisor;
        if(intermediary[25] == 1'b0) next_state_div_fsm = div_check_counter_st; // result is negative
        else next_state_div_fsm = div_set_a0_1_st; // result is positive
      end
      
      div_set_a0_1_st:
        next_state_div_fsm = div_check_counter_st;

      div_check_counter_st:
        if(div_counter == 6'h0) next_state_div_fsm = div_result_valid_st;
        else next_state_div_fsm = div_shift_st;
      
      div_result_valid_st:
        if(start_operation_div_fsm == 1'b0) next_state_div_fsm = div_idle_st;

      default:
        next_state_div_fsm = div_idle_st;
    endcase
  end

  // divide fsm
  // output assignments
  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      operation_done_div_fsm <= 1'b0;
      div_shift              <= 1'b0;
      div_sub_divisor        <= 1'b0;
      div_set_a0_1           <= 1'b0;
    end
    else begin
      case(next_state_div_fsm)
        div_idle_st: begin
          operation_done_div_fsm <= 1'b0;
          div_shift              <= 1'b0;
          div_sub_divisor        <= 1'b0;
          div_set_a0_1           <= 1'b0;
        end
        div_start_st: begin
          operation_done_div_fsm <= 1'b0;
          div_shift              <= 1'b0;
          div_sub_divisor        <= 1'b0;
          div_set_a0_1           <= 1'b0;
        end
        div_shift_st: begin
          operation_done_div_fsm <= 1'b0;
          div_shift              <= 1'b1;
          div_sub_divisor        <= 1'b0;
          div_set_a0_1           <= 1'b0;
        end
        div_sub_divisor_test_st: begin
          operation_done_div_fsm <= 1'b0;
          div_shift              <= 1'b0;
          div_sub_divisor        <= 1'b0;
          div_set_a0_1           <= 1'b0;
        end
        div_set_a0_1_st: begin
          operation_done_div_fsm <= 1'b0;
          div_shift              <= 1'b0;
          div_sub_divisor        <= 1'b0;
          div_set_a0_1           <= 1'b1;
        end
        div_check_counter_st: begin
          operation_done_div_fsm <= 1'b0;
          div_shift              <= 1'b0;
          div_sub_divisor        <= 1'b0;
          div_set_a0_1           <= 1'b0;
        end
        div_result_valid_st: begin
          operation_done_div_fsm <= 1'b1;
          div_shift              <= 1'b0;
          div_sub_divisor        <= 1'b0;
          div_set_a0_1           <= 1'b0;
        end
      endcase  
    end
  end

  // divide fsm
  // next state clocking
  always_ff @(posedge clk, posedge arst) begin
    if(arst) curr_state_div_fsm <= div_idle_st;
    else curr_state_div_fsm <= next_state_div_fsm;
  end

endmodule