
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
                | 


Instruction     | XCR WDATA 1 | XCR ADDR 1 | XCR WDATA 2 | XCR ADDR 2 | GPR WDATA 1 | GPR ADDR 1 | MEM ADDR    | MEM WDATA   |
----------------|-------------|------------|-------------|------------|-------------|------------|-------------|-------------|
`xc.xcr2gpr`    |             |            |             |            |  xcrs1      | gprd       |             |             |
`xc.gpr2xcr`    | gprs1       | xcrd1      |             |            |             |            |             |             |
`xc.init`       |             |            |             |            |             |            |             |             |
`xc.cmov.t`     | xcrs1       | xcrd1      |             |            |             |            |             |             |
`xc.cmov.f`     | xcrs1       | xcrd1      |             |            |             |            |             |             |
`xc.ldr.bu`     | memrdata    | xcrd1      |             |            |             |            | gprs1+gprs2 |             |
`xc.ldr.hu`     | memrdata    | xcrd1      |             |            |             |            | gprs1+gprs2 |             |
`xc.ldr.w`      | memrdata    | xcrd1      |             |            |             |            | gprs1+gprs2 |             |
`xc.ld.bu`      | memrdata    | xcrd1      |             |            |             |            | gprs1+imm   |             |
`xc.ld.hu`      | memrdata    | xcrd1      |             |            |             |            | gprs1+imm   |             |
`xc.ld.w`       | memrdata    | xcrd1      |             |            |             |            | gprs1+imm   |             |
`xc.ld.hiu`     | imm         |            |             |            |             |            |             |             |
`xc.ld.liu`     | imm         |            |             |            |             |            |             |             |
`xc.str.b`      |             |            |             |            |             |            | gprs1+gprs2 | xcrs1       |
`xc.str.h`      |             |            |             |            |             |            | gprs1+gprs2 | xcrs1       |
`xc.str.w`      |             |            |             |            |             |            | gprs1+gprs2 | xcrs1       |
`xc.st.b`       |             |            |             |            |             |            | gprs1+imm   | xcrs1       |
`xc.st.h`       |             |            |             |            |             |            | gprs1+imm   | xcrs1       |
`xc.st.w`       |             |            |             |            |             |            | gprs1+imm   | xcrs1       |
`xc.scatter.b`  |             |            |             |            |             |            | gprs1+xcrs2 | xcrd        |
`xc.scatter.h`  |             |            |             |            |             |            | gprs1+xcrs2 | xcrd        |
`xc.gather.b`   | gadata      | xcrd1      |             |            |             |            |             |             |
`xc.gather.h`   | gadata      | xcrd1      |             |            |             |            |             |             |
`xc.rngseed`    |             |            |             |            |             |            |             |             |
`xc.rngsamp`    | rngd        | xcrd1      |             |            |             |            |             |             |
`xc.rngtest`    | rngs        | xcrd1      |             |            |             |            |             |             |
`xc.padd`       | xcrs1.xcrs2 | xcrd1      |             |            |             |            |             |             |
`xc.psub`       | xcrs1.xcrs2 | xcrd1      |             |            |             |            |             |             |
`xc.pmul.l`     | xcrs1.xcrs2 | xcrd1      |             |            |             |            |             |             |
`xc.pmul.h`     | xcrs1.xcrs2 | xcrd1      |             |            |             |            |             |             |
`xc.pclmul.l`   | xcrs1.xcrs2 | xcrd1      |             |            |             |            |             |             |
`xc.pclmul.h`   | xcrs1.xcrs2 | xcrd1      |             |            |             |            |             |             |
`xc.psll`       | xcrs1.xcrs2 | xcrd1      |             |            |             |            |             |             |
`xc.psrl`       | xcrs1.xcrs2 | xcrd1      |             |            |             |            |             |             |
`xc.prot`       | xcrs1.xcrs2 | xcrd1      |             |            |             |            |             |             |
`xc.psll.i`     | xcrs1.xcrs2 | xcrd1      |             |            |             |            |             |             |
`xc.psrl.i`     | xcrs1.xcrs2 | xcrd1      |             |            |             |            |             |             |
`xc.prot.i`     | xcrs1.xcrs2 | xcrd1      |             |            |             |            |             |             |
`xc.sha3.xy`    |             |            |             |            | sha3        | gprd       |             |             |
`xc.sha3.x1`    |             |            |             |            | sha3        | gprd       |             |             |
`xc.sha3.x2`    |             |            |             |            | sha3        | gprd       |             |             |
`xc.sha3.x4`    |             |            |             |            | sha3        | gprd       |             |             |
`xc.sha3.yx`    |             |            |             |            | sha3        | gprd       |             |             |
`xc.aessub.enc` | aes         | xcrd1      |             |            |             |            |             |             |
`xc.aessub.enc` | aes         | xcrd1      |             |            |             |            |             |             |
`xc.aessub.dec` | aes         | xcrd1      |             |            |             |            |             |             |
`xc.aessub.dec` | aes         | xcrd1      |             |            |             |            |             |             |
`xc.aesmix.enc` | aes         | xcrd1      |             |            |             |            |             |             |
`xc.aesmix.dec` | aes         | xcrd1      |             |            |             |            |             |             |
`xc.lut`        | lut         | xcrd1      |             |            |             |            |             |             |
`xc.bop`        | bop         | xcrd1      |             |            |             |            |             |             |
`xc.mequ`       |             |            |             |            | cmpres      | gprd       |             |             |
`xc.mlte`       |             |            |             |            | cmpre       | gprd       |             |             |
`xc.mgte`       |             |            |             |            | cmpre       | gprd       |             |             |
`xc.madd.3`     | malulo      | xcrd1      | maluhi      | xcrd2      |             |            |             |             |
`xc.msub.3`     | malulo      | xcrd1      | maluhi      | xcrd2      |             |            |             |             |
`xc.madd.2`     | malulo      | xcrd1      | maluhi      | xcrd2      |             |            |             |             |
`xc.msub.2`     | malulo      | xcrd1      | maluhi      | xcrd2      |             |            |             |             |
`xc.macc.2`     | malulo      | xcrd1      | maluhi      | xcrd2      |             |            |             |             |
`xc.macc.1`     | malulo      | xcrd1      | maluhi      | xcrd2      |             |            |             |             |
`xc.msll`       | malulo      | xcrd1      | maluhi      | xcrd2      |             |            |             |             |
`xc.msrl`       | malulo      | xcrd1      | maluhi      | xcrd2      |             |            |             |             |
`xc.mmul.3`     | malulo      | xcrd1      | maluhi      | xcrd2      |             |            |             |             |
`xc.mclmul.3`   | malulo      | xcrd1      | maluhi      | xcrd2      |             |            |             |             |
`xc.msll.i`     | malulo      | xcrd1      | maluhi      | xcrd2      |             |            |             |             |
`xc.msrl.i`     | malulo      | xcrd1      | maluhi      | xcrd2      |             |            |             |             |
`xc.ipbit`      | op          | xcrd1      |             |            |             |            |             |             |
`xc.pbit`       | op          | xcrd1      |             |            |             |            |             |             |
`xc.pbyte`      | op          | xcrd1      |             |            |             |            |             |             |
`xc.ins`        | op          | xcrd1      |             |            |             |            |             |             |
`xc.bmv`        | op          | xcrd1      |             |            |             |            |             |             |
`xc.ext`        | op          | xcrd1      |             |            |             |            |             |             |

