all:	pdf html

pdf: 
	asciidoctor-pdf -r asciidoctor-bibliography applied-crypto-hardening.adoc

html:
	asciidoctor -r asciidoctor-bibliography applied-crypto-hardening.adoc

clean:
	rm -f applied-crypto-hardening.html \
		applied-crypto-hardening.pdf
