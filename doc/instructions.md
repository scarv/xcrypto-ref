
Symbol          | Description
----------------|------------------------------------------------
gpra1           | GPR source address 1
gpra2           | GPR source address 2
xcra1           | XCR source address 1
xcra2           | XCR source address 2
xcra3           | XCR source address 3
gprs1           | GPR source data 1
gprs2           | GPR source data 2
xcrs1           | XCR source data 1
xcrs2           | XCR source data 2
xcrs3           | XCR source data 3
gprd            | GPR destination register
xcrd1           | XCR destination register 1
xcrd2           | XCR destination register 2
imm             | Immediate data
memrdata        | Memory read data
memwdata        | Memory write data
memaddr         | Memory address


Instruction     | Step 0                            | Step 1                            | Step 2                            | Step 3                           |
----------------|-----------------------------------|-----------------------------------|-----------------------------------|-----------------------------------|
`xc.xcr2gpr`    | xcrd1 <- gprs1                    |                                   |                                   |                                   |
`xc.gpr2xcr`    | gprd  <- xcrs1                    |                                   |                                   |                                   |
`xc.init`       | xcr[i] <- 0                       |                                   |                                   |                                   |
`xc.cmov.t`     | xcrd1 <- |xcrs2 ? xcrs1 : xcrs2   |                                   |                                   |                                   |
`xc.cmov.f`     | xcrd1 <- |xcrs2 ? xcrs2 : xcrs1   |                                   |                                   |                                   |
`xc.ldr.bu`     | memaddr <- gprs1 + gprs2          |                                   |                                   |                                   |
`xc.ldr.hu`     | memaddr <- gprs1 + gprs2          |                                   |                                   |                                   |
`xc.ldr.w`      | memaddr <- gprs1 + gprs2          |                                   |                                   |                                   |
`xc.ld.bu`      | memaddr <- gprs1 + imm            |                                   |                                   |                                   |
`xc.ld.hu`      | memaddr <- gprs1 + imm            |                                   |                                   |                                   |
`xc.ld.w`       | memaddr <- gprs1 + imm            |                                   |                                   |                                   |
`xc.ld.hiu`     | xcrd1 <- {imm[15:0],xcrd1[15:0]}  |                                   |                                   |                                   |
`xc.ld.liu`     | xcrd1 <- {xcrd1[31:16],imm[15:0]} |                                   |                                   |                                   |
`xc.str.b`      | memaddr <- gprs1 + gprs2          |                                   |                                   |                                   |
`xc.str.h`      | memaddr <- gprs1 + gprs2          |                                   |                                   |                                   |
`xc.str.w`      | memaddr <- gprs1 + gprs2          |                                   |                                   |                                   |
`xc.st.b`       | memaddr <- gprs1 + imm            |                                   |                                   |                                   |
`xc.st.h`       | memaddr <- gprs1 + imm            |                                   |                                   |                                   |
`xc.st.w`       | memaddr <- gprs1 + imm            |                                   |                                   |                                   |
`xc.rngseed`    | rng <- xcrs1                      |                                   |                                   |                                   |
`xc.rngsamp`    | xcrd1 <- rng                      |                                   |                                   |                                   |
`xc.rngtest`    | xcrd1 <- rng?                     |                                   |                                   |                                   |
`xc.scatter.b`  | memaddr <- gprs1 + xcrs2[7:0]     | memaddr <- gprs1 + xcrs2[15:8]    | memaddr <- gprs1 + xcrs2[23:16]   | memaddr <- gprs1 + xcrs2[31:24]   |
`xc.scatter.h`  | memaddr <- gprs1 + xcrs2[15:0]    | memaddr <- gprs1 + xcrs2[31:16]   |                                   |                                   |
`xc.gather.b`   | memaddr <- gprs1 + xcrs2[7:0]     | memaddr <- gprs1 + xcrs2[15:8]    | memaddr <- gprs1 + xcrs2[23:16]   | memaddr <- gprs1 + xcrs2[31:24]   |
`xc.gather.h`   | memaddr <- gprs1 + xcrs2[15:0]    | memaddr <- gprs1 + xcrs2[31:16]   |                                   |                                   |
`xc.padd`       | xcrd1 <- xcrs1 .. xcrs2           |                                   |                                   |                                   |
`xc.psub`       | xcrd1 <- xcrs1 .. xcrs2           |                                   |                                   |                                   |
`xc.pmul.l`     | xcrd1 <- xcrs1 .. xcrs2           |                                   |                                   |                                   |
`xc.pmul.h`     | xcrd1 <- xcrs1 .. xcrs2           |                                   |                                   |                                   |
`xc.pclmul.l`   | xcrd1 <- xcrs1 .. xcrs2           |                                   |                                   |                                   |
`xc.pclmul.h`   | xcrd1 <- xcrs1 .. xcrs2           |                                   |                                   |                                   |
`xc.psll`       | xcrd1 <- xcrs1 .. xcrs2           |                                   |                                   |                                   |
`xc.psrl`       | xcrd1 <- xcrs1 .. xcrs2           |                                   |                                   |                                   |
`xc.prot`       | xcrd1 <- xcrs1 .. xcrs2           |                                   |                                   |                                   |
`xc.psll.i`     | xcrd1 <- xcrs1 .. imm             |                                   |                                   |                                   |
`xc.psrl.i`     | xcrd1 <- xcrs1 .. imm             |                                   |                                   |                                   |
`xc.prot.i`     | xcrd1 <- xcrs1 .. imm             |                                   |                                   |                                   |
`xc.sha3.xy`    | gprd  <- f(gprs1, gprs2)          |                                   |                                   |                                   |
`xc.sha3.x1`    | gprd  <- f(gprs1, gprs2)          |                                   |                                   |                                   |
`xc.sha3.x2`    | gprd  <- f(gprs1, gprs2)          |                                   |                                   |                                   |
`xc.sha3.x4`    | gprd  <- f(gprs1, gprs2)          |                                   |                                   |                                   |
`xc.sha3.yx`    | gprd  <- f(gprs1, gprs2)          |                                   |                                   |                                   |
`xc.aessub.enc` | xcrd1 <- f(xcrs1, xcrs2)          |                                   |                                   |                                   |
`xc.aessub.enc` | xcrd1 <- f(xcrs1, xcrs2)          |                                   |                                   |                                   |
`xc.aessub.dec` | xcrd1 <- f(xcrs1, xcrs2)          |                                   |                                   |                                   |
`xc.aessub.dec` | xcrd1 <- f(xcrs1, xcrs2)          |                                   |                                   |                                   |
`xc.aesmix.enc` | xcrd1 <- f(xcrs1, xcrs2)          |                                   |                                   |                                   |
`xc.aesmix.dec` | xcrd1 <- f(xcrs1, xcrs2)          |                                   |                                   |                                   |
`xc.lut`        | xcrd1 <- f(xcrd1, xcrs1, xcrs2)   |                                   |                                   |                                   |
`xc.bop`        | xcrd1 <- f(xcrd1,xcrs1,xcrs2,imm) |                                   |                                   |                                   |
`xc.mequ`       | gprd1 <- xcrs1 == xcrs2           |                                   |                                   |                                   |
`xc.mlte`       | gprd1 <- xcrs1 <= xcrs2           |                                   |                                   |                                   |
`xc.mgte`       | gprd1 <- xcrs1 >= xcrs2           |                                   |                                   |                                   |
`xc.madd.3`     | tmp <- xcrs1 + xcrs2              |  xcrd1,xcrd2 <- tmp + xcrs3       |                                   |                                   |
`xc.msub.3`     | tmp <- xcrs1 - xcrs2              |  xcrd1,xcrd2 <- tmp - xcrs3       |                                   |                                   |
`xc.madd.2`     | xcrd1,xcrd2 <- xcrs1 + xcrs2      |                                   |                                   |                                   |
`xc.msub.2`     | xcrd1,xcrd2 <- xcrs1 - xcrs2      |                                   |                                   |                                   |
`xc.macc.2`     | tmp <- xcrd1,xcrd2 + xcrs1        |  xcrd1,xcrd2 <- tmp + xcrs2       |                                   |                                   |
`xc.macc.1`     | xcrd1,xcrd2 <- xcrd1,xcrd2 +xcrs1 |                                   |                                   |                                   |
`xc.msll`       | xcrd1,xcrd2 <- xcrs1,xcrs2<< xcrs3|                                   |                                   |                                   |
`xc.msrl`       | xcrd1,xcrd2 <- xcrs1,xcrs2>> xcrs3|                                   |                                   |                                   |
`xc.mmul.3`     | tmp         <- xcrs1 * xcrs2      |  xcrd1,xcrd2 <- tmp + xcrs3       |                                   |                                   |
`xc.clmmul.3`   | tmp         <- xcrs1 . xcrs2      |  xcrd1,xcrd2 <- tmp . xcrs3       |                                   |                                   |
`xc.msll.i`     | xcrd1,xcrd2 <- xcrs1,xcrs2 << imm |                                   |                                   |                                   |
`xc.msrl.i`     | xcrd1,xcrd2 <- xcrs1,xcrs2 >> imm |                                   |                                   |                                   |
`xc.ipbit`      | xcrd1 <- f(xcrs1, xcrs2)          |                                   |                                   |                                   |
`xc.pbit`       | xcrd1 <- f(xcrs1, xcrs2)          |                                   |                                   |                                   |
`xc.pbyte`      | xcrd1 <- f(xcrs1, imm  )          |                                   |                                   |                                   |
`xc.bmv`        | xcrd1 <- f(xcrs1, xcrd1, imm)     |                                   |                                   |                                   |
`xc.ins`        | xcrd1 <- f(xcrs1, xcrd1, imm)     |                                   |                                   |                                   |
`xc.ext`        | xcrd1 <- f(xcrs1, imm)            |                                   |                                   |                                   |

