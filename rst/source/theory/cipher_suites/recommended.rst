Recommended cipher suites
-------------------------

In principle system administrators who want to improve their
communication security have to make a difficult decision between
effectively locking out some users and keeping high cipher suite
security while supporting as many users as possible. The website
https://www.ssllabs.com/ gives administrators and security engineers a
tool to test their setup and compare compatibility with clients. The
authors made use of ssllabs.com to arrive at a set of cipher suites
which we will recommend throughout this document.

Configuration A: Strong ciphers, fewer clients
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

At the time of writing, our recommendation is to use the following set
of strong cipher suites which may be useful in an environment where one
does not depend on many, different clients and where compatibility is
not a big issue. An example of such an environment might be
machine-to-machine communication or corporate deployments where software
that is to be used can be defined without restrictions.

We arrived at this set of cipher suites by selecting:

TLS 1.2

Perfect forward secrecy / ephemeral Diffie Hellman

strong MACs (SHA-2) or

GCM as Authenticated Encryption scheme

This results in the OpenSSL string:

Compatibility:
^^^^^^^^^^^^^^

At the time of this writing only Win 7 and Win 8.1 crypto stack, OpenSSL :math:`\ge` 1.0.1e, Safari 6 / iOS 6.0.1 and Safar 7 / OS X 10.9 are
covered by that cipher string.

Configuration B: Weaker ciphers but better compatibility
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this section we propose a slightly weaker set of cipher suites. For
example, there are known weaknesses for the SHA-1 hash function that is
included in this set. The advantage of this set of cipher suites is not
only better compatibility with a broad range of clients, but also less
computational workload on the provisioning hardware.

| **All examples in this publication use Configuration B**.

We arrived at this set of cipher suites by selecting:

TLS 1.2, TLS 1.1, TLS 1.0

allowing SHA-1 (see the comments on SHA-1 in section [section:SHA])

This results in the OpenSSL string:

Compatibility: 
^^^^^^^^^^^^^^^

Note that these cipher suites will not work with Windows XP’s crypto
stack (e.g. IE, Outlook), We could not verify yet if installing JCE also
fixes the Java 7 DH-parameter length limitation (1024 bit).

Explanation: 
^^^^^^^^^^^^^

For a detailed explanation of the cipher suites chosen, please see
[section:ChoosingYourOwnCipherSuites]. In short, finding a single
perfect cipher string is practically impossible and there must be a
tradeoff between compatibility and security. On the one hand there are
mandatory and optional ciphers defined in a few RFCs, on the other hand
there are clients and servers only implementing subsets of the
specification.

Straight forward, the authors wanted strong ciphers, forward secrecy
 [1]_ and the best client compatibility possible while still ensuring a
cipher string that can be used on legacy installations (e.g. OpenSSL
0.9.8).

Our recommended cipher strings are meant to be used via copy and paste
and need to work “out of the box”.

TLSv1.2 is preferred over TLSv1.0 (while still providing a useable
cipher string for TLSv1.0 servers).

AES256 and CAMELLIA256 count as very strong ciphers at the moment.

AES128 and CAMELLIA128 count as strong ciphers at the moment

DHE or ECDHE for forward secrecy

RSA as this will fit most of today’s setups

AES256-SHA as a last resort: with this cipher at the end, even server
systems with very old OpenSSL versions will work out of the box (version
0.9.8 for example does not provide support for ECC and TLSv1.1 or
above). Note however that this cipher suite will not provide forward
secrecy. It is meant to provide the same client coverage (eg. support
Microsoft crypto libraries) on legacy setups.

.. [1]
   http://nmav.gnutls.org/2011/12/price-to-pay-for-perfect-forward.html
