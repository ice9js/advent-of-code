## Solution ([Implementation](../../src/Fuel.elm))

```elm
-- Solution for part one: 1185296
minOreRequired 1 Dict.empty (parseInput recipes "FUEL")

-- Solution for part two: 1376631
maxForOre 1000000000000 (parseInput recipes "FUEL")
```

### Input

```elm
recipes = [
    ((4, "JXCXB"), [(13, "RXWQR")]),
    ((7, "XRWJ"), [(7, "FDGDX")]),
    ((3, "TPDSB"), [(3, "JBVN"), (25, "JFRXJ")]),
    ((3, "SVFT"), [(13, "HZDWS"), (11, "RZNJR")]),
    ((8, "LBVM"), [(5, "FDGDX"), (4, "RZNJR"), (41, "ZGXGP")]),
    ((9, "RXWQR"), [(1, "LJDRB")]),
    ((8, "JBVN"), [(2, "RDPWQ")]),
    ((8, "CXHK"), [(2, "CZCB")]),
    ((5, "TCBSQ"), [(4, "JXCXB"), (1, "FPQRV")]),
    ((8, "TWGNB"), [(6, "FDGDX")]),
    ((5, "VRVDQ"), [(1, "RJBTL")]),
    ((6, "KSJD"), [(2, "XRWJ"), (3, "HZDWS"), (12, "LBVM")]),
    ((8, "XRLZR"), [(15, "HPXST"), (1, "KMKR"), (7, "SLTX"), (1, "PRWD"), (14, "RCLB"), (31, "TPDSB"), (3, "GWXJP"), (3, "TPQZ")]),
    ((8, "DNRP"), [(1, "RBLT"), (2, "RTFKN"), (1, "CZCB")]),
    ((8, "TFGJ"), [(131, "ORE")]),
    ((5, "CFPZ"), [(2, "JFRXJ"), (1, "VRVDQ"), (26, "TWGNB")]),
    ((8, "RZNJR"), [(2, "SMPW"), (1, "TWGNB")]),
    ((6, "RDPWQ"), [(20, "HRZP")]),
    ((4, "HZDWS"), [(1, "RCLB"), (4, "GJNK"), (4, "QGJL")]),
    ((1, "FUEL"), [(7, "CXHK"), (2, "XTMRV"), (6, "WSNPZ"), (12, "LQXCP"), (19, "PMWJ"), (17, "GJNK"), (26, "XRLZR"), (36, "LWFQ")]),
    ((8, "KMKR"), [(131, "ORE")]),
    ((7, "RPKZ"), [(1, "LJDRB"), (12, "TFGJ"), (10, "RXWQR")]),
    ((8, "JFRXJ"), [(10, "RVXT"), (1, "RDPWQ")]),
    ((9, "TPQZ"), [(1, "QXBTX")]),
    ((5, "FZGF"), [(1, "ZGXGP")]),
    ((2, "FDGDX"), [(1, "RTFKN"), (1, "DNRP")]),
    ((4, "SMPW"), [(19, "CZCB"), (1, "RBLT")]),
    ((9, "RWSH"), [(2, "DNRP"), (1, "SMPW")]),
    ((5, "GWXJP"), [(1, "ZGXGP"), (5, "TCBSQ"), (22, "SMPW")]),
    ((3, "LQXCP"), [(1, "HBSKF")]),
    ((7, "CLGXQ"), [(1, "ZGXGP"), (2, "KSJD"), (9, "CFPZ")]),
    ((8, "LJDRB"), [(186, "ORE")]),
    ((1, "QGJL"), [(1, "TPQZ"), (2, "HBSKF")]),
    ((3, "PMWJ"), [(8, "FZGF"), (6, "FDGDX")]),
    ((1, "CZCB"), [(9, "KMKR")]),
    ((5, "HRZP"), [(21, "TFGJ"), (3, "RVXT")]),
    ((2, "RCLB"), [(39, "FDGDX"), (24, "TPDSB")]),
    ((2, "GJNK"), [(4, "HRZP")]),
    ((2, "HBSKF"), [(6, "RZNJR")]),
    ((8, "RVXT"), [(101, "ORE")]),
    ((8, "QXBTX"), [(1, "RCLB")]),
    ((7, "RBLT"), [(1, "RJBTL")]),
    ((1, "LWFQ"), [(2, "CFPZ"), (2, "JXCXB"), (4, "TPQZ")]),
    ((5, "WSNPZ"), [(1, "QGJL"), (24, "GJNK"), (6, "TWGNB"), (1, "SLTX"), (18, "JFRXJ"), (6, "MSNM"), (6, "FDGDX"), (2, "JXCXB")]),
    ((6, "FPQRV"), [(4, "RZNJR")]),
    ((5, "TXZVH"), [(12, "LJDRB"), (10, "JFRXJ"), (1, "ZGXGP")]),
    ((9, "PRWD"), [(13, "KSJD"), (11, "FXGW")]),
    ((5, "XTMRV"), [(11, "SVFT"), (2, "HZDWS"), (1, "CLGXQ"), (1, "LQXCP"), (6, "JXCXB"), (11, "PRWD")]),
    ((2, "SLTX"), [(27, "TWGNB"), (7, "FPQRV")]),
    ((9, "RJBTL"), [(2, "HRZP"), (6, "RXWQR")]),
    ((1, "RTFKN"), [(2, "CXHK"), (1, "RPKZ")]),
    ((2, "ZGXGP"), [(7, "RWSH"), (12, "JBVN"), (6, "FXGW")]),
    ((8, "MSNM"), [(1, "TXZVH"), (4, "FPQRV")]),
    ((5, "HPXST"), [(16, "TPDSB"), (1, "FXGW")]),
    ((2, "FXGW"), [(1, "VRVDQ")])
]
```
