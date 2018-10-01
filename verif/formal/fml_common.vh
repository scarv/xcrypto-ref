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
// file: fml_common.vh
//
//  Contains various commonly used macros for the formal environment.
//

`define VTX_CLK_NAME vtx_clk

// Start a checker block
`define VTX_CHECK_BEGIN(NAME) always @(posedge `VTX_CLK_NAME) \
    if(vtx_valid) begin : NAME

// End a checker block
`define VTX_CHECK_END(NAME) end

// Start an instruction checker block.
`define VTX_CHECK_INSTR_BEGIN(NAME) always @(posedge `VTX_CLK_NAME) \
    if(vtx_valid && dec_``NAME) begin : check_instr_``NAME

`define VTX_CHECK_INSTR_END(NAME) end

// -------------------------------------------------------------------

`define VTX_ASSERT_RESULT_IS(RESULT) \
    assert(vtx_instr_result == RESULT);

`define VTX_ASSERT_WEN_IS(VAL) \
    assert(vtx_instr_wen    == VAL);

`define VTX_ASSERT_WEN_IS_CLEAR `VTX_ASSERT_WEN_IS(1'b0)
`define VTX_ASSERT_WEN_IS_SET   `VTX_ASSERT_WEN_IS(1'b1)

`define VTX_ASSERT_WDATA_IS(VAL) \
    assert(vtx_instr_wdata == VAL);

`define VTX_ASSERT_WADDR_IS(VAL) \
    assert(vtx_instr_waddr == VAL);

`define VTX_ASSERT_CRD_VALUE_IS(VAL) \
    assert(vtx_cprs_post[dec_arg_crd] == VAL);

// -------------------------------------------------------------------

// Name of arrays to registers ports.
`define VTX_REGISTER_PORT_NAME(NAME,IDX) _``IDX``_``NAME``

`define VTX_REGISTER_PORTS_CON(PORT,CONN) \
    .`VTX_REGISTER_PORT_NAME(PORT, 0 )(``CONN[0 ]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 1 )(``CONN[1 ]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 2 )(``CONN[2 ]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 3 )(``CONN[3 ]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 4 )(``CONN[4 ]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 5 )(``CONN[5 ]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 6 )(``CONN[6 ]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 7 )(``CONN[7 ]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 8 )(``CONN[8 ]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 9 )(``CONN[9 ]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 10)(``CONN[10]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 11)(``CONN[11]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 12)(``CONN[12]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 13)(``CONN[13]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 14)(``CONN[14]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 15)(``CONN[15]),  \

`define VTX_REGISTER_PORTS_RAISE(PORT) \
    .`VTX_REGISTER_PORT_NAME(PORT, 0 )(`VTX_REGISTER_PORT_NAME(PORT, 0 )),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 1 )(`VTX_REGISTER_PORT_NAME(PORT, 1 )),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 2 )(`VTX_REGISTER_PORT_NAME(PORT, 2 )),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 3 )(`VTX_REGISTER_PORT_NAME(PORT, 3 )),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 4 )(`VTX_REGISTER_PORT_NAME(PORT, 4 )),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 5 )(`VTX_REGISTER_PORT_NAME(PORT, 5 )),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 6 )(`VTX_REGISTER_PORT_NAME(PORT, 6 )),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 7 )(`VTX_REGISTER_PORT_NAME(PORT, 7 )),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 8 )(`VTX_REGISTER_PORT_NAME(PORT, 8 )),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 9 )(`VTX_REGISTER_PORT_NAME(PORT, 9 )),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 10)(`VTX_REGISTER_PORT_NAME(PORT, 10)),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 11)(`VTX_REGISTER_PORT_NAME(PORT, 11)),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 12)(`VTX_REGISTER_PORT_NAME(PORT, 12)),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 13)(`VTX_REGISTER_PORT_NAME(PORT, 13)),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 14)(`VTX_REGISTER_PORT_NAME(PORT, 14)),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 15)(`VTX_REGISTER_PORT_NAME(PORT, 15)),  \

`define VTX_REGISTER_PORTS_IO(NAME, IO) \
    IO wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 0 ), \
    IO wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 1 ), \
    IO wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 2 ), \
    IO wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 3 ), \
    IO wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 4 ), \
    IO wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 5 ), \
    IO wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 6 ), \
    IO wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 7 ), \
    IO wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 8 ), \
    IO wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 9 ), \
    IO wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 10), \
    IO wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 11), \
    IO wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 12), \
    IO wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 13), \
    IO wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 14), \
    IO wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 15), \

