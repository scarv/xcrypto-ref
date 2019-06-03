
#
# This file is used to specify specific proof depths for certain
# property contexts. This is essential for when the design functionality
# in question requires a minimum number of cycles to exercise.
#

$(SMTDIR)/instr_bop.rpt     : BMC_STEPS=6
$(SMTDIR)/instr_bop.cov     : BMC_STEPS=6

$(SMTDIR)/instr_pmul_h.rpt     : BMC_STEPS=13
$(SMTDIR)/instr_pmul_h.cov     : BMC_STEPS=13

$(SMTDIR)/instr_pmul_h_pw2.rpt : BMC_STEPS=21
$(SMTDIR)/instr_pmul_h_pw2.cov : BMC_STEPS=21

$(SMTDIR)/instr_pmul_h_pw1.rpt : BMC_STEPS=37
$(SMTDIR)/instr_pmul_h_pw1.cov : BMC_STEPS=37

$(SMTDIR)/instr_pmul_l.rpt     : BMC_STEPS=16
$(SMTDIR)/instr_pmul_l.cov     : BMC_STEPS=16

$(SMTDIR)/instr_pmul_l_pw2.rpt : BMC_STEPS=21
$(SMTDIR)/instr_pmul_l_pw2.cov : BMC_STEPS=21

$(SMTDIR)/instr_pmul_l_pw1.rpt : BMC_STEPS=37
$(SMTDIR)/instr_pmul_l_pw1.cov : BMC_STEPS=37

$(SMTDIR)/instr_pclmul_h.rpt     : BMC_STEPS=16
$(SMTDIR)/instr_pclmul_h.cov     : BMC_STEPS=16

$(SMTDIR)/instr_pclmul_h_pw2.rpt : BMC_STEPS=21
$(SMTDIR)/instr_pclmul_h_pw2.cov : BMC_STEPS=21

$(SMTDIR)/instr_pclmul_h_pw1.rpt : BMC_STEPS=37
$(SMTDIR)/instr_pclmul_h_pw1.cov : BMC_STEPS=37

$(SMTDIR)/instr_pclmul_l.rpt     : BMC_STEPS=16
$(SMTDIR)/instr_pclmul_l.cov     : BMC_STEPS=16

$(SMTDIR)/instr_pclmul_l_pw2.rpt : BMC_STEPS=21
$(SMTDIR)/instr_pclmul_l_pw2.cov : BMC_STEPS=21

$(SMTDIR)/instr_pclmul_l_pw1.rpt : BMC_STEPS=37
$(SMTDIR)/instr_pclmul_l_pw1.cov : BMC_STEPS=37

$(SMTDIR)/instr_padd.cov        : BMC_STEPS=6
$(SMTDIR)/instr_prot_i.cov      : BMC_STEPS=6
$(SMTDIR)/instr_prot.cov        : BMC_STEPS=6
$(SMTDIR)/instr_psll_i.cov      : BMC_STEPS=6
$(SMTDIR)/instr_psll.cov        : BMC_STEPS=6
$(SMTDIR)/instr_psrl_i.cov      : BMC_STEPS=6
$(SMTDIR)/instr_psrl.cov        : BMC_STEPS=6
$(SMTDIR)/instr_psub.cov        : BMC_STEPS=6
$(SMTDIR)/instr_padd.rpt        : BMC_STEPS=6
$(SMTDIR)/instr_prot_i.rpt      : BMC_STEPS=6
$(SMTDIR)/instr_prot.rpt        : BMC_STEPS=6
$(SMTDIR)/instr_psll_i.rpt      : BMC_STEPS=6
$(SMTDIR)/instr_psll.rpt        : BMC_STEPS=6
$(SMTDIR)/instr_psrl_i.rpt      : BMC_STEPS=6
$(SMTDIR)/instr_psrl.rpt        : BMC_STEPS=6
$(SMTDIR)/instr_psub.rpt        : BMC_STEPS=6

$(SMTDIR)/instr_aesmix_dec.rpt      : BMC_STEPS=10
$(SMTDIR)/instr_aesmix_enc.rpt      : BMC_STEPS=10
$(SMTDIR)/instr_aessub_dec.rpt      : BMC_STEPS=10
$(SMTDIR)/instr_aessub_decrot.rpt   : BMC_STEPS=10
$(SMTDIR)/instr_aessub_enc.rpt      : BMC_STEPS=10
$(SMTDIR)/instr_aessub_encrot.rpt   : BMC_STEPS=10
$(SMTDIR)/instr_aesmix_dec.cov      : BMC_STEPS=10
$(SMTDIR)/instr_aesmix_enc.cov      : BMC_STEPS=10
$(SMTDIR)/instr_aessub_dec.cov      : BMC_STEPS=10
$(SMTDIR)/instr_aessub_decrot.cov   : BMC_STEPS=10
$(SMTDIR)/instr_aessub_enc.cov      : BMC_STEPS=10
$(SMTDIR)/instr_aessub_encrot.cov   : BMC_STEPS=10

$(SMTDIR)/instr_gather_b.rpt      : BMC_STEPS=10
$(SMTDIR)/instr_gather_b.cov      : BMC_STEPS=10

$(SMTDIR)/instr_scatter_b.rpt     : BMC_STEPS=10
$(SMTDIR)/instr_scatter_b.cov     : BMC_STEPS=10

$(SMTDIR)/instr_init.rpt     : BMC_STEPS=21
$(SMTDIR)/instr_init.cov     : BMC_STEPS=21

$(SMTDIR)/protocols.rpt        : BMC_STEPS=40
