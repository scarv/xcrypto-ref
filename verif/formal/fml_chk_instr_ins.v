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

`VTX_CHECKER_MODULE_BEGIN(instr_ins)

wire [ 4:0] ins_begin = dec_arg_cs;
wire [ 5:0] ins_len   = dec_arg_cl+1;

wire [31:0] ins_mask    = ~(32'hFFFF_FFFF << (ins_len));
wire [31:0] ins_mask_sh = ins_mask << ins_begin;
wire [31:0] to_insert   = (`CRS1 & ins_mask) << ins_begin;

wire [31:0] ins_result  = 
    (to_insert) |
    (vtx_crd_val_pre & ~(ins_mask_sh));
    

//
// ins
//
`VTX_CHECK_INSTR_BEGIN(ins) 

    `VTX_ASSERT_CRD_VALUE_IS(ins_result)

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(ins)

`VTX_CHECKER_MODULE_END
