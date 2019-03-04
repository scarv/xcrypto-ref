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

`include "fml_common.vh"

`VTX_CHECKER_MODULE_BEGIN(instr_ldr_hu)

wire [31:0] lh_addr = `RS1 + `RS2;

wire [15:0] lh_rdata = lh_addr[1] ? vtx_mem_rdata_0[31:16] :
                                    vtx_mem_rdata_0[15: 0] ;

// Write loaded data to upper (1) or lower (0) halfword of destination
// register.
wire [1:0] dest_halfword = dec_arg_b0;

//
// ldr_hu
//
`VTX_CHECK_INSTR_BEGIN(ldr_hu) 

    // Make sure it never gives the wrong error code.
    `VTX_ASSERT(vtx_instr_result != SCARV_COP_INSN_ST_ERR);
    `VTX_ASSERT(vtx_instr_result != SCARV_COP_INSN_BAD_SAD);

    if(dest_halfword != 2'd2 && dest_halfword != 2'd0) begin
        
        `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_BAD_INS)
        `VTX_ASSERT_CRD_VALUE_IS(vtx_crd_val_pre)

    end else if(lh_addr[0]) begin

        `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_BAD_LAD)
        `VTX_ASSERT_CRD_VALUE_IS(vtx_crd_val_pre)

    end else if(vtx_instr_result == SCARV_COP_INSN_SUCCESS) begin

        `VTX_ASSERT(vtx_mem_cen_0  == 1'b1);
        `VTX_ASSERT(vtx_mem_wen_0  == 1'b0);
        `VTX_ASSERT(vtx_mem_addr_0 == {lh_addr[31:2],2'b0});

        if(dest_halfword == 2'd2) begin
        
            // Load to upper halfword of CPR leaving low half unmodified
            `VTX_ASSERT_CRD_VALUE_IS({lh_rdata, vtx_crd_val_pre[15:0]})

        end else begin

            // Load to lower halfword of CPR and blank high half.
            `VTX_ASSERT_CRD_VALUE_IS({16'b0, lh_rdata})

        end

    end else if(vtx_instr_result == SCARV_COP_INSN_LD_ERR) begin
        
        // Transaction should have started correctly.
        `VTX_ASSERT(vtx_mem_cen_0  == 1'b1);
        `VTX_ASSERT(vtx_mem_wen_0  == 1'b0);
        `VTX_ASSERT(vtx_mem_addr_0 == {lh_addr[31:2],2'b0});

    end

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(ldr_hu)

`VTX_CHECKER_MODULE_END

