## Makefile
## Copyright 2011 Mohamed El Morabity
#
# This work may be distributed and/or modified under the conditions of the LaTeX
# Project Public License, either version 1.3 of this license or (at your option)
# any later version. The latest version of this license is in
# http://www.latex-project.org/lppl.txt and version 1.3 or later is part of all
# distributions of LaTeX version 2005/12/01 or later.
#
# This work has the LPPL maintenance status `maintained'.
#
# The Current Maintainer of this work is Mohamed El Morabity
#
# This work consists of all files listed in manifest.txt.

######################
# Fonts informations #
######################

FONT_NAME = opensans
FOUNDRY = public
FONT_CODES = fos fosj

# Supported LaTeX encodings
SUPPORTED_ENCODINGS = ot1 t1 ts1 t2a t2b t2c x2 lgr
# Supported LaTeX encodings containing small caps
SUPPORTED_SC_ENCODINGS = $(filter-out ts1,$(SUPPORTED_ENCODINGS))
# Custom encodings provided
INPUT_ENCODINGS = $(INPUT_ETX_FILES:$(FONT_NAME)-%.etx=%)


#####################
# Installation root #
#####################

TEXMFHOME = $(shell kpsexpand '$$TEXMFHOME')


###########
# Archive #
###########

ARCHIVE_ROOT = $(FONT_NAME)
ARCHIVE = $(FONT_NAME).zip


###########
# Sources #
###########

TRUETYPE_FILES = $(wildcard *.ttf)

# Fontinst files
FONTINST_FILE = $(FONT_NAME)-drv.tex
FONTINST_MAP_FILE = $(FONT_NAME)-map.tex

# Custom Fontinst encoding files
INPUT_ETX_FILES = $(FONT_NAME)-01.etx $(FONT_NAME)-02.etx $(FONT_NAME)-03.etx $(FONT_NAME)-04.etx
ETX_FILES = $(FONT_NAME)-osfigures.etx
MTX_FILES = $(FONT_NAME)-fixlatin.mtx $(FONT_NAME)-fixtextcomp.mtx $(FONT_NAME)-fixcyrillic.mtx $(FONT_NAME)-fixgreek.mtx

STYLE_FILES = $(wildcard *.sty)

DOCUMENTATION = $(FONT_NAME).tex $(FONT_NAME).pdf $(FONT_NAME)-samples.tex $(FONT_NAME)-samples.pdf README CHANGES

# Files to be installed in texmf/source
SOURCE_FILES = $(FONTINST_FILE) $(FONTINST_MAP_FILE) $(INPUT_ETX_FILES) $(ETX_FILES) $(MTX_FILES) Makefile ttf2type1.pe



###################
# Generated files #
###################

TYPE1_FILES = $(TRUETYPE_FILES:.ttf=.pfb)
AFM_FILES = $(TYPE1_FILES:.pfb=.afm)

# Fontinst log file
FONTINST_REC_FILE = $(FONT_NAME)-rec.tex

# Metrics files
PL_FILES = $(foreach e,$(INPUT_ENCODINGS),   \
             $(TRUETYPE_FILES:.ttf=-$(e).pl) \
           )
OUTPUT_MTX_FILES = $(PL_FILES:.pl=.mtx)
VPL_FILES = $(foreach e,$(SUPPORTED_ENCODINGS),                    \
              $(TRUETYPE_FILES:.ttf=-$(e:$(FONT_NAME)-=).vpl)      \
            )                                                      \
            $(foreach e,$(SUPPORTED_SC_ENCODINGS),                 \
              $(TRUETYPE_FILES:.ttf=-OSFigures-$(e).vpl)           \
              $(TRUETYPE_FILES:.ttf=-SmallCaps-$(e).vpl)           \
              $(TRUETYPE_FILES:.ttf=-SmallCaps-OSFigures-$(e).vpl) \
            )
TFM_FILES = $(PL_FILES:.pl=.tfm) $(VPL_FILES:.vpl=.tfm)
VF_FILES = $(VPL_FILES:.vpl=.vf)

MAP = $(FONT_NAME).map

# Font definition files
FD_FILES = $(foreach e,$(SUPPORTED_ENCODINGS), \
               $(FONT_CODES:%=$(e)%.fd)        \
           )

# Generated encoding files
ENC_FILES = $(INPUT_ETX_FILES:.etx=.enc)

# Generated files to be installed
GENERATED_FILES = $(TYPE1_FILES) $(AFM_FILES) $(TFM_FILES) $(VF_FILES) $(MAP) $(FD_FILES) $(ENC_FILES)




default: all


all: dist


dist: $(ARCHIVE)


%.pfb %.afm: %.ttf
	fontforge ttf2type1.pe $<


