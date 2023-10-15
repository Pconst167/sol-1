module ide(
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
  
  typedef enum logic [3:0] {
    RESET_ST = 4'h0,
    BUSY_ST,
    READ_START_ST,
    READ_ST,
    WRITE_START_ST,
    WRITE_ST,
    COMPLETE_ST
  } t_ideState;

  t_ideState currentState;
  t_ideState nextState;

  logic [7:0] LBA [2:0];
  logic [9:0] byteCounter;
  logic [7:0] mem [672 * KB];
  logic [7:0] registers [7:0];
  logic [7:0] command;
  logic [7:0] status;

  initial begin
    static int fp = $fopen("../disk_backups/image_10Mar2023", "rb");
    $display("Loading disk image...");
    if(!fp) $fatal("Failed to open disk image");
    if(!$fread(mem, fp)) $fatal("Failed to read disk image");
    $display("OK.");
  end

  assign data_out = !ce_n && !oe_n && we_n ? address == 3'h7 ? status : registers[address] : 'z;
  assign LBA = registers[5:3];

// State machine
  always @(posedge clk, posedge arst) begin
    if(arst) begin
      command <= '0;
      status <= 8'b0000_0000;
      byteCounter <= '0;
    end
    else case(currentState)
      RESET_ST: begin
      end
      WRITE_START_ST: begin
        byteCounter <= '0;
        status <= status | 8'b0000_1000; // not finished
      end
      READ_START_ST: begin
        byteCounter <= '0;
        status <= status | 8'b0000_1000; // not finished
      end
      COMPLETE_ST: begin
        status <= status & 8'b1111_0111; // finished
        command <= '0;
      end
    endcase
  end

  always @(negedge oe_n, negedge we_n) begin
    if(!oe_n && address == 3'h0 && !ce_n) begin
      registers[0] <= mem[{LBA[2], LBA[1], LBA[0]} + byteCounter];
      byteCounter <= byteCounter + 10'd1;
    end
    else if(!we_n && !ce_n) begin
      if(address == 3'h0) begin
        mem[{LBA[2], LBA[1], LBA[0]} + byteCounter] <= data_in;
        registers[0] <= data_in; // for completion sake
        byteCounter <= byteCounter + 10'd1;
      end
      else if(!we_n && !ce_n && address == 3'h7) command <= data_in;
      else registers[address] <= data_in;
    end
  end

  always_ff @(posedge clk, posedge arst) begin
    if(arst) begin
      currentState <= RESET_ST;
    end
    else currentState <= nextState;
  end

  always_comb begin
    nextState = currentState;
    case(currentState)
      RESET_ST:
        if(command == 8'h20) nextState = READ_START_ST;
        else if(command == 8'h30) nextState = WRITE_START_ST;
      WRITE_START_ST:
        nextState = WRITE_ST;
      READ_START_ST:
        nextState = READ_ST;
      READ_ST:
        if(byteCounter == 10'd512) nextState = COMPLETE_ST;
        else if(!oe_n && !ce_n && address == 3'h0) nextState = READ_ST;
      WRITE_ST:
        if(byteCounter == 10'd512) nextState = COMPLETE_ST;
        else if(!we_n && !ce_n && address == 3'h0) nextState = WRITE_ST;
      COMPLETE_ST:
        nextState = RESET_ST;
    endcase
  end

endmodule
