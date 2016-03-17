#pdf1:
#	./update-metadata-for-gitinfo
#	#pandoc -f markdown_github -o notes.pdf notes.md	

all:	latex pdf

latex:	agenda.tex

agenda.tex: agenda.md
	pandoc  --listings -T "Bettercrypto workshop" -s -f markdown_github+pandoc_title_block+raw_tex -t latex -o agenda.tex agenda.md

slides.tex: agenda.md
	pandoc --listings -T "Bettercrypto AH workshop" -s -f markdown_github+pandoc_title_block+raw_tex -t beamer -o slides.tex agenda.md
	#pandoc  -T "Bettercrypto AH workshop" -s -f markdown_github+pandoc_title_block+raw_tex+implicit_figures -t beamer -o slides.tex agenda.md

pdf: agenda.pdf slides.pdf

agenda.pdf: agenda.tex
	# add the proper stylesheets
	cat styleheader.tex > r
	tail -n +2 agenda.tex  >> r
	mv r agenda.tex
	# update the toc
	pdflatex agenda.tex
	pdflatex agenda.tex

slides.pdf: slides.tex
	perl -p -i -e 's/\\usepackage\{amssymb,amsmath\}/\\usetheme{Berlin}\n\\usepackage{amssymb,amsmath}/g'  slides.tex 
	pdflatex slides.tex

clean:
	rm -f agenda.pdf  agenda.tex agenda.log agenda.out agenda.aux agenda.toc slides.tex
	rm -f slides.pdf  slides.nav slides.log slides.out slides.vrb slides.toc slides.aux slides.snm

