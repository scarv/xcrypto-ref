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

`VTX_CHECKER_MODULE_BEGIN(instr_str_h)

wire [31:0] sh_addr = `RS1 + `RS2;

wire [ 1:0] src_byte = dec_arg_b0;

wire [15:0] sh_wdata = src_byte == 2'd2 ? `CRD[31:16] :
                       src_byte == 2'd0 ? `CRD[15: 0] :
                                           16'b0      ;

//
// str_h
//
`VTX_CHECK_INSTR_BEGIN(str_h) 

    // Make sure it never gives the wrong error code.
    `VTX_ASSERT(vtx_instr_result != SCARV_COP_INSN_LD_ERR);
    `VTX_ASSERT(vtx_instr_result != SCARV_COP_INSN_BAD_LAD);

    if(sh_addr[0]) begin

        `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_BAD_SAD)

    end else if(src_byte != 2'd0 && src_byte != 2'd2) begin

        `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_BAD_INS)
        `VTX_ASSERT(vtx_mem_cen_0  == 1'b0);

    end else if(vtx_instr_result == SCARV_COP_INSN_SUCCESS) begin
    
        // If the instruction succeeds, check it wrote the right data

        `VTX_ASSERT(vtx_mem_cen_0  == 1'b1);
        `VTX_ASSERT(vtx_mem_wen_0  == 1'b1);
        `VTX_ASSERT(vtx_mem_addr_0 == {sh_addr[31:2],2'b00});
        
        if(sh_addr[1]) begin
            `VTX_ASSERT(vtx_mem_wdata_0[31:16] == sh_wdata);
            `VTX_ASSERT(vtx_mem_ben_0          == 4'b1100);
        end else begin
            `VTX_ASSERT(vtx_mem_wdata_0[15: 0] == sh_wdata);
            `VTX_ASSERT(vtx_mem_ben_0          == 4'b0011);
        end

    end else if(vtx_instr_result == SCARV_COP_INSN_ST_ERR) begin
        
        // Transaction should have started correctly.
        `VTX_ASSERT(vtx_mem_cen_0  == 1'b1);
        `VTX_ASSERT(vtx_mem_wen_0  == 1'b1);
        `VTX_ASSERT(vtx_mem_addr_0 == {sh_addr[31:2],2'b00});
        
        if(sh_addr[1]) begin
            `VTX_ASSERT(vtx_mem_wdata_0[31:16] == sh_wdata);
            `VTX_ASSERT(vtx_mem_ben_0          == 4'b1100);
        end else begin
            `VTX_ASSERT(vtx_mem_wdata_0[15: 0] == sh_wdata);
            `VTX_ASSERT(vtx_mem_ben_0          == 4'b0011);
        end

    end

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(str_h)

`VTX_CHECKER_MODULE_END
