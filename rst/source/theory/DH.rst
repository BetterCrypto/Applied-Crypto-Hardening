.. role:: raw-latex(raw)
   :format: latex
..

A note on Diffie Hellman Key Exchanges
======================================

A common question is which Diffie Hellman (DH) Parameters should be used
for Diffie Hellman key exchanges [1]_. We follow the recommendations in
ECRYPT II :raw-latex:`\cite[chapter 16]{ii2011ecrypt}`

Where configurable, we recommend using the Diffie Hellman groups defined
for IKE, specifically groups 14-18 (2048–8192 bit
MODP :rfc:`3526`). These groups have been checked by
many eyes and can be assumed to be secure.

For convenience, we provide these parameters as PEM files on our
webserver [2]_.

.. [1]
   http://crypto.stackexchange.com/questions/1963/how-large-should-a-diffie-hellman-p-be

.. [2]
   https://www.bettercrypto.org/static/dhparams/
