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
// module: p_addsub
//
//  Implemented packed addition/subtraction for 32-bit 2s complemente values.
//
module p_addsub (

input  wire [31:0]  lhs             , // Left hand input
input  wire [31:0]  rhs             , // Right hand input.

input  wire [ 4:0]  pw              , // Pack width to operate on
input  wire [ 0:0]  sub             , // Subtract if set, else add.

output wire [31:0]  c_out           , // Carry bits
output wire [31:0]  result            // Result of the operation

);

//
// One-hot pack width wires
wire pw_32 = pw[0];
wire pw_16 = pw[1];
wire pw_8  = pw[2];
wire pw_4  = pw[3];
wire pw_2  = pw[4];

// Carry bit masks
(*keep*)
wire [31:0] carry_mask;
wire [32:0] carry_chain;

// Carry in IFF subtracting.
assign      carry_chain[0] = sub;

// Invert RHS iff subtracting.
wire [31:0] rhs_m          = sub ? ~rhs : rhs;

//
// Generate the carry mask bits.
assign carry_mask[ 0] = 1'b1;
assign carry_mask[ 1] = !pw_2;
assign carry_mask[ 2] = 1'b1;
assign carry_mask[ 3] = !pw_2 && !pw_4;
assign carry_mask[ 4] = 1'b1;
assign carry_mask[ 5] = !pw_2;
assign carry_mask[ 6] = 1'b1;
assign carry_mask[ 7] = !pw_2 && !pw_4 && !pw_8;
assign carry_mask[ 8] = 1'b1;
assign carry_mask[ 9] = !pw_2;
assign carry_mask[10] = 1'b1;
assign carry_mask[11] = !pw_2 && !pw_4;
assign carry_mask[12] = 1'b1;
assign carry_mask[13] = !pw_2;
assign carry_mask[14] = 1'b1;
assign carry_mask[15] = !pw_2 && !pw_4 && !pw_8 && !pw_16;
assign carry_mask[16] = 1'b1;
assign carry_mask[17] = !pw_2;
assign carry_mask[18] = 1'b1;
assign carry_mask[19] = !pw_2 && !pw_4;
assign carry_mask[20] = 1'b1;
assign carry_mask[21] = !pw_2;
assign carry_mask[22] = 1'b1;
assign carry_mask[23] = !pw_2 && !pw_4 && !pw_8;
assign carry_mask[24] = 1'b1;
assign carry_mask[25] = !pw_2;
assign carry_mask[26] = 1'b1;
assign carry_mask[27] = !pw_2 && !pw_4;
assign carry_mask[28] = 1'b1;
assign carry_mask[29] = !pw_2;
assign carry_mask[30] = 1'b1;
assign carry_mask[31] = !pw_2 && !pw_4 && !pw_8 && !pw_16;

//
// Generate full adders, where carry in for each one is masked by
// the corresponding carry mask bit.
genvar i;
generate for(i = 0; i < 32; i = i + 1) begin

    wire   c_in     = carry_chain[i];
    assign c_out[i] = (lhs[i] && rhs_m[i]) || (c_in && (lhs[i]^rhs_m[i]));
    
    wire   force_carry = sub && (
        (i == 15 && pw_16) ||  
        (i ==  7 && pw_8 ) ||
        (i == 15 && pw_8 ) ||
        (i == 23 && pw_8 ) ||
        (i ==  3 && pw_4 ) ||
        (i ==  7 && pw_4 ) ||
        (i == 11 && pw_4 ) ||
        (i == 15 && pw_4 ) ||
        (i == 19 && pw_4 ) ||
        (i == 23 && pw_4 ) ||
        (i == 27 && pw_4 ) ||
        (i ==  1 && pw_2 ) ||
        (i ==  3 && pw_2 ) ||
        (i ==  5 && pw_2 ) ||
        (i ==  7 && pw_2 ) ||
        (i ==  9 && pw_2 ) ||
        (i == 11 && pw_2 ) ||
        (i == 13 && pw_2 ) ||
        (i == 15 && pw_2 ) ||
        (i == 17 && pw_2 ) ||
        (i == 19 && pw_2 ) ||
        (i == 21 && pw_2 ) ||
        (i == 23 && pw_2 ) ||
        (i == 25 && pw_2 ) ||
        (i == 27 && pw_2 ) ||
        (i == 29 && pw_2 ) );

    assign carry_chain[i+1] = (c_out[i] && carry_mask[i]) || force_carry;

    assign result[i] = lhs[i] ^ rhs_m[i] ^ c_in;

end endgenerate

endmodule
