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

`VTX_CHECKER_MODULE_BEGIN(instr_bmv)

wire [ 4:0] bmv_src   = dec_arg_cs;
wire [ 4:0] bmv_dest  = dec_arg_cl;
wire [31:0] bmv_result;
wire        bmv_bit   = `CRS1[bmv_src];

genvar i;

generate for(i=0; i < 32; i = i + 1) begin

    assign bmv_result[i] = (i == bmv_dest) ? bmv_bit : `CRD[i];

end endgenerate

//
// bmv
//
`VTX_CHECK_INSTR_BEGIN(bmv) 

    `VTX_ASSERT_CRD_VALUE_IS(bmv_result)

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(bmv)

`VTX_CHECKER_MODULE_END
