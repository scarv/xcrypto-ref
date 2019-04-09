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

`VTX_CHECKER_MODULE_BEGIN(instr_pbyte)

wire [31:0] perm_in    = `CRS1;

wire [7:0] bytes [3:0];

assign bytes[0] = perm_in[ 7: 0];
assign bytes[1] = perm_in[15: 8];
assign bytes[2] = perm_in[23:16];
assign bytes[3] = perm_in[31:24];

wire [31:0] perm_result =  {
    bytes[dec_arg_b3],
    bytes[dec_arg_b2],
    bytes[dec_arg_b1],
    bytes[dec_arg_b0]
};


//
// pbyte
//
`VTX_CHECK_INSTR_BEGIN(pbyte) 

    `VTX_ASSERT_CRD_VALUE_IS(perm_result)

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(pbyte)

`VTX_CHECKER_MODULE_END
