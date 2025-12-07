package pa_testbench;

  parameter KB = 1024;


  function logic [7:0] ROL(logic [7:0] value, logic [2:0] places);
    return (value << places) | (value >> (8 - places));
  endfunction

  function logic [7:0] ROR(logic [7:0] value, logic [2:0] places);
    return (value >> places) | (value << (8 - places));
  endfunction

endpackage