%.tfm: %.pl
	pltotf $< $@


%.tfm: %.vpl
	vptovf $^ $


%.vf: %.vpl
	vptovf $^ $@


$(FONTINST_REC_FILE): $(AFM_FILES) $(MTX_FILES) $(FONTINST_FILE)
	latex $(FONTINST_FILE)


$(PL_FILES) $(VPL_FILES): $(FONTINST_REC_FILE)


$(MAP): $(FONTINST_REC_FILE) $(FONTINST_MAP_FILE)
	latex $(FONTINST_MAP_FILE)


$(FD_FILES) $(ENC_FILES): $(MAP)


texmf-tree: clean-texmf-tree $(GENERATED_FILES) $(SOURCES_FILES)
	mkdir -p $(ARCHIVE_ROOT)/doc/fonts/$(FONT_NAME)/
	mkdir -p $(ARCHIVE_ROOT)/tex/latex/$(FONT_NAME)/
	mkdir -p $(ARCHIVE_ROOT)/fonts/{enc,map}/dvips/$(FONT_NAME)/
	mkdir -p $(ARCHIVE_ROOT)/fonts/{afm,tfm,truetype,type1,vf}/$(FOUNDRY)/$(FONT_NAME)/
	mkdir -p $(ARCHIVE_ROOT)/source/fonts/$(FONT_NAME)/
	cp -p $(DOCUMENTATION) $(ARCHIVE_ROOT)/doc/fonts/$(FONT_NAME)/
	cp -p $(FD_FILES) $(STYLE_FILES) $(ARCHIVE_ROOT)/tex/latex/$(FONT_NAME)/
	cp -p $(ENC_FILES) $(ARCHIVE_ROOT)/fonts/enc/dvips/$(FONT_NAME)/
	cp -p $(MAP) $(ARCHIVE_ROOT)/fonts/map/dvips/$(FONT_NAME)/
	cp -p $(AFM_FILES) $(ARCHIVE_ROOT)/fonts/afm/$(FOUNDRY)/$(FONT_NAME)/
	cp -p $(TFM_FILES) $(ARCHIVE_ROOT)/fonts/tfm/$(FOUNDRY)/$(FONT_NAME)/
	cp -p $(TRUETYPE_FILES) $(ARCHIVE_ROOT)/fonts/truetype/$(FOUNDRY)/$(FONT_NAME)/
	cp -p $(TYPE1_FILES) $(ARCHIVE_ROOT)/fonts/type1/$(FOUNDRY)/$(FONT_NAME)/
	cp -p $(VF_FILES) $(ARCHIVE_ROOT)/fonts/vf/$(FOUNDRY)/$(FONT_NAME)/
	cp -p $(SOURCE_FILES) $(ARCHIVE_ROOT)/source/fonts/$(FONT_NAME)/
	cp -p README $(ARCHIVE_ROOT)
	cd $(ARCHIVE_ROOT) && find . -type f > manifest.txt


$(ARCHIVE): clean-texmf-tree texmf-tree
	zip -r $@ $(ARCHIVE_ROOT)


install: texmf-tree
	mkdir -p $(TEXMFHOME)
	cp -a $(ARCHIVE_ROOT)/* $(TEXMFHOME)
	texhash
	updmap --enable Map=$(MAP)


uninstall:
	$(RM) -r $(TEXMFHOME)/doc/latex/$(FONT_NAME)/
	$(RM) -r $(TEXMFHOME)/tex/latex/$(FONT_NAME)/
	$(RM) -r $(TEXMFHOME)/fonts/{enc,map}/dvips/$(FONT_NAME)/
	$(RM) -r $(TEXMFHOME)/fonts/{afm,tfm,type1,vf}/$(FOUNDRY)/$(FONT_NAME)/
	$(RM) -r $(TEXMFHOME)/source/$(FONT_NAME)/
	updmap --disable $(MAP)
	texhash


clean: clean-texmf-tree
	$(RM) $(TYPE1_FILES) $(AFM_FILES)
	$(RM) $(FONTINST_REC_FILE)
	$(RM) $(PL_FILES) $(TYPE1_FILES:.pfb=.pl)
	$(RM) $(OUTPUT_MTX_FILES) $(TYPE1_FILES:.pfb=.mtx)
	$(RM) $(VPL_FILES)
	$(RM) $(TFM_FILES)
	$(RM) $(VF_FILES)
	$(RM) $(MAP)
	$(RM) $(FD_FILES)
	$(RM) $(ENC_FILES)
	$(RM) $(ARCHIVE)
	$(RM) *~ *.log


clean-texmf-tree:
	$(RM) -r $(ARCHIVE_ROOT)


.PHONY: clean clean-texmf-tree texmf-tree
