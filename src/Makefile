NOW := $(shell date)

# TEXMFHOME ?={./texmf,$(shell kpsewhich -var-value TEXMFHOME)}
# LATEX = TEXMFHOME=${TEXMFHOME} pdflatex -synctex=1

all:	pdf html

# once:
#	${LATEX} applied-crypto-hardening

pdf: 
	asciidoctor-pdf -r asciidoctor-bibliography applied-crypto-hardening.adoc
#	${LATEX} applied-crypto-hardening
#	bibtex applied-crypto-hardening
#	makeglossaries applied-crypto-hardening
#	${LATEX} applied-crypto-hardening
#	# re-do for refs
#	${LATEX} applied-crypto-hardening
#	while grep -s "Rerun to get cross-references right" \
#        applied-crypto-hardening.log ; do \
#	    ${LATEX} applied-crypto-hardening ; \
#	done
#	#dvipdfm -z 9 applied-crypto-hardening
#	#dvipdf applied-crypto-hardening.dvi

html:
	asciidoctor -r asciidoctor-bibliography applied-crypto-hardening.adoc



#epub:
	 # experimental
#	 ~/Library/texmf/tex/latex/tex4ebook/tex4ebook applied-crypto-hardening.tex

# epub:
#  # experimental
# 	pandoc -f latex -t epub -o applied-crypto-hardening.epub applied-crypto-hardening.tex

# upload:
# 	rsync -avz --progress --no-p --no-g --no-t applied-crypto-hardening.pdf www.bettercrypto.org:/var/www/bettercrypto.org/static
# 	rsync -avz --progress --no-p --no-g --no-t configuration www.bettercrypto.org:/var/www/bettercrypto.org/static
# 
# www:	pdf upload

clean:
	rm -f applied-crypto-hardening.html \
		applied-crypto-hardening.pdf
