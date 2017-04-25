.. role:: raw-latex(raw)
   :format: latex
..

SSL libraries
=============

Most if not all of the cryptographic work is done by the SSL libraries
installed on your system. Supported protocols, cipher suites and more
depend on the version of the SSL library in use. Whenever you upgrade
the SSL library, a recompile of all applications using that library is
required to use the newly available features. Some features not only
require a SSL library supporting it, but also the application using that
feature. An example for that may be Apache supporting elliptic curve
cryptography only from version 2.4 onwards, no matter if OpenSSL
supported it or not.

As explained above, creating a secure setup isn’t just a matter of
configuration but also depends on several other factors with the most
important being the SSL libraries and their support of protocols and
cipher suites. Furthermore, applications actually need to make use of
those.

For most configuration snippets throughout this paper we used OpenSSL’s
cipher strings. Sadly they are different from the official IANA standard
names. When you use a different library like for example GnuTLS (which
is quite common on Debian systems) you might need to change the cipher
string. The hex code for a cipher string however is common to all
versions and and library implementations:
``TLS_RSA_CAMELLIA_256_CBC_SHA1`` in GnuTLS is equivalent to
``CAMELLIA256-SHA`` in OpenSSL and ``TLS_RSA_WITH_CAMELLIA_256_CBC_SHA``
in the IANA standard with the hex code ``0x00,0x84`` as specified in
:rfc:`5932`. Section
:ref:`section-cipher_suite_names` lists all currently
defined cipher suites with their codes and both names.

Regardless of this clash of nomenclature, as a sysadmin you are required
to check what the SSL libraries on your systems support on how you may
get the most security out of your systems.

Priority strings
~~~~~~~~~~~~~~~~

Choosing cipher strings requires the use of an intermediate language
that allows selection and deselection of ciphers, key exchange
mechanisms, MACs and combinations of those. Common combinators consist
of ``+``, ``-`` and ``!``

.. tabularcolumns:: rll

==================  ==================================  =======================
combinator          effect                              example            
==================  ==================================  =======================
``+``               add at this position                ``ALL:+SHA256``        
``-``               remove at the current position      ``ALL:-SSLv3``         
``!``               permanently remove from selection   ``ALL:!3DES:!RC4``     
(OpenSSL) ``@``     special command                     ``ALL:@STRENGTH``      
(GnuTLS) ``%``      special command                     ``NORMAL:%NEW_PADDING``
==================  ==================================  =======================


A list of special strings to use can be found in
http://www.gnutls.org/manual/html_node/Priority-Strings.html for GnuTLS
or https://www.openssl.org/docs/apps/ciphers.html for OpenSSL. There is,
however, no common syntax for a cipher string throughout different SSL
libraries.
