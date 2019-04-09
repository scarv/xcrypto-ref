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

`VTX_CHECKER_MODULE_BEGIN(instr_ext)

wire [ 4:0] ext_begin = dec_arg_cs;
wire [ 5:0] ext_len   = dec_arg_cl+1;
wire [31:0] ext_mask  = ~(32'hFFFF_FFFF <<(ext_len));
wire [31:0] ext_result= (`CRS1 >> ext_begin) & ext_mask;

//
// ext
//
`VTX_CHECK_INSTR_BEGIN(ext) 

    `VTX_ASSERT_CRD_VALUE_IS(ext_result)

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(ext)

`VTX_CHECKER_MODULE_END
