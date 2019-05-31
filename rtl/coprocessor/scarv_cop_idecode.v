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
// module: scarv_cop_idecode
//
//  A fully combinatorial instruction decoder for the ISE.
//
module scarv_cop_idecode (

input  wire [31:0] id_encoded      , // Encoding 32-bit instruction

output wire        id_exception    , // Illegal instruction exception.

output wire [ 8:0] id_class        , // Instruction class.
output wire [15:0] id_subclass     , // Instruction subclass.
output wire        id_cprs_init    , // An init instruction is executing.

output wire [ 2:0] id_pw           , // Instruction pack width.
output wire [ 3:0] id_crs1         , // Instruction source register 1
output wire [ 3:0] id_crs2         , // Instruction source register 2
output wire [ 3:0] id_crs3         , // Instruction source register 3
output wire [ 3:0] id_crd          , // Instruction destination register
output wire [ 3:0] id_crd1         , // MP Instruction destination register 1
output wire [ 3:0] id_crd2         , // MP Instruction destination register 2
output wire [ 4:0] id_rd           , // GPR destination register
output wire [ 4:0] id_rs1          , // GPR source register
output wire [31:0] id_imm          , // Decoded immediate.
output wire        id_wb_h         , // Halfword index (load/store)
output wire        id_wb_b           // Byte index (load/store)

);

//
// Expected to be in same directory as this file.
wire [31:0] encoded = id_encoded;
`include "scarv_cop_common.vh"

parameter ISE_MCCR_R    = 1; // Feature enable bits.
parameter ISE_MCCR_MP   = 1; // 
parameter ISE_MCCR_SG   = 1; // 
parameter ISE_MCCR_P32  = 1; // 
parameter ISE_MCCR_P16  = 1; // 
parameter ISE_MCCR_P8   = 1; // 
parameter ISE_MCCR_P4   = 1; // 
parameter ISE_MCCR_P2   = 1; // 

//
// Include the generated decoder. Exposes two classes of signal:
//  - dec_* for each instruction
//  - dec_arg_* for each possible instruction argument field.
//
//  This file is expected to be found in the $XC_WORK directory.
//
`include "ise_decode.v"

// Put CRD register address in CRS2 address. Makes downstream logic
// easier for write data selection.
wire   crd_in_crs2 = dec_str_w || dec_str_h || dec_str_b;

assign id_crs1 = dec_arg_crs1;
assign id_crs2 = crd_in_crs2 ? dec_arg_crd : dec_arg_crs2;

wire   crd_in_crs3 = dec_ins || dec_bmv || dec_pbit || dec_ipbit ||
                     dec_ld_liu  || dec_ld_hiu  || dec_ld_bu ||
                     dec_ld_hu  || dec_scatter_b || dec_scatter_h ||
                     dec_bop;

assign id_crs3 = crd_in_crs3 ? dec_arg_crd : dec_arg_crs3;

