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
// module: scarv_cop_permute
//
//  This module implements the permutation instructions:
//  - xc.pbit, xc.ipbit, xc.pbyte
//
module scarv_cop_permute (

input  wire         perm_ivalid      , // Valid instruction input
output wire         perm_idone       , // Instruction complete

input  wire [31:0]  perm_rs1         , // Source register 1
input  wire [31:0]  perm_rs3         , // Source register 3 / rd

input  wire [31:0]  id_imm           , // Source immedate
input  wire [15:0]  id_subclass      , // Instruction subclass

output wire [ 3:0]  perm_cpr_rd_ben  , // Writeback byte enable
output wire [31:0]  perm_cpr_rd_wdata  // Writeback data

);

// Commom field name and values.
`include "scarv_cop_common.vh"

wire [31:0] p_fwd_out;
wire [31:0] p_rev_out;

wire is_pbit    = perm_ivalid && id_subclass[SCARV_COP_SCLASS_PERM_BIT];
wire is_ipbit   = perm_ivalid && id_subclass[SCARV_COP_SCLASS_PERM_IBIT];
wire is_pbyte   = perm_ivalid && id_subclass[SCARV_COP_SCLASS_PERM_BYTE];

assign perm_idone      = perm_ivalid;

assign perm_cpr_rd_ben = {4{perm_ivalid}};

assign perm_cpr_rd_wdata =
    {32{is_pbit || is_ipbit}} & p_fwd_out    |
    {32{is_pbyte           }} & pbytes_result;

// Mask layer inputs to prevent undue toggling.
wire [31:0] p_input = perm_rs3 & {32{perm_ivalid}};
wire [31:0] p_mask  = perm_rs1;

// Layer activation bits from instruction immediate.
wire [ 4:0] cs = id_imm[9:5];

//
// Byte permutation
//

wire [1:0] b0   = id_imm[9:8];
wire [1:0] b1   = id_imm[7:6];
wire [1:0] b2   = id_imm[5:4];
wire [1:0] b3   = id_imm[3:2];

wire [7:0] bytes [3:0];

assign bytes[0] = perm_rs1[ 7: 0];
assign bytes[1] = perm_rs1[15: 8];
assign bytes[2] = perm_rs1[23:16];
assign bytes[3] = perm_rs1[31:24];

wire [31:0] pbytes_result =  {
    bytes[b3],
    bytes[b2],
    bytes[b1],
    bytes[b0]
};

//
// Bit Permutation network
//

wire[31:0] fwd [4:0];
    
assign p_fwd_out = fwd[4];

genvar i;
genvar j;

generate for(i = 0; i < 5; i = i + 1) begin
    
    wire [31:0] prev_layer;

    if(i == 0) begin
        assign prev_layer = p_input ;
    end else begin
        assign prev_layer = fwd[i-1];
    end

    for(j = 0; j < 32; j = j + 1) begin
        integer alt_j   = ((j+2**i)%2**(i+1)) + (j/(2**(i+1)) * 2**(i+1));
        integer alt_j_i = ((j+2**(4-i))%2**((4-i)+1)) + (j/(2**((4-i)+1)) * 2**((4-i)+1));

        wire alt_bit = is_pbit ? prev_layer[alt_j] : prev_layer[alt_j_i];
        
        assign fwd[i][j] =
            !cs[i]    ? prev_layer[j]   :
            p_mask[j] ? prev_layer[j]   :
                        alt_bit         ;

    end


end endgenerate


//
// Reverse permutation network
//

endmodule
