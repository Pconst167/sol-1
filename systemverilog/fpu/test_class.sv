class cl_additionTest extends cl_base;

  function new(virtual interface_fpu in_fpu);
    super.new(in_fpu);
    this.allTestCases = {
    };
  endfunction: new

  task ta_execute(string testCase, string subTest = "");
    case (testCase)
            "SECTION1": ta_section1(testCase);
            "SECTION2": ta_section2(testCase);
              default : $error("Unknown test.");
    endcase
  endtask: ta_execute

  task ta_section1(string testName);
    int errorCnt = 0;
    logic [7:0] readData;

    ta_header(testName);

    #10ms;

    ta_footer(testName);
    assert (errorCnt == 0) else $error("FPU.%s: Failed.", testName);
    this.in_fpu.errorCount += errorCnt;
    #1ns;
  endtask

  task ta_section2(string testName);
    int errorCnt = 0;
    logic [7:0] readData;

    ta_header(testName);
    ta_testInit(.vbat(4.0));

    #30ms;

    ta_footer(testName);
    assert (errorCnt == 0) else $error("FPU.%s: Failed.", testName);
    this.in_fpu.errorCount += errorCnt;
    #1ns;
  endtask

endclass
