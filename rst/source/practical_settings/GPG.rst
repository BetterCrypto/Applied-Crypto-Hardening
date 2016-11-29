PGP/GPG - Pretty Good Privacy
=============================


The OpenPGP protocol  [1]_ uses asymmetric encryption to protect a
session key which is used to encrypt a message. Additionally, it signs
messages via asymmetric encryption and hash functions. Research on SHA-1
conducted back in 2005 [2]_ has made clear that collision attacks are a
real threat to the security of the SHA-1 hash function. PGP settings
should be adapted to avoid using SHA-1.

When using PGP, there are a couple of things to take care of:

keylengths (see section [section:keylengths])

randomness (see section [section:RNGs])

preference of symmetric encryption algorithm (see section
[section:CipherSuites])

preference of hash function (see section [section:CipherSuites])

Properly dealing with key material, passphrases and the web-of-trust is
outside of the scope of this document. The GnuPG website [3]_ has a good
tutorial on PGP.

This `Debian
How-to <https://www.debian-administration.org/users/dkg/weblog/48>`__\  [4]_
is a great resource on upgrading your old PGP key as well as on safe
default settings. This section is built based on the Debian How-to.

Hashing
~~~~~~~

Avoid SHA-1 in GnuPG. Edit $HOME/.gnupg/gpg.conf:

Before you generate a new PGP key, make sure there is enough entropy
available (see subsection [subsec:RNG-linux]).

.. [1]
   https://tools.ietf.org/search/rfc4880

.. [2]
   https://www.schneier.com/blog/archives/2005/02/sha1_broken.html

.. [3]
   http://www.gnupg.org/

.. [4]
   https://www.debian-administration.org/users/dkg/weblog/48
