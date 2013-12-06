NOW := $(shell date)

all:	pdf html md

pdf:
	./update-metadata-for-gitinfo
	pdflatex applied-crypto-hardening
	bibtex applied-crypto-hardening
	while grep -s "Rerun to get cross-references right" \
        applied-crypto-hardening.log ; do \
	    pdflatex applied-crypto-hardening ; \
	done
	#dvipdfm -z 9 applied-crypto-hardening
	#dvipdf applied-crypto-hardening.dvi

html:
	latex2html applied-crypto-hardening

md:
	pandoc -f latex -t markdown -o applied-crypto-hardening.markdown \
            applied-crypto-hardening.tex

#epub:
	 # experimental
#	 ~/Library/texmf/tex/latex/tex4ebook/tex4ebook applied-crypto-hardening.tex

epub:
 # experimental
	pandoc -f latex -t epub -o applied-crypto-hardening.epub applied-crypto-hardening.tex

clean:
	rm -f applied-crypto-hardening.aux applied-crypto-hardening.bbl \
            applied-crypto-hardening.blg applied-crypto-hardening.dvi   \
            applied-crypto-hardening.log applied-crypto-hardening.pdf   \
            applied-crypto-hardening.toc applied-crypto-hardening.markdown
	rm -rf applied-crypto-hardening/
	rm -rf gitHeadInfo.gin
