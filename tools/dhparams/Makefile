INFILES = $(wildcard *.txt)
PEMFILES = $(patsubst %.txt, %.pem, $(INFILES))
OPENSSHFILES = $(patsubst %.txt, %.openssh, $(INFILES))
OUTFILES = $(PEMFILES) $(OPENSSHFILES) moduli.openssh

.DELETE_ON_ERROR:

.PHONY: all clean

all: $(OUTFILES)

%.pem: %.txt
	gen_pkcs3 `perl parse.pl $<` > $@

%.openssh: %.txt
	sh openssh-modulus.sh $< > $@

moduli.openssh: $(OPENSSHFILES)
	cat $^ > $@

clean:
	rm -f $(OUTFILES)