`define VTX_REGISTER_PORTS_IN(NAME)  `VTX_REGISTER_PORTS_IO(NAME, input)
`define VTX_REGISTER_PORTS_OUT(NAME) `VTX_REGISTER_PORTS_IO(NAME, output)

`define VTX_REGISTER_PORTS_ASSIGN(TO,FROM) \
    assign TO[0 ] = `VTX_REGISTER_PORT_NAME(FROM, 0 ); \
    assign TO[1 ] = `VTX_REGISTER_PORT_NAME(FROM, 1 ); \
    assign TO[2 ] = `VTX_REGISTER_PORT_NAME(FROM, 2 ); \
    assign TO[3 ] = `VTX_REGISTER_PORT_NAME(FROM, 3 ); \
    assign TO[4 ] = `VTX_REGISTER_PORT_NAME(FROM, 4 ); \
    assign TO[5 ] = `VTX_REGISTER_PORT_NAME(FROM, 5 ); \
    assign TO[6 ] = `VTX_REGISTER_PORT_NAME(FROM, 6 ); \
    assign TO[7 ] = `VTX_REGISTER_PORT_NAME(FROM, 7 ); \
    assign TO[8 ] = `VTX_REGISTER_PORT_NAME(FROM, 8 ); \
    assign TO[9 ] = `VTX_REGISTER_PORT_NAME(FROM, 9 ); \
    assign TO[10] = `VTX_REGISTER_PORT_NAME(FROM, 10); \
    assign TO[11] = `VTX_REGISTER_PORT_NAME(FROM, 11); \
    assign TO[12] = `VTX_REGISTER_PORT_NAME(FROM, 12); \
    assign TO[13] = `VTX_REGISTER_PORT_NAME(FROM, 13); \
    assign TO[14] = `VTX_REGISTER_PORT_NAME(FROM, 14); \
    assign TO[15] = `VTX_REGISTER_PORT_NAME(FROM, 15); \

`define VTX_REGISTER_PORTS_ASSIGNR(TO,FROM) \
    assign `VTX_REGISTER_PORT_NAME(TO, 0 ) = FROM[0 ]; \
    assign `VTX_REGISTER_PORT_NAME(TO, 1 ) = FROM[1 ]; \
    assign `VTX_REGISTER_PORT_NAME(TO, 2 ) = FROM[2 ]; \
    assign `VTX_REGISTER_PORT_NAME(TO, 3 ) = FROM[3 ]; \
    assign `VTX_REGISTER_PORT_NAME(TO, 4 ) = FROM[4 ]; \
    assign `VTX_REGISTER_PORT_NAME(TO, 5 ) = FROM[5 ]; \
    assign `VTX_REGISTER_PORT_NAME(TO, 6 ) = FROM[6 ]; \
    assign `VTX_REGISTER_PORT_NAME(TO, 7 ) = FROM[7 ]; \
    assign `VTX_REGISTER_PORT_NAME(TO, 8 ) = FROM[8 ]; \
    assign `VTX_REGISTER_PORT_NAME(TO, 9 ) = FROM[9 ]; \
    assign `VTX_REGISTER_PORT_NAME(TO, 10) = FROM[10]; \
    assign `VTX_REGISTER_PORT_NAME(TO, 11) = FROM[11]; \
    assign `VTX_REGISTER_PORT_NAME(TO, 12) = FROM[12]; \
    assign `VTX_REGISTER_PORT_NAME(TO, 13) = FROM[13]; \
    assign `VTX_REGISTER_PORT_NAME(TO, 14) = FROM[14]; \
    assign `VTX_REGISTER_PORT_NAME(TO, 15) = FROM[15]; \