assign id_crd  = dec_arg_crd ;
assign id_rs1  = dec_arg_rs1;
assign id_crd1 = {dec_arg_crdm, 1'b0};
assign id_crd2 = {dec_arg_crdm, 1'b1};
assign id_rd   = dec_arg_rd;
assign id_pw   = dec_arg_pw;

// Badly specified indexed load/store sub-word operation
// where source/dest halfword or byte is invalid.
wire bad_index_ldst = 
    (dec_arg_b0 == 2'd1 || dec_arg_b0 == 2'd3) && (dec_ldr_hu || dec_str_h);

wire bad_pack_width = 
    id_pw != SCARV_COP_PW_1          &&
    id_pw != SCARV_COP_PW_2          &&
    id_pw != SCARV_COP_PW_4          &&
    id_pw != SCARV_COP_PW_8          &&
    id_pw != SCARV_COP_PW_16         &&
    id_class[SCARV_COP_ICLASS_PACKED_ARITH];

assign id_exception = 
    dec_invalid_opcode || 
    bad_index_ldst     ||
    bad_pack_width      ; // FIXME: Add feature switches to this expression.


//
// Which class of instruction have we decoded?
wire class_packed_arith = 
    dec_padd  || dec_psub  || dec_pmul_l || dec_psll   || 
    dec_psrl  || dec_prot  || dec_psll_i || dec_psrl_i || 
    dec_prot_i|| dec_pmul_h|| dec_pclmul_l|| dec_pclmul_h;

wire class_permute = dec_pbit || dec_ipbit || dec_pbyte;

wire class_loadstore    = 
    dec_scatter_b || dec_gather_b  || dec_scatter_h || dec_gather_h  ||
    dec_ld_bu    || dec_ld_hu      || dec_ld_w      || dec_st_b      ||
    dec_st_h     || dec_st_w       || dec_ldr_w     || dec_ldr_hu    ||
    dec_ldr_bu   || dec_str_w      || dec_str_h     || dec_str_b     ;

wire class_random       = 
    dec_rngseed || dec_rngsamp || dec_rngtest;

wire class_move         = 
    dec_xcr2gpr   || dec_gpr2xcr   || dec_cmov_t ||  dec_cmov_f ;

wire class_mp           = 
    dec_mequ   || dec_mlte   || dec_mgte     || dec_madd_3 || 
    dec_madd_2 || dec_msub_3 || dec_msub_2   || dec_msll_i || 
    dec_msll   || dec_msrl_i || dec_msrl     || dec_macc_2 || 
    dec_macc_1 || dec_mmul_3 || dec_mclmul_3  ;

wire class_bitwise      = 
    dec_bop   || dec_ins    || dec_bmv    ||
    dec_ext   || dec_ld_liu || dec_ld_hiu || dec_lut  ;

wire class_aes          =
    dec_aessub_enc || dec_aessub_encrot || dec_aessub_dec || 
    dec_aessub_decrot || dec_aesmix_enc || dec_aesmix_dec;

wire class_sha3         =
    dec_sha3_xy || dec_sha3_x1 || dec_sha3_x2 || dec_sha3_x4 || dec_sha3_yx;

assign id_class[SCARV_COP_ICLASS_SHA3        ] = class_sha3         ;
assign id_class[SCARV_COP_ICLASS_AES         ] = class_aes          ;
assign id_class[SCARV_COP_ICLASS_PACKED_ARITH] = class_packed_arith ;
assign id_class[SCARV_COP_ICLASS_PERMUTE     ] = class_permute      ;
assign id_class[SCARV_COP_ICLASS_LOADSTORE   ] = class_loadstore    ;
assign id_class[SCARV_COP_ICLASS_RANDOM      ] = class_random       ;
assign id_class[SCARV_COP_ICLASS_MOVE        ] = class_move         ;
assign id_class[SCARV_COP_ICLASS_MP          ] = class_mp           ;
assign id_class[SCARV_COP_ICLASS_BITWISE     ] = class_bitwise      ;


//
// Subclass fields for different instruction classes.
wire [15:0] subclass_load_store;
assign subclass_load_store[SCARV_COP_SCLASS_SCATTER_B] = dec_scatter_b;
assign subclass_load_store[SCARV_COP_SCLASS_GATHER_B ] = dec_gather_b ;
assign subclass_load_store[SCARV_COP_SCLASS_SCATTER_H] = dec_scatter_h;
assign subclass_load_store[SCARV_COP_SCLASS_GATHER_H ] = dec_gather_h ;
assign subclass_load_store[SCARV_COP_SCLASS_ST_W     ] = dec_st_w    ;
assign subclass_load_store[SCARV_COP_SCLASS_LD_W     ] = dec_ld_w    ;
assign subclass_load_store[SCARV_COP_SCLASS_ST_H     ] = dec_st_h    ;
assign subclass_load_store[SCARV_COP_SCLASS_LH_CR    ] = dec_ld_hu   ;
assign subclass_load_store[SCARV_COP_SCLASS_ST_B     ] = dec_st_b    ;
assign subclass_load_store[SCARV_COP_SCLASS_LB_CR    ] = dec_ld_bu   ;
assign subclass_load_store[SCARV_COP_SCLASS_LDR_W    ] = dec_ldr_w   ;
assign subclass_load_store[SCARV_COP_SCLASS_LDR_H    ] = dec_ldr_hu  ;
assign subclass_load_store[SCARV_COP_SCLASS_LDR_B    ] = dec_ldr_bu  ;
assign subclass_load_store[SCARV_COP_SCLASS_STR_W    ] = dec_str_w   ;
assign subclass_load_store[SCARV_COP_SCLASS_STR_H    ] = dec_str_h   ;
assign subclass_load_store[SCARV_COP_SCLASS_STR_B    ] = dec_str_b   ;

wire [15:0] subclass_mp;
assign subclass_mp[SCARV_COP_SCLASS_MEQU    ] = dec_mequ ;
assign subclass_mp[SCARV_COP_SCLASS_MLTE    ] = dec_mlte ;
assign subclass_mp[SCARV_COP_SCLASS_MGTE    ] = dec_mgte ;
assign subclass_mp[SCARV_COP_SCLASS_MADD_3  ] = dec_madd_3;
assign subclass_mp[SCARV_COP_SCLASS_MADD_2  ] = dec_madd_2;
assign subclass_mp[SCARV_COP_SCLASS_MSUB_3  ] = dec_msub_3;
assign subclass_mp[SCARV_COP_SCLASS_MSUB_2  ] = dec_msub_2;
assign subclass_mp[SCARV_COP_SCLASS_MSLL_I  ] = dec_msll_i;
assign subclass_mp[SCARV_COP_SCLASS_MSLL    ] = dec_msll ;
assign subclass_mp[SCARV_COP_SCLASS_MSRL_I  ] = dec_msrl_i;
assign subclass_mp[SCARV_COP_SCLASS_MSRL    ] = dec_msrl ;
assign subclass_mp[SCARV_COP_SCLASS_MACC_2  ] = dec_macc_2;
assign subclass_mp[SCARV_COP_SCLASS_MACC_1  ] = dec_macc_1;
assign subclass_mp[SCARV_COP_SCLASS_MMUL_3  ] = dec_mmul_3 ;
assign subclass_mp[SCARV_COP_SCLASS_MCLMUL_3] = dec_mclmul_3;
assign subclass_mp[                   15    ] = 0;

wire [15:0] subclass_bitwise;
assign subclass_bitwise[SCARV_COP_SCLASS_BOP   ] = dec_bop ;
assign subclass_bitwise[SCARV_COP_SCLASS_BMV   ] = dec_bmv ;
assign subclass_bitwise[SCARV_COP_SCLASS_INS   ] = dec_ins ;
assign subclass_bitwise[SCARV_COP_SCLASS_EXT   ] = dec_ext ;
assign subclass_bitwise[SCARV_COP_SCLASS_LD_LIU] = dec_ld_liu ;
assign subclass_bitwise[SCARV_COP_SCLASS_LD_HIU] = dec_ld_hiu ;
assign subclass_bitwise[SCARV_COP_SCLASS_LUT   ] = dec_lut;
assign subclass_bitwise[                  15:7 ] = 0;

wire [15:0] subclass_permute;
assign subclass_permute[SCARV_COP_SCLASS_PERM_BIT ] = dec_pbit ;
assign subclass_permute[SCARV_COP_SCLASS_PERM_IBIT] = dec_ipbit;
assign subclass_permute[SCARV_COP_SCLASS_PERM_BYTE] = dec_pbyte;
assign subclass_permute[                     15:3 ] = 0;

wire [15:0] subclass_aes;
assign subclass_aes[SCARV_COP_SCLASS_AESSUB_ENC   ] = dec_aessub_enc   ;
assign subclass_aes[SCARV_COP_SCLASS_AESSUB_ENCROT] = dec_aessub_encrot;
assign subclass_aes[SCARV_COP_SCLASS_AESSUB_DEC   ] = dec_aessub_dec   ;
assign subclass_aes[SCARV_COP_SCLASS_AESSUB_DECROT] = dec_aessub_decrot;
assign subclass_aes[SCARV_COP_SCLASS_AESMIX_ENC   ] = dec_aesmix_enc   ;
assign subclass_aes[SCARV_COP_SCLASS_AESMIX_DEC   ] = dec_aesmix_dec   ;
assign subclass_aes[                         15:6 ] = 0;

wire [15:0] subclass_sha3;
assign subclass_sha3[SCARV_COP_SCLASS_SHA3_XY] = dec_sha3_xy;
assign subclass_sha3[SCARV_COP_SCLASS_SHA3_X1] = dec_sha3_x1;
assign subclass_sha3[SCARV_COP_SCLASS_SHA3_X2] = dec_sha3_x2;
assign subclass_sha3[SCARV_COP_SCLASS_SHA3_X4] = dec_sha3_x4;
assign subclass_sha3[SCARV_COP_SCLASS_SHA3_YX] = dec_sha3_yx;
assign subclass_sha3[                   15:5 ] = 0;

wire [15:0] subclass_palu;
assign subclass_palu[SCARV_COP_SCLASS_PADD    ] = dec_padd    ;
assign subclass_palu[SCARV_COP_SCLASS_PSUB    ] = dec_psub    ;
assign subclass_palu[SCARV_COP_SCLASS_PMUL_L  ] = dec_pmul_l  ;
assign subclass_palu[SCARV_COP_SCLASS_PMUL_H  ] = dec_pmul_h  ;
assign subclass_palu[SCARV_COP_SCLASS_PCLMUL_L] = dec_pclmul_l;
assign subclass_palu[SCARV_COP_SCLASS_PCLMUL_H] = dec_pclmul_h;
assign subclass_palu[SCARV_COP_SCLASS_PSLL    ] = dec_psll    ;
assign subclass_palu[SCARV_COP_SCLASS_PSRL    ] = dec_psrl    ;
assign subclass_palu[SCARV_COP_SCLASS_PROT    ] = dec_prot    ;
assign subclass_palu[SCARV_COP_SCLASS_PSLL_I  ] = dec_psll_i  ;
assign subclass_palu[SCARV_COP_SCLASS_PSRL_I  ] = dec_psrl_i  ;
assign subclass_palu[SCARV_COP_SCLASS_PROT_I  ] = dec_prot_i  ;
assign subclass_palu[                    15:12] = 0;

wire [15:0] subclass_move;
assign subclass_move[SCARV_COP_SCLASS_CMOV_T ] = dec_cmov_t ;
assign subclass_move[SCARV_COP_SCLASS_CMOV_F ] = dec_cmov_f ;
assign subclass_move[SCARV_COP_SCLASS_GPR2XCR] = dec_gpr2xcr;
assign subclass_move[SCARV_COP_SCLASS_XCR2GPR] = dec_xcr2gpr;
assign subclass_move[                    15:4] = 0;

wire [15:0] subclass_random;
assign subclass_random[SCARV_COP_SCLASS_RSEED] = dec_rngseed;
assign subclass_random[SCARV_COP_SCLASS_RSAMP] = dec_rngsamp;
assign subclass_random[SCARV_COP_SCLASS_RTEST] = dec_rngtest;
assign subclass_random[                  15:3] = 0;

//
// Identify individual instructions within a class using the subclass
// field.
assign id_subclass = 
    subclass_sha3       |
    subclass_aes        |
    subclass_palu       |
    subclass_permute    |
    subclass_load_store |
    subclass_random     |
    subclass_move       |
    subclass_mp         |
    subclass_bitwise    ;

// Initialise registers back to zero.
assign id_cprs_init = dec_init;

//
// Immediate decoding
wire imm_ld     = dec_ld_w     || dec_ld_hu   || dec_ld_bu;
wire imm_st     = dec_st_w     || dec_st_h    || dec_st_b;
wire imm_li     = dec_ld_hiu   || dec_ld_liu;
wire imm_8      = class_sha3   || dec_bop;
wire imm_10     = dec_ext      || dec_ins     || dec_bmv || dec_pbit ||
                  dec_ipbit    || dec_pbyte;
wire imm_sh_px  = dec_psll_i   || dec_psrl_i  || dec_prot_i;
wire imm_sh_mp  = dec_msll_i   || dec_msrl_i;

assign id_imm = 
    {32{imm_ld      }} & {{21{encoded[31]}}, encoded[31:21]               } |
    {32{imm_st      }} & {{21{encoded[31]}}, encoded[31:25],encoded[10:7] } |
    {32{imm_li      }} & {16'b0, encoded[31:21],encoded[19:15]            } |
    {32{imm_8       }} & {24'b0, encoded[31:24]                           } |
    {32{imm_10      }} & {22'b0, encoded[31:22]                           } |
    {32{imm_sh_px   }} & {27'b0, dec_arg_cshamt                           } |
    {32{imm_sh_mp   }} & {26'b0, dec_arg_cmshamt                          } ;

wire indexed_ldst = dec_ldr_w  || dec_ldr_hu || dec_ldr_bu || 
                    dec_str_w  || dec_str_h  || dec_str_b  ;

assign id_wb_h = indexed_ldst ? dec_arg_b0[1] : dec_arg_cc ;

assign id_wb_b = indexed_ldst ? dec_arg_b0[0] :
                 imm_ld       ? dec_arg_cd    :
                                dec_arg_ca    ;

endmodule
