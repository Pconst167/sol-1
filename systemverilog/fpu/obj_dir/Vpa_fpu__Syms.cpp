// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vpa_fpu__pch.h"
#include "Vpa_fpu.h"
#include "Vpa_fpu___024root.h"

// FUNCTIONS
Vpa_fpu__Syms::~Vpa_fpu__Syms()
{
}

Vpa_fpu__Syms::Vpa_fpu__Syms(VerilatedContext* contextp, const char* namep, Vpa_fpu* modelp)
    : VerilatedSyms{contextp}
    // Setup internal state of the Syms class
    , __Vm_modelp{modelp}
    // Setup module instances
    , TOP{this, namep}
{
        // Check resources
        Verilated::stackCheck(2773);
    // Configure time unit / time precision
    _vm_contextp__->timeunit(-12);
    _vm_contextp__->timeprecision(-12);
    // Setup each module's pointers to their submodules
    // Setup each module's pointer back to symbol table (for public functions)
    TOP.__Vconfigure(true);
}
