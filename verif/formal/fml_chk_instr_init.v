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


`VTX_CHECKER_MODULE_BEGIN(instr_init)

integer i;

//
// xc.init
//
`VTX_CHECK_INSTR_BEGIN(init) 

    //
    // All XCR registers should be zero.
    for(i = 0; i < 16; i = i + 1) begin
        `VTX_ASSERT(vtx_cprs_post[i] == 0);;
    end

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(init)

`VTX_CHECKER_MODULE_END
