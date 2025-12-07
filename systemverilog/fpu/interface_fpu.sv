interface interface_fpu;

  static string testPhase; // String variable to give text information to help debug waves

  int errorCount; // total error count
  int errorCntTb; // Error count of tb      
  int errorCntAs; // Error count assertion

  logic clk;
  logic arst;

  task ta_init();
    ta_setTestPhase($sformatf("%t: ta_init executing...", $realtime));
  endtask: ta_init

  task ta_setTestPhase(string phase);
    testPhase = phase;
    $info("%t: %s", $time, phase);
  endtask: ta_setTestPhase

endinterface
