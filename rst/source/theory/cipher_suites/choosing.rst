Many of the parts in a cipher suite are interchangeable. Like the key
exchange algorithm in this example: ``ECDHE-RSA-AES256-GCM-SHA384`` and
``DHE-RSA-AES256-GCM-SHA384``. To provide a decent level of security,
all algorithms need to be safe (subject to the disclaimer in section
[section:disclaimer]).

Note: There are some very weak cipher suites in every crypto library,
most of them for historic reasons or due to legacy standards. The crypto
export embargo is a good example . For the following chapter support of
these low-security algorithms is disabled by setting ``!EXP:!LOW:!NULL``
as part of the cipher string.

Key Exchange
~~~~~~~~~~~~

Many algorithms allow secure key exchange. Those are , , , , , amongst
others. During the key exchange, keys used for authentication and
symmetric encryption are exchanged. For , and those keys are derived
from the server’s public key.

**Ephemeral Key Exchange** uses different keys for authentication (the
server’s RSA key) and encryption (a randomly created key). This
advantage is called “Forward Secrecy” and means that even recorded
traffic cannot be decrypted later when someone obtains the server key.

All ephemeral key exchange schemes are based on the Diffie-Hellman
algorithm and require pre-generated Diffie-Hellman parameter (which
allow fast ephemeral key generation). It is important to note that the
Diffie-Hellman parameter settings need to reflect at least the security
(speaking in number of bits) as the RSA host key.

**Elliptic Curves** (see section [section:EllipticCurveCryptography])
required by current TLS standards only consist of the so-called
NIST-curves (``secp256r1`` and ``secp384r1``) which may be weak because
the parameters that led to their generation were not properly explained
by the authors . Disabling support for Elliptic Curves leads to no
ephemeral key exchange being available for the Windows platform. When
you decide to use Elliptic Curves despite the uncertainty, make sure to
at least use the stronger curve of the two supported by all clients
(``secp384r1``).

Other key exchange mechanisms like Pre-Shared Key (PSK) are irrelevant
for regular SSL/TLS use.

Authentication
~~~~~~~~~~~~~~

RSA, DSA, DSS, ECDSA, ECDH

During Key Exchange the server proved that he is in control of the
private key associated with a certain public key (the server’s
certificate). The client verifies the server’s identity by comparing the
signature on the certificate and matching it with its trust database.
For details about the trust model of SSL/TLS please see [section:PKIs].

In addition to the server providing its identity, a client might do so
as well. That way mutual trust can be established. Another mechanism
providing client authentication is Secure Remote Password (SRP). All
those mechanisms require special configuration.

Other authentication mechanisms like Pre Shared Keys are not used in
SSL/TLS. Anonymous sessions will not be discussed in this paper.

``!PSK:!aNULL``

Encryption
~~~~~~~~~~

AES, CAMELLIA, SEED, ARIA(?), FORTEZZA(?)...

Other ciphers like IDEA, RC2, RC4, 3DES or DES are weak and therefore
not recommended: ``!DES:!3DES:!RC2:!RC4:!eNULL``

Message authentication
~~~~~~~~~~~~~~~~~~~~~~

SHA-1 (SHA), SHA-2 (SHA256, SHA384), AEAD

Note that SHA-1 is considered broken and should not be used. SHA-1 is
however the only still available message authentication mechanism
supporting TLS1.0/SSLv3. Without SHA-1 most clients will be locked out.

Other hash functions like MD2, MD4 or MD5 are unsafe and broken:
``!MD2:!MD4:!MD5``

Combining cipher strings
~~~~~~~~~~~~~~~~~~~~~~~~
