class t_testCaseItem;
  string testClassName;
  string testCaseName;

  function string fu_toString();
    if (testCaseName == "_") return {"All tests in ", testClassName};
    return {testClassName, ".", testCaseName};
  endfunction : fu_toString

endclass: t_testCaseItem

program automatic testPr_fpu(
  interface_fpu in_fpu
);

  localparam string TESTBENCH = "fpu";
  typedef t_testCaseItem t_testCaseList [$];

  // -- Class declarations
  cl_base testClass;

  // -- Begin program
  initial begin
    t_testCaseList testCases;
    t_testCaseItem testCase;
    string str;

    // Setting time format.
    $timeformat(-6, 3, "us", 0);

    // Read test cases from file or parse from prompt.
    if ($test$plusargs("TESTLIST")) begin
      assert ($value$plusargs("TESTLIST=%s", str)) else begin
        $error("You did not specify a file name for the test list.");
        $finish;
      end
      testCases = fu_readTestList(str);
    end
    else if ($test$plusargs("TESTNAME")) begin
      assert ($value$plusargs("TESTNAME=%s", str)) else begin
        $error("You did not specify a test class to run.");
        $finish;
      end
      testCases = fu_parseTestList(str);
    end

  // Print out header with selected test cases.
    $display("---------------------------------------------------------------------------");
    $display("Verification of %s is starting...", TESTBENCH);
    $display("Test cases selected for simulation:");
    for (int i = 0; i < testCases.size; i++) $display("* %s", testCases[i].fu_toString());
    $display("---------------------------------------------------------------------------");

   // Loop test cases.
    while (testCases.size > 0) begin
      testCase = testCases.pop_front();
      $display("%t: Selected test class: %s", $time, testCase.testClassName);

      // Create test class.
      testClass = fu_createTestClass(testCase.testClassName);

      // Start test case(s).
      if (testCase.testCaseName == "_") begin
        $display("%t: Running all test cases in %s", $time, testCase.testClassName);
        foreach (testClass.allTestCases[i]) begin
          $system({"/bin/date +\'*** Starting: ", testCase.testClassName, ".", testClass.allTestCases[i], " AT %H:%M:%S.%N; SIM TIME ", $sformatf("%t", $time), "\'"});
          testClass.ta_execute(testClass.allTestCases[i], testCase.testClassName);
          $system({"/bin/date +\'*** Ending: ", testCase.testClassName, ".", testClass.allTestCases[i], " AT %H:%M:%S.%N; SIM TIME ", $sformatf("%t", $time), "\'"});
          $display("");
        end
        $display("%t: All test cases in %s have now been completed.", $time, testCase.testClassName);
        $display("");
      end
      else begin
        $system({"/bin/date +\'*** Starting: ", testCase.fu_toString(), " AT %H:%M:%S.%N; SIM TIME ", $sformatf("%t", $time), "\'"});
        testClass.ta_execute(testCase.testCaseName, testCase.testClassName);
        $system({"/bin/date +\'*** Ending: ", testCase.fu_toString(), " AT %H:%M:%S.%N; SIM TIME ", $sformatf("%t", $time), "\'"});
        $display("");
      end
    end

    // Print out footer.
    $display("---------------------------------------------------------------------------");
    $display("Verification of %s is ending.", TESTBENCH);
    as_testPrFailed: assert (in_fpu.errorCount == 0) else $error("Test contains errors. FAILED.");
    $display("");
    $display("Total Error Count = %0d", in_fpu.errorCount);
    $display("**** Check functional coverage ****");
    $display("---------------------------------------------------------------------------");
  end

  // -- Function to read test list from file.
  function t_testCaseList fu_readTestList(string fileName);
    automatic t_testCaseList tests;
    automatic t_testCaseItem test;
    automatic integer fileHandle;
    automatic string line;

    fileHandle = $fopen(fileName, "r");
    while ($fgets(line, fileHandle) != 32'h00000000) begin
      while (line[line.len() - 1] == "\n" || line[line.len() - 1] == "\r") line = line.substr(0, line.len() - 2);
        test = fu_parseTestCaseString(line);
      if (test.testClassName[0] != "#") begin
        tests.push_back(test);
      end
    end
    $fclose(fileHandle);

    return tests;
  endfunction : fu_readTestList

  // -- Function to parse test list.
  function t_testCaseList fu_parseTestList(string testList);
    automatic t_testCaseList tests;
    automatic t_testCaseItem test;
    automatic int startIndex, endIndex;

    startIndex = 0;
    endIndex   = 0;
    while (endIndex < testList.len()) begin
      while (testList[endIndex] != "," && testList[endIndex] != 0) endIndex++;
      test = fu_parseTestCaseString(testList.substr(startIndex, endIndex - 1));
      startIndex = ++endIndex;
      if (test.testClassName[0] != "#") begin
        tests.push_back(test);
      end
    end

    return tests;
  endfunction : fu_parseTestList

  // -- Function to parse test case ID string.
  function t_testCaseItem fu_parseTestCaseString(string str);
    automatic t_testCaseItem test;
    automatic int startIndex, endIndex;

    startIndex = 0;
    endIndex = 0;
    test = new();
    while (str[endIndex] != "." && str[endIndex] != 0) endIndex++;
    test.testClassName = str.substr(startIndex, endIndex - 1);
    startIndex = ++endIndex;
    while (str[endIndex] != 0) endIndex++;
    test.testCaseName = str.substr(startIndex, endIndex - 1);

    return test;
  endfunction : fu_parseTestCaseString

  // -- Function to create test case class.
  function automatic cl_base fu_createTestClass(string testCase);
    case (testCase)
      "TEST1": begin
        automatic cl_test1 test1 = new(in_fpu);
        return test1;
      end

      "TEST2": begin
        automatic cl_test1 test1 = new(in_fpu);
        return test1;
      end

      default: begin
        $error("Unrecognized test class, specify it using +TESTNAME=");
        $finish;
      end
    endcase
  endfunction : fu_createTestClass

endprogram
