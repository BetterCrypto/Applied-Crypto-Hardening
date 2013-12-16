INFILES = $(wildcard *.txt)
OUTFILES = $(patsubst %.txt, %.pem, $(INFILES))

.DELETE_ON_ERROR:

all: $(OUTFILES)

%.pem: %.txt
	gen_pkcs3 `perl parse.pl $<` > $@
