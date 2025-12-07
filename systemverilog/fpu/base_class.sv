virtual class cl_base;
  virtual interface_fpu in_fpu;

  string allTestCases[$];

  string logQueue[$];
  bit resultsQueue[$];
  int passCount;
  int failCount;

  // -- Class constructor.
  function new(virtual interface_fpu in_fpu);
    new(in_fpu);
    this.in_fpu = in_fpu;
  endfunction : new

  // -- Virtual task to list test cases in regression.
  virtual task ta_listTestsInRegression();
    foreach (allTestCases[i]) begin
      $display("%s", allTestCases[i]);
    end
  endtask : ta_listTestsInRegression

  // Pure virtual task to execute selected test case.
  pure virtual task ta_execute(string testCase, string subTest = "");

  task ta_pushPass(string condition = "");
    if(condition != "") fn_printLog($sformatf("%s (PASS)", condition));
    resultsQueue.push_back(1'b1);
    passCount++;
  endtask

  task ta_pushFail(string condition = "");
    if(condition != "") fn_printErr($sformatf("%s (FAIL)", condition));
    resultsQueue.push_back(1'b0);
    failCount++;
  endtask

  task ta_pushResult(bit result, string condition = "");
    resultsQueue.push_back(result);
    if(result) begin 
      if(condition != "") fn_printLog($sformatf("%s (PASS)", condition));
      passCount++;
    end
    else begin
      if(condition != "") fn_printErr($sformatf("%s (FAIL)", condition));
      failCount++;
    end
  endtask

  function bit fu_evaluateFinalResult;
    static bit finalResult = 1;
    foreach(resultsQueue[i]) finalResult = finalResult && resultsQueue[i];
    return finalResult;
  endfunction

  task ta_setPhase(string phase);
    in_fpu.ta_setTestPhase(phase);
  endtask

  task ta_header(string testName);
    string s;
    s = "----------------------------------------------------------------------------------------------------------------------------------";
    $display(s);
    logQueue.push_back(s);
    s = $sformatf("%t : Initializing test run for: '%s'", $time, testName);
    $display(s);
    logQueue.push_back(s);
    s = "----------------------------------------------------------------------------------------------------------------------------------";
    $display(s);
    logQueue.push_back(s);
  endtask

  // Print test footer
  task ta_footer(string testName);
    string s;
    s = "----------------------------------------------------------------------------------------------------------------------------------";
    $display(s);
    logQueue.push_back(s);
    s = $sformatf("%t: Test run completed for '%s' with %0d errors.", $time, testName, in_fpu.errorCount);
    $display(s);
    logQueue.push_back(s);
    s = "----------------------------------------------------------------------------------------------------------------------------------";
    $display(s);
    logQueue.push_back(s);
  //as_Test : assert (in_fpu.errorCount == 0) else $error("%s test: Failed.", testName);
  endtask

  // Print the test group name. 
  function void fn_printGroup(string message);
    string s;
    s = $sformatf("\n%t: Test group: %s", $time, message);
    $display(s);
    logQueue.push_back(s);
    s = "----------------------------------------------------------------------------------------------------------------------------------";
    $display(s);
    logQueue.push_back(s);
  endfunction

  // Print test description
  function void fn_printDesc(string message);
    string s;
    s = $sformatf("\n%t: Test description: %s", $time, message);
    $display(s);
    logQueue.push_back(s);
    s = "----------------------------------------------------------------------------------------------------------------------------------";
    $display(s);
    logQueue.push_back(s);
  endfunction

  // Print test log. Used for normal messages printed as the test runs.  
  function void fn_printLog(string message);
    string s;
    s = $sformatf("%t: Test log: %s", $time, message);
    $display(s);
    logQueue.push_back(s);
  endfunction

  // Print an error message.
  function void fn_printErr(string message);
    string s;
    s = $sformatf("%t: TEST ERROR: %s", $time, message);
    $error(s);
    logQueue.push_back(s);
  endfunction

  // Print final test results and statistics.
  function void fn_printResults(string testName, string testGroup = "");
    string s;
    int logFile;

    s = "----------------------------------------------------------------------------------------------------------------------------------";
    $display(s);
    logQueue.push_back(s);
    s = $sformatf("%t: Test run completed for '%s' with %0d errors.", $time, testName, in_fpu.errorCount);
    $display(s);
    logQueue.push_back(s);

    s = "----------------------------------------------------------------------------------------------------------------------------------";
    $display(s);
    s = "Test Results and Statistics";
    $display(s);
    s = "----------------------------------------------------------------------------------------------------------------------------------";
    $display(s);
    s = $sformatf("Total simulation time    : %.5fms", $realtime / 1e6);
    $display(s);
    logQueue.push_back(s);
    s = $sformatf("Total passing conditions : %0d", passCount);
    $display(s);
    logQueue.push_back(s);
    s = $sformatf("Total failing conditions : %0d", failCount);
    $display(s);
    logQueue.push_back(s);
    s = $sformatf("Final result             : %s", failCount > 0 ? "FAILED" : "PASSED");
    $display(s);
    logQueue.push_back(s);
    s = "----------------------------------------------------------------------------------------------------------------------------------";
    $display(s);
    logQueue.push_back(s);

    logFile = $fopen($sformatf("../../../testplan/test_logs/%s.%s", testGroup, testName), "w+");
    foreach(logQueue[index]) begin
      $fwrite(logFile, logQueue[index]);
      $fwrite(logFile, "\n");
    end
    $fclose(logFile);
  endfunction

  // Wait for a given state of StartupFsm.
  task ta_initAndWaitStartupState(
    pa_fpu::t_startupFsmStates state = pa_fpu::STARTUP_ACTIVE_ST, 
    time timeout = 30ms
  );
    ta_setPhase($sformatf("Initializing test and Waiting for StartupFsm State: %s", state.name()));
    in_fpu.ta_init(); // Initialize all testbench driven signals
    fork: la_waitStartupState
      begin
        wait(`p_fpu.startupFsmState == state);
        fn_printLog($sformatf("StartupFSM reached state '%s' successfully.", state.name()));
      end
      begin
        #timeout;
        $fatal("%t: StartupFsm failed to reach state: %s", state.name());
      end
    join_any
    disable la_waitStartupState;
  endtask

  task ta_testInit(real vbat = 0.0, real vbus = 0.0, real vsys = 0.0, real ivsys = 0.0, time delay = 0ms);
    ta_setPhase("Initializing test...");
    in_fpu.ta_init(); // Initialize all testbench driven signals
    #(delay);
  endtask : ta_testInit

  virtual task ta_cleanup();
  endtask

  task ta_waitValue( string name, ref logic waitSignal, input logic expectedValue , input time waitTime = 100us, output int errCntTa);
    errCntTa = 0;
    fork : waitValueFork
      begin
        wait (waitSignal == expectedValue);
        $display("%t: Base-class: %s == %0d (ok)",$time, name, expectedValue);
        disable waitValueFork;
      end
      begin
        #waitTime;
        $error("%t: Base-class: Waited %t, Expected %s to be %b, but it is %b (not ok!)",$time, waitTime, name, expectedValue, waitSignal);
        errCntTa++;
        disable waitValueFork;
      end
    join_any
  endtask : ta_waitValue

  task ta_minWaitValue( string name, ref logic waitSignal, input logic expectedValue , input time minWaitTime = 1us, input time maxWaitTime = 100us, output int errCntTa);
    bit minWaitOk = 0;

    errCntTa = 0;
    fork : minWaitValueFork
      begin
        #minWaitTime;
        minWaitOk = 1;
        $display("%t: minWaitOk -------------", $time);
      end
      begin
        wait  (waitSignal == expectedValue);
        if(~minWaitOk) begin
          $error("%t: Min wait time of %s == %0d value is not yet end!!",$time, name, expectedValue);
          errCntTa++;
        end
        $display("%t: expectedValue -----------", $time);
        disable minWaitValueFork;
      end
      begin
        #maxWaitTime;
        $error("%t: Wait time of %s == %0d value ends!!",$time, name, expectedValue);
        errCntTa++;
        disable minWaitValueFork;
      end
    join
  endtask

  task ta_testEnd;
    ta_setPhase("Test end.");
  endtask

  task ta_checkVal(input logic val, logic expVal, string name, bit printSuccess = 1'b1, output int errorCntTa);
    errorCntTa = 0;
    assert(val === expVal) begin
      if (printSuccess) $display("%t : OK: %s value is %0b",$time, name, val );
    end
    else begin
      $error("%t : Wrong value (%0b) at %s. Expected value %0b ",$time, val, name, expVal); 
      errorCntTa++; 
    end
  endtask

  task ta_frequencyCheck( string name, ref logic ckSignal, input real targetFreq, inout int errCnt );
    real t0, t1;
    real frequency;
    fork : frequencyCheck
      begin
        @ (posedge ckSignal) t0 = $realtime;
        @ (posedge ckSignal) t1 = $realtime;
        frequency = 1.0e9 / (t1 - t0);
      end
      begin
        #30us; //TWI clock can be 100kHz
        $warning("%t: Frequency check timed out. The %s clock signal might not be running", $time, name);
      end
    join_any
    disable frequencyCheck;
    assert ( frequency >= (0.999*targetFreq) && frequency <= (1.001*targetFreq)) begin
      $display("%t: Check frequency %0.2f Mhz. Measured frequency %0.3f Mhz from clock signal %s is OK", $time, targetFreq/1e6, frequency/1e6, name);
    end else begin
      $error("%t: Wrong frequency %0.3f Mhz! Should be %0.2f Mhz in %s", $time, frequency/1e6, targetFreq/1e6, name);
      errCnt++;
    end
  endtask : ta_frequencyCheck

  task ta_checkClockRunning ( ref logic ckSig, input string name = "clock", input realtime tCk, input int cycles = 50 );
    int clockEvent = 0;
    fork : CheckingClock
      begin
        repeat (cycles)
        begin
          @(posedge ckSig);
          clockEvent++;
        end
      end
      #((cycles + 2) * tCk);
    join_any
    disable fork;
    assert (clockEvent === cycles) else begin
      $error("%s not running", name);
      $display("Number of clock pulses: %d", clockEvent);
    end
  endtask

  task ta_timeout(time timeout = 50ms);
    fo_timeout: fork
      #(timeout) $fatal(1, $sformatf("Timed out after %t", $realtime));
    join_none: fo_timeout
  endtask : ta_timeout

  task ta_timeoutDis;
    disable ta_timeout.fo_timeout;
  endtask: ta_timeoutDis

endclass
