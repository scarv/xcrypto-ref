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

`VTX_CHECKER_MODULE_BEGIN(instr_pbit)

wire [31:0] perm_in    = `CRD ;
wire [31:0] perm_msk   = `CRS1;

reg  [31:0] perm_result;
reg  [31:0] t1;
reg  [31:0] t2;

integer i;
integer j;
integer jp;

always @(*) begin

    t1 = perm_in;
    t2 = perm_in;;

    for(i = 0; i < 5; i = i + 1) begin
        
        if(dec_arg_cs[i]) begin
    
            for(j = 0; j < 32; j = j + 1) begin

                jp = ((j+2**i)%2**(i+1)) + (j/(2**(i+1)) * (2**(i+1)));

                t2[j] = perm_msk[j] ? t1[j] : t1[jp];

            end

            t1 = t2;

        end

    end

    perm_result = t2;

end

//
// pbit
//
`VTX_CHECK_INSTR_BEGIN(pbit) 

    if(`CRD== 32'hFFFF0000) begin
        if(`CRS1 == 32'hFFFF0000) begin
            if(dec_arg_cs == 5'b10000) begin
                `VTX_ASSERT_CRD_VALUE_IS(32'hFFFF_FFFF)
            end
        end
    end

    `VTX_ASSERT_CRD_VALUE_IS(perm_result)

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(pbit)

`VTX_CHECKER_MODULE_END
