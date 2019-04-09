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

//
// module: scarv_cop_palu
//
//  Combinatorial Packed arithmetic and shift module.
//
// notes:
//  - INS, BMV, ld.[l|h]iu, scatter/gather, ld.hu, ld.bu expects
//    crd value to be in palu_rs3
//
module scarv_cop_palu (
input  wire         g_clk            ,
input  wire         g_resetn         ,

input  wire         palu_ivalid      , // Valid instruction input
output wire         palu_idone       , // Instruction complete

input  wire [31:0]  gpr_rs1          , // GPR Source register 1
input  wire [31:0]  palu_rs1         , // Source register 1
input  wire [31:0]  palu_rs2         , // Source register 2
input  wire [31:0]  palu_rs3         , // Source register 3

input  wire [31:0]  id_imm           , // Source immedate
input  wire [ 2:0]  id_pw            , // Pack width
input  wire [ 8:0]  id_class         , // Instruction class
input  wire [14:0]  id_subclass      , // Instruction subclass

output wire [ 3:0]  palu_cpr_rd_ben  , // Writeback byte enable
output wire [31:0]  palu_cpr_rd_wdata  // Writeback data
);

// Commom field name and values.
`include "scarv_cop_common.vh"

// Purely combinatoral block.
assign palu_idone = palu_ivalid &&
                    (is_mul ? mul_done : 1'b1);

// Detect which subclass of instruction to execute.
wire is_mov_insn  = 
    palu_ivalid && id_class[SCARV_COP_ICLASS_MOVE];

wire is_bitwise_insn = 
    palu_ivalid && id_class[SCARV_COP_ICLASS_BITWISE];

wire is_parith_insn = 
    palu_ivalid && id_class[SCARV_COP_ICLASS_PACKED_ARITH];

//
// Result data muxing
assign palu_cpr_rd_wdata = 
    {32{is_mov_insn     }} & result_cmov    |
    {32{is_bitwise_insn }} & result_bitwise |
    {32{is_parith_insn  }} & result_parith  ;

//
// Should the result be written back?
assign palu_cpr_rd_ben = {4{palu_idone}} & (
    is_mov_insn                       ? {4{wen_cmov}} :
    is_bitwise_insn || is_parith_insn ? 4'hF          :
                                        4'h0         );

// ----------------------------------------------------------------------

//
//  Conditional Move Instructions
//

wire        cmov_cond   = palu_rs2 != 0;
wire [31:0] result_cmov = is_gpr2xcr ? gpr_rs1 : palu_rs1;

wire  is_cmov_t  = is_mov_insn && id_subclass[SCARV_COP_SCLASS_CMOV_T ];
wire  is_cmov_f  = is_mov_insn && id_subclass[SCARV_COP_SCLASS_CMOV_F ];
wire  is_gpr2xcr = is_mov_insn && id_subclass[SCARV_COP_SCLASS_GPR2XCR];

wire        wen_cmov    = 
        (is_gpr2xcr             ) ||
        (is_cmov_t &&  cmov_cond) ||
        (is_cmov_f && !cmov_cond)  ;

// ----------------------------------------------------------------------

//
//  Bitwise Instructions
//

wire bw_bop    = is_bitwise_insn && id_subclass[SCARV_COP_SCLASS_BOP   ];
wire bw_bmv    = is_bitwise_insn && id_subclass[SCARV_COP_SCLASS_BMV   ]; 
wire bw_ins    = is_bitwise_insn && id_subclass[SCARV_COP_SCLASS_INS   ]; 
wire bw_ext    = is_bitwise_insn && id_subclass[SCARV_COP_SCLASS_EXT   ];
wire bw_ld_liu = is_bitwise_insn && id_subclass[SCARV_COP_SCLASS_LD_LIU];
wire bw_ld_hiu = is_bitwise_insn && id_subclass[SCARV_COP_SCLASS_LD_HIU];
wire bw_lut    = is_bitwise_insn && id_subclass[SCARV_COP_SCLASS_LUT   ];

// Result computation for the BOP.cr instruction
wire [31:0] bop_result;
genvar br;
generate for (br = 0; br < 32; br = br + 1)
    assign bop_result[br] = id_imm[
        {palu_rs3[br], palu_rs1[br], palu_rs2[br]}
    ];
endgenerate

// Result computation for xc.bmv instruction.


// Result computation for EXT / INS / BMV instructions
wire [ 4:0] e_start     =                         id_imm[9:5]   ;
wire [ 4:0] i_start     = bw_bmv ? id_imm[4:0]  : id_imm[9:5]   ;
wire [ 5:0] ei_len      = bw_bmv ? 1'b1         : id_imm[4:0]+1 ;

wire [31:0] ext_result  =
    (palu_rs1 >> e_start) & ~(32'hFFFF_FFFF << ei_len);

wire [31:0] ins_mask    = 32'hFFFF_FFFF >> (32-ei_len);

wire [31:0] ins_input   = bw_bmv ? ext_result : palu_rs1;

wire [31:0] ins_result  =
    ((ins_input & ins_mask) << i_start) | 
    (palu_rs3 & ~(ins_mask << i_start));

// Result computation for the LUT instruction.

wire [63:0] lut_concat = {64{bw_lut}} & {palu_rs3, palu_rs2};
wire [ 3:0] lut_lut [15:0];
wire [31:0] lut_result;
genvar s;
generate for(s = 0; s < 16; s = s+ 1) begin
    if(s < 8) begin
        assign lut_result[4*s+3:4*s] = lut_lut[palu_rs1[4*s+3 : 4*s]];
    end
    assign lut_lut[s] = lut_concat[4*s+3: 4*s];
end endgenerate

// AND/ORing the various bitwise results together.
wire [31:0] result_bitwise = 
    {32{bw_ld_liu}} & {palu_rs3[31:16], id_imm[15:0]    } |
    {32{bw_ld_hiu}} & {id_imm[15:0]   , palu_rs3[15: 0] } |
    {32{bw_bmv }} & {ins_result                       } |
    {32{bw_bop }} & {bop_result                       } |
    {32{bw_bop }} & {bop_result                       } |
    {32{bw_ext }} & {ext_result                       } |
    {32{bw_ins }} & {ins_result                       } |
    {32{bw_lut}} & {lut_result                     } ;

// ----------------------------------------------------------------------

//
//  Packed Arithmetic Instructions
//


wire is_padd    = is_parith_insn && id_subclass[SCARV_COP_SCLASS_PADD];
wire is_psub    = is_parith_insn && id_subclass[SCARV_COP_SCLASS_PSUB];
wire is_pmul_l  = is_parith_insn && id_subclass[SCARV_COP_SCLASS_PMUL_L];
wire is_pmul_h  = is_parith_insn && id_subclass[SCARV_COP_SCLASS_PMUL_H];
wire is_pclmul_l= is_parith_insn && id_subclass[SCARV_COP_SCLASS_PCLMUL_L];
wire is_pclmul_h= is_parith_insn && id_subclass[SCARV_COP_SCLASS_PCLMUL_H];
wire is_psll    = is_parith_insn && id_subclass[SCARV_COP_SCLASS_PSLL];
wire is_psrl    = is_parith_insn && id_subclass[SCARV_COP_SCLASS_PSRL];
wire is_prot    = is_parith_insn && id_subclass[SCARV_COP_SCLASS_PROT];
wire is_psll_i  = is_parith_insn && id_subclass[SCARV_COP_SCLASS_PSLL_I];
wire is_psrl_i  = is_parith_insn && id_subclass[SCARV_COP_SCLASS_PSRL_I];
wire is_prot_i  = is_parith_insn && id_subclass[SCARV_COP_SCLASS_PROT_I];

wire [31:0] result_parith;
    
wire [31:0] padd_a ;  // LHS input
wire [31:0] padd_b ;  // RHS input
wire        padd_sub; // Do subtract instead of add.
wire        padd_ci;  // Carry in
wire [31:0] padd_c ;  // Result
wire        padd_co;  // Carry out

wire        mul_start ; // Trigger to start multiplying
wire        mul_done  ; // Signal multiplication has finished.
wire        mul_hi    ; // Want high part of result
wire        mul_ncarry; // Do carryless multiplication.
wire [31:0] mul_a     ; // LHS operand
wire [31:0] mul_b     ; // RHS operand
wire [31:0] mul_result; // Result of the multiplication.
    
wire [31:0] pshf_a    ; // LHS input
wire [ 5:0] pshf_shamt; // RHS input
wire        pshf_sl   ; // shift left / n shift right
wire        pshf_r    ; // rotate / n shift
wire [31:0] pshf_c    ; // Result

assign padd_a = palu_rs1;
assign padd_b = palu_rs2;

assign mul_a       = palu_rs1;
assign mul_b       = palu_rs2;
assign mul_hi      = is_pmul_h || is_pclmul_h;
assign mul_ncarry  = is_pclmul_l || is_pclmul_h;
assign mul_start   = is_mul && is_parith_insn;

wire   shift_imm    = is_psll_i || is_psrl_i || is_prot_i;
assign pshf_a       = palu_rs1;
assign pshf_shamt   = shift_imm ? {1'b0,id_imm[4:0]  } :
                                  {1'b0,palu_rs2[4:0]} ;
assign pshf_r       = is_prot || is_prot_i;
assign pshf_sl      = is_psll || is_psll_i;

assign padd_ci      = is_psub;
assign padd_sub     = is_psub;

wire is_mul     = is_pmul_l || is_pmul_h || is_pclmul_l || is_pclmul_h ;

wire is_shift   = is_psll   || is_psrl   || is_prot     || is_psll_i   ||
                  is_psrl_i || is_prot_i ;

assign result_parith =
    {32{is_mul  }} & mul_result   |
    {32{is_padd }} & padd_c       |
    {32{is_psub }} & padd_c       |
    {32{is_shift}} & pshf_c       ;


scarv_cop_palu_adder i_palu_adder(
.a  (padd_a ),  // LHS input
.b  (padd_b ),  // RHS input
.pw (id_pw  ),  // Current operation pack width
.sub(padd_sub), // Do subtract instead of add.
.ci (padd_ci),  // Carry in
.c  (padd_c ),  // Result
.co (padd_co)   // Carry out
);

scarv_cop_palu_shifter i_palu_shifter (
.a    (pshf_a    ), // LHS input
.shamt(pshf_shamt), // RHS input
.pw   (id_pw     ), // Current operation pack width
.sl   (pshf_sl   ), // shift left / n shift right
.r    (pshf_r    ), // rotate / n shift
.c    (pshf_c    )  // Result
);

scarv_cop_palu_multiplier i_palu_multiplier (
.g_clk   (g_clk     ), // Global clock.
.g_resetn(g_resetn  ), // Global synchronous active low reset
.start   (mul_start ), // Trigger to start multiplying
.done    (mul_done  ), // Signal multiplication has finished.
.a       (mul_a     ), // LHS operand
.b       (mul_b     ), // RHS operand
.pw      (id_pw     ), // Pack width.
.high    (mul_hi    ),
.ncarry  (mul_ncarry),
.result  (mul_result)  // Result of the multiplication.
);

endmodule
