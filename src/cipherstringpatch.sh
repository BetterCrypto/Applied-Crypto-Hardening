#!/bin/sh

find . -name "*.tex" -exec "./perlify.pl  < \{\} > /tmp.foo; mv /tmp.foo \{\}" \;
