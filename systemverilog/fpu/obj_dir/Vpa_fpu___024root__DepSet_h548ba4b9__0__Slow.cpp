// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vpa_fpu.h for the primary calling header

#include "Vpa_fpu__pch.h"
#include "Vpa_fpu__Syms.h"
#include "Vpa_fpu___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vpa_fpu___024root___dump_triggers__stl(Vpa_fpu___024root* vlSelf);
#endif  // VL_DEBUG

VL_ATTR_COLD void Vpa_fpu___024root___eval_triggers__stl(Vpa_fpu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vpa_fpu___024root___eval_triggers__stl\n"); );
    Vpa_fpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VstlTriggered.setBit(0U, (IData)(vlSelfRef.__VstlFirstIteration));
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vpa_fpu___024root___dump_triggers__stl(vlSelf);
    }
#endif
}
