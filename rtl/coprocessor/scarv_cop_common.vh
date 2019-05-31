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

localparam SCARV_COP_INSN_SUCCESS =  3'b000;
localparam SCARV_COP_INSN_ABORT   =  3'b001;
localparam SCARV_COP_INSN_BAD_INS =  3'b010;
localparam SCARV_COP_INSN_BAD_LAD =  3'b100;
localparam SCARV_COP_INSN_BAD_SAD =  3'b101;
localparam SCARV_COP_INSN_LD_ERR  =  3'b110;
localparam SCARV_COP_INSN_ST_ERR  =  3'b111;

localparam SCARV_COP_ICLASS_PACKED_ARITH = 4'd0;
localparam SCARV_COP_ICLASS_PERMUTE      = 4'd1;
localparam SCARV_COP_ICLASS_LOADSTORE    = 4'd2;
localparam SCARV_COP_ICLASS_RANDOM       = 4'd3;
localparam SCARV_COP_ICLASS_MOVE         = 4'd4;
localparam SCARV_COP_ICLASS_MP           = 4'd5;
localparam SCARV_COP_ICLASS_BITWISE      = 4'd6;
localparam SCARV_COP_ICLASS_AES          = 4'd7;
localparam SCARV_COP_ICLASS_SHA3         = 4'd8;

localparam SCARV_COP_SCLASS_SHA3_XY   = 4'd0;
localparam SCARV_COP_SCLASS_SHA3_X1   = 4'd1;
localparam SCARV_COP_SCLASS_SHA3_X2   = 4'd2;
localparam SCARV_COP_SCLASS_SHA3_X4   = 4'd3;
localparam SCARV_COP_SCLASS_SHA3_YX   = 4'd4;
    
localparam SCARV_COP_SCLASS_CMOV_T    = 4'd0;
localparam SCARV_COP_SCLASS_CMOV_F    = 4'd1;
localparam SCARV_COP_SCLASS_GPR2XCR   = 4'd2;
localparam SCARV_COP_SCLASS_XCR2GPR   = 4'd3;

localparam SCARV_COP_SCLASS_PERM_BIT    = 4'd0;
localparam SCARV_COP_SCLASS_PERM_IBIT   = 4'd1;
localparam SCARV_COP_SCLASS_PERM_BYTE   = 4'd2;
    
localparam SCARV_COP_SCLASS_SCATTER_B = 4'd0 ;
localparam SCARV_COP_SCLASS_GATHER_B  = 4'd1 ;
localparam SCARV_COP_SCLASS_SCATTER_H = 4'd2 ;
localparam SCARV_COP_SCLASS_GATHER_H  = 4'd3 ;
localparam SCARV_COP_SCLASS_ST_W      = 4'd4 ;
localparam SCARV_COP_SCLASS_LD_W      = 4'd5 ;
localparam SCARV_COP_SCLASS_ST_H      = 4'd6 ;
localparam SCARV_COP_SCLASS_LH_CR     = 4'd7 ;
localparam SCARV_COP_SCLASS_ST_B      = 4'd8 ;
localparam SCARV_COP_SCLASS_LB_CR     = 4'd9 ;
localparam SCARV_COP_SCLASS_LDR_W     = 4'd10;
localparam SCARV_COP_SCLASS_LDR_H     = 4'd11;
localparam SCARV_COP_SCLASS_LDR_B     = 4'd12;
localparam SCARV_COP_SCLASS_STR_W     = 4'd13;
localparam SCARV_COP_SCLASS_STR_H     = 4'd14;
localparam SCARV_COP_SCLASS_STR_B     = 4'd15;
    
localparam SCARV_COP_SCLASS_BMV       = 4'd0;
localparam SCARV_COP_SCLASS_BOP       = 4'd1;
localparam SCARV_COP_SCLASS_INS       = 4'd2; 
localparam SCARV_COP_SCLASS_EXT       = 4'd3;
localparam SCARV_COP_SCLASS_LD_LIU    = 4'd4;
localparam SCARV_COP_SCLASS_LD_HIU    = 4'd5;
localparam SCARV_COP_SCLASS_LUT       = 4'd6;

localparam SCARV_COP_SCLASS_PADD      = 4'd0;
localparam SCARV_COP_SCLASS_PSUB      = 4'd1;
localparam SCARV_COP_SCLASS_PMUL_L    = 4'd2;
localparam SCARV_COP_SCLASS_PMUL_H    = 4'd3;
localparam SCARV_COP_SCLASS_PCLMUL_L  = 4'd4;
localparam SCARV_COP_SCLASS_PCLMUL_H  = 4'd5;
localparam SCARV_COP_SCLASS_PSLL      = 4'd6;
localparam SCARV_COP_SCLASS_PSRL      = 4'd7;
localparam SCARV_COP_SCLASS_PROT      = 4'd8;
localparam SCARV_COP_SCLASS_PSLL_I    = 4'd9;
localparam SCARV_COP_SCLASS_PSRL_I    = 4'd10;
localparam SCARV_COP_SCLASS_PROT_I    = 4'd11;

localparam SCARV_COP_SCLASS_MEQU      = 4'd0 ;
localparam SCARV_COP_SCLASS_MLTE      = 4'd1 ;
localparam SCARV_COP_SCLASS_MGTE      = 4'd2 ;
localparam SCARV_COP_SCLASS_MADD_3    = 4'd3 ;
localparam SCARV_COP_SCLASS_MADD_2    = 4'd4 ;
localparam SCARV_COP_SCLASS_MSUB_3    = 4'd5 ;
localparam SCARV_COP_SCLASS_MSUB_2    = 4'd6 ;
localparam SCARV_COP_SCLASS_MSLL_I    = 4'd7 ;
localparam SCARV_COP_SCLASS_MSLL      = 4'd8 ;
localparam SCARV_COP_SCLASS_MSRL_I    = 4'd9 ;
localparam SCARV_COP_SCLASS_MSRL      = 4'd10;
localparam SCARV_COP_SCLASS_MACC_2    = 4'd11;
localparam SCARV_COP_SCLASS_MACC_1    = 4'd12;
localparam SCARV_COP_SCLASS_MMUL_3    = 4'd13;
localparam SCARV_COP_SCLASS_MCLMUL_3  = 4'd14;

localparam SCARV_COP_SCLASS_RSEED     = 4'd0;
localparam SCARV_COP_SCLASS_RSAMP     = 4'd1;
localparam SCARV_COP_SCLASS_RTEST     = 4'd2;

localparam SCARV_COP_SCLASS_AESSUB_ENC    = 4'd0;
localparam SCARV_COP_SCLASS_AESSUB_ENCROT = 4'd1;
localparam SCARV_COP_SCLASS_AESSUB_DEC    = 4'd2;
localparam SCARV_COP_SCLASS_AESSUB_DECROT = 4'd3;
localparam SCARV_COP_SCLASS_AESMIX_ENC    = 4'd4;
localparam SCARV_COP_SCLASS_AESMIX_DEC    = 4'd5;

localparam SCARV_COP_RNG_TYPE_LFSR32= 0;

localparam SCARV_COP_PW_1           = 3'b101;
localparam SCARV_COP_PW_2           = 3'b100;
localparam SCARV_COP_PW_4           = 3'b011;
localparam SCARV_COP_PW_8           = 3'b010;
localparam SCARV_COP_PW_16          = 3'b001;
