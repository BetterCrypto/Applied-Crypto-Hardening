NOW := $(shell date)

TEXMFHOME ?={./texmf,$(shell kpsewhich -var-value TEXMFHOME)}
LATEX = TEXMFHOME=${TEXMFHOME} pdflatex

all:	pdf html md

once:
	${LATEX} applied-crypto-hardening

pdf: 
	./update-metadata-for-gitinfo
	${LATEX} applied-crypto-hardening
	bibtex applied-crypto-hardening
	makeglossaries applied-crypto-hardening
	${LATEX} applied-crypto-hardening
	# re-do for refs
	${LATEX} applied-crypto-hardening
	while grep -s "Rerun to get cross-references right" \
        applied-crypto-hardening.log ; do \
	    ${LATEX} applied-crypto-hardening ; \
	done
	#dvipdfm -z 9 applied-crypto-hardening
	#dvipdf applied-crypto-hardening.dvi

html:
	latex2html applied-crypto-hardening

md:
	pandoc -f latex -t markdown -o applied-crypto-hardening.markdown \
            applied-crypto-hardening.tex

# experimental
txt:
	detex applied-crypto-hardening > applied-crypto-hardening.txt


#epub:
	 # experimental
#	 ~/Library/texmf/tex/latex/tex4ebook/tex4ebook applied-crypto-hardening.tex

epub:
 # experimental
	pandoc -f latex -t epub -o applied-crypto-hardening.epub applied-crypto-hardening.tex

upload:
	rsync -avz --progress --no-p --no-g --no-t applied-crypto-hardening.pdf www.bettercrypto.org:/var/www/static/
	rsync -avz --progress --no-p --no-g --no-t configuration www.bettercrypto.org:/var/www/static/

www:	pdf upload

clean:
	rm -f applied-crypto-hardening.aux applied-crypto-hardening.bbl \
            applied-crypto-hardening.blg applied-crypto-hardening.dvi   \
            applied-crypto-hardening.log applied-crypto-hardening.pdf   \
            applied-crypto-hardening.toc applied-crypto-hardening.markdown \
            applied-crypto-hardening.glo applied-crypto-hardening.glg \
            applied-crypto-hardening.gls applied-crypto-hardening.ind \
            applied-crypto-hardening.ilg applied-crypto-hardening.ist \
            applied-crypto-hardening.idx applied-crypto-hardening.lol \
			applied-crypto-hardening.out
	rm -rf applied-crypto-hardening/
	rm -rf gitHeadInfo.gin
	rm -f applied-crypto-hardening.txt
