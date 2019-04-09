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

`ifdef FORMAL
`include "fml_common.vh"
`endif

//
// module: scarv_cop_cprs
//
//  The general purpose register file used by the COP.
//
module scarv_cop_cprs (

input  wire             g_clk         , // Global clock
output wire             g_clk_req     , // Clock request
input  wire             g_resetn      , // Synchronous active low reset.

`ifdef FORMAL
`VTX_REGISTER_PORTS_OUT(cprs_snoop)
`endif

input  wire             cprs_init     , // xc.init being executed.
output wire             cprs_init_done, // xc.init being executed.

input  wire             crs1_ren      , // Port 1 read enable
input  wire [ 3:0]      crs1_addr     , // Port 1 address
output wire [31:0]      crs1_rdata    , // Port 1 read data

input  wire             crs2_ren      , // Port 2 read enable
input  wire [ 3:0]      crs2_addr     , // Port 2 address
output wire [31:0]      crs2_rdata    , // Port 2 read data

input  wire             crs3_ren      , // Port 3 read enable
input  wire [ 3:0]      crs3_addr     , // Port 3 address
output wire [31:0]      crs3_rdata    , // Port 3 read data

input  wire [ 3:0]      crd_wen       , // Port 4 write enable
input  wire [ 3:0]      crd_addr      , // Port 4 address
input  wire [31:0]      crd_wdata       // Port 4 write data

);

// Only need a clock when doing a write.
assign g_clk_req = crd_wen;

// Storage for the registers
reg [7:0] cprs_0 [15:0];
reg [7:0] cprs_1 [15:0];
reg [7:0] cprs_2 [15:0];
reg [7:0] cprs_3 [15:0];

`ifdef FORMAL

// Helper logic to make it easier for tracer to access CPRS.
genvar i;
wire [31:0] cprs[15:0];

generate for(i = 0; i < 16; i = i + 1) begin
    assign cprs[i] = {cprs_3[i],cprs_2[i],cprs_1[i],cprs_0[i]};

    always @(posedge g_clk) if(!g_resetn) cprs_0[i] <= $anyconst;
    always @(posedge g_clk) if(!g_resetn) cprs_1[i] <= $anyconst;
    always @(posedge g_clk) if(!g_resetn) cprs_2[i] <= $anyconst;
    always @(posedge g_clk) if(!g_resetn) cprs_3[i] <= $anyconst;

end endgenerate

// See ./verif/formal/fml_common.vh
`VTX_REGISTER_PORTS_ASSIGNR(cprs_snoop,cprs)
`endif


reg  [4:0] init_fsm;
wire [4:0] n_init_fsm = init_fsm + 1;

assign cprs_init_done = init_fsm == 15;

always @(posedge g_clk) begin
    if(cprs_init) begin
        init_fsm <= init_fsm == 15 ? 15 : n_init_fsm;
    end else begin
        init_fsm <= 0;
    end
end

wire [ 3:0] wen     = cprs_init ? 4'hF      : crd_wen;
wire [31:0] wdata   = cprs_init ? 32'b0     : crd_wdata;
wire [ 3:0] addr    = cprs_init ? init_fsm  : crd_addr;

//
// Read port logic
//

assign crs1_rdata = {32{crs1_ren}} & 
    {cprs_3[crs1_addr],cprs_2[crs1_addr],cprs_1[crs1_addr],cprs_0[crs1_addr]};

assign crs2_rdata = {32{crs2_ren}} &
    {cprs_3[crs2_addr],cprs_2[crs2_addr],cprs_1[crs2_addr],cprs_0[crs2_addr]};

assign crs3_rdata = {32{crs3_ren}} &
    {cprs_3[crs3_addr],cprs_2[crs3_addr],cprs_1[crs3_addr],cprs_0[crs3_addr]};

//
// Generate logic for each register.
//

always @(posedge g_clk) if(wen[3]) cprs_3[addr] <= wdata[31:24];
always @(posedge g_clk) if(wen[2]) cprs_2[addr] <= wdata[23:16];
always @(posedge g_clk) if(wen[1]) cprs_1[addr] <= wdata[15: 8];
always @(posedge g_clk) if(wen[0]) cprs_0[addr] <= wdata[ 7: 0];

endmodule

