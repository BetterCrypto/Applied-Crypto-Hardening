all: suite_names.tex

install: all
	cp suite_names.tex ../../src/

.DELETE_ON_ERROR:

suite_names.tex: tls-parameters-4.csv openssl-ciphers.txt template.tex buildsuites.pl
	perl buildsuites.pl template.tex tls-parameters-4.csv openssl-ciphers.txt > $@

tls-parameters-4.csv:
	wget https://www.iana.org/assignments/tls-parameters/tls-parameters-4.csv

openssl-ciphers.txt:
	(openssl ciphers -V 'ALL:COMPLEMENTOFALL'; openssl version) > $@

