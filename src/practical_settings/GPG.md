PGP/GPG - Pretty Good Privacy
=============================

The OpenPGP protocol [^rfc4880] uses asymmetric encryption to protect a
session key which is used to encrypt a message. Additionally, it signs
messages via asymmetric encryption and hash functions. Research on SHA-1
conducted back in 2005[^schneiersha1] has made clear that collision attacks are a
real threat to the security of the SHA-1 hash function. PGP settings
should be adapted to avoid using SHA-1.

When using PGP, there are a couple of things to take care of:

* keylengths (see section \[section:keylengths\]) TODO
* randomness (see section \[section:RNGs\]) TODO
* preference of symmetric encryption algorithm (see section
  \[section:CipherSuites\]) TODO
* preference of hash function (see section \[section:CipherSuites\]) TODO

Properly dealing with key material, passphrases and the web-of-trust is
outside of the scope of this document. The GnuPG website[^gnupg] has a good
tutorial on PGP.

This [Debian
How-to](https://www.debian-administration.org/users/dkg/weblog/48)[^dkgsha1]
is a great resource on upgrading your old PGP key as well as on safe
default settings. This section is built based on the Debian How-to.

### Hashing

Avoid SHA-1 in GnuPG. Edit `$HOME/.gnupg/gpg.conf`:

Before you generate a new PGP key, make sure there is enough entropy
available (see subsection \[subsec:RNG-linux\]).

%\subsubsection{PGP / GPG Operations}

%% Ciphering - Unciphering operations
%%% TOO COMPLEX. Make a pointer to a good GPG tutorial

%% Signing / checking signatures
%%% TOO COMPLEX. Make a pointer to a good GPG tutorial

%\subsubsection{Trusted Keys}

%%Explain that a key by himself is not trustable.  Chain of trust principle.

%%% TOO COMPLEX. Make a pointer to a good GPG tutorial

%\subsection{Available implementations and mails plugins}

%% Microsoft Windows (Symantec for Outlook? GnuPG + ....)
%%% TOO COMPLEX. Make a pointer to a good GPG tutorial

%% Linux (GnuPG + Enigmail for Thunderbird)

%%% TOO COMPLEX. Make a pointer to a good GPG tutorial
%% Mac OS X (GnuPG + GPGMail)
%%% TOO COMPLEX. Make a pointer to a good GPG tutorial

[^rfc4880]: <https://tools.ietf.org/search/rfc4880>

[^schneiersha1]: <https://www.schneier.com/blog/archives/2005/02/sha1_broken.html>

[^gnupg]: <http://www.gnupg.org/>

[^dkgsha1]: <https://www.debian-administration.org/users/dkg/weblog/48>
