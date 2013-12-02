NOW := $(shell date)

all:	pdf html md

pdf:
	./update-metadata-for-gitinfo
	pdflatex applied-crypto-hardening
	# no bibtex citations atm
	#bibtex applied-crypto-hardening
	#latex applied-crypto-hardening
	pdflatex applied-crypto-hardening
	#dvipdfm -z 9 applied-crypto-hardening
	#dvipdf applied-crypto-hardening.dvi

html:
	latex2html applied-crypto-hardening

md:
	pandoc -f latex -t markdown -o  applied-crypto-hardening.markdown applied-crypto-hardening.tex

clean:
	rm -f applied-crypto-hardening.aux applied-crypto-hardening.bbl applied-crypto-hardening.blg applied-crypto-hardening.dvi applied-crypto-hardening.log applied-crypto-hardening.pdf applied-crypto-hardening.toc applied-crypto-hardening.markdown
	rm -rf applied-crypto-hardening/
	rm -rf gitHeadInfo.gin
