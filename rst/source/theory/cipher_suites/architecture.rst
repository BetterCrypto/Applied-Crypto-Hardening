.. role:: raw-latex(raw)
   :format: latex
..

Architectural overview
----------------------

This section defines some terms which will be used throughout this
guide.

A cipher suite is a standardized collection of key exchange algorithms,
encryption algorithms (ciphers) and Message authentication codes (MAC)
algorithm that provides authenticated encryption schemes. It consists of
the following components:

Key exchange protocol:
    “An (interactive) key exchange protocol is a method whereby parties
    who do not share any secret information can generate a shared,
    secret key by communicating over a public channel. The main property
    guaranteed here is that an eavesdropping adversary who sees all the
    messages sent over the communication line does not learn anything
    about the resulting secret
    key.” :cite:`katz2008introduction`

    Example: ``DHE``

Authentication:
    The client authenticates the server by its certificate. Optionally
    the server may authenticate the client certificate.

    Example: ``RSA``

Cipher:
    The cipher is used to encrypt the message stream. It also contains
    the key size and mode used by the suite.

    Example: ``AES256``

Message authentication code (MAC):
    A MAC ensures that the message has not been tampered with
    (integrity).

    Examples: ``SHA256``

Authenticated Encryption with Associated Data (AEAD):
    AEAD is a class of authenticated encryption block-cipher modes which
    take care of encryption as well as authentication (e.g. GCM, CCM
    mode).

    Example: ``AES256-GCM``

    :raw-latex:`\makebox[\textwidth]{
    \framebox[1.1\width]{ \texttt{DHE} }--\framebox[1.1\width]{ \texttt{RSA} }--\framebox[1.1\width]{ \texttt{AES256} }--\framebox[1.1\width]{ \texttt{SHA256} } }`

.. note::
   A note on nomenclature: there are two common naming schemes for
   cipher strings – IANA names (see appendix :ref:`cha-links`) and the more
   well known OpenSSL names. In this document we will always use OpenSSL names
   unless a specific service uses IANA names.
