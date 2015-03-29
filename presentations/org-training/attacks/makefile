TALK     := presentation.pdf
TEX_SUFS := .aux .log .nav .out .snm .toc .vrb .fdb_latexmk .fls

%.pdf:%.tex
	latexmk -pdf $<

all: $(TALK)
genocide: clean clean-pdf clean-generated

markdown:
	pandoc content.md --slide-level 2 -t beamer -o contentgenerated.tex

clean:
	$(RM) $(foreach suf, ${TEX_SUFS}, $(TALK:.pdf=${suf})) *~
	$(RM) -r auto

clean-pdf:
	$(RM) *.pdf

clean-generated:
	$(RM) *generated*

