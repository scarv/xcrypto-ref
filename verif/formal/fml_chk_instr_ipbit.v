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

`VTX_CHECKER_MODULE_BEGIN(instr_ipbit)

wire [31:0] perm_in    = `CRD ;
wire [31:0] perm_msk   = `CRS1;

reg  [31:0] perm_result;
reg  [31:0] t1;
reg  [31:0] t2;

integer i;
integer j;
integer k;
integer jp;

always @(*) begin

    t1 = perm_in;
    t2 = perm_in;;

    for(i = 0; i < 5; i = i + 1) begin
        
        if(dec_arg_cs[i]) begin
    
            for(j = 0; j < 32; j = j + 1) begin

                k = 4-i;

                jp = ((j+2**k)%2**(k+1)) + (j/(2**(k+1)) * (2**(k+1)));

                t2[j] = perm_msk[j] ? t1[j] : t1[jp];

            end

            t1 = t2;

        end

    end

    perm_result = t2;

end

//
// ipbit
//
`VTX_CHECK_INSTR_BEGIN(ipbit) 

    `VTX_ASSERT_CRD_VALUE_IS(perm_result)

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(ipbit)

`VTX_CHECKER_MODULE_END

