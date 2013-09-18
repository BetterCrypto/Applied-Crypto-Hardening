all:
	latex applied-crypto-hardening
	bibtex applied-crypto-hardening
	latex applied-crypto-hardening
	latex applied-crypto-hardening
	dvipdfm -z 9 applied-crypto-hardening
	dvipdf applied-crypto-hardening.dvi

clean:
	rm applied-crypto-hardening.aux applied-crypto-hardening.bbl applied-crypto-hardening.blg applied-crypto-hardening.dvi applied-crypto-hardening.log applied-crypto-hardening.pdf
