NOW := $(shell date)

all:
	pdflatex applied-crypto-hardening
	# no bibtex citations atm
	#bibtex applied-crypto-hardening
	#latex applied-crypto-hardening
	pdflatex applied-crypto-hardening
	#dvipdfm -z 9 applied-crypto-hardening
	#dvipdf applied-crypto-hardening.dvi

clean:
	rm -f applied-crypto-hardening.aux applied-crypto-hardening.bbl applied-crypto-hardening.blg applied-crypto-hardening.dvi applied-crypto-hardening.log applied-crypto-hardening.pdf applied-crypto-hardening.toc
