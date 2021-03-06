//
// SCARV Project
// 
// University of Bristol
// 
// RISC-V Cryptographic Instruction Set Extension
// 
// Reference Implementation
// 
// 

`include "fml_pack_widths.vh"

`VTX_CHECKER_MODULE_BEGIN(instr_macc_2)

reg [63:0] value;

//
// macc_2
//
`VTX_CHECK_INSTR_BEGIN(macc_2) 

    `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_SUCCESS)

    value = (`CRDM + `CRS1) + `CRS2;

    `VTX_ASSERT_CRDM_VALUE_IS(value)

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(macc_2)

`VTX_CHECKER_MODULE_END

