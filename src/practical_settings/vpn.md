VPNs
====

IPsec
-----

% ciphersuites current 2013-12-09

### Settings

#### Assumptions:

We assume the use of IKE (v1 or v2) and ESP for this document.

#### Authentication:

IPSEC authentication should optimally be performed via RSA signatures,
with a key size of 2048 bits or more. Configuring only the trusted CA
that issued the peer certificate provides for additional protection
against fake certificates.

If you need to use Pre-Shared Key authentication:

1.  Choose a **random**, **long enough** PSK (see below)
2.  Use a **separate** PSK for any IPSEC connection
3.  Change the PSKs regularly

The size of the PSK should not be shorter than the output size of the
hash algorithm used in IKE[^msg00268].

For a key composed of upper- and lowercase letters, numbers, and two
additional symbols[^6bits], the table below gives the minimum
lengths in characters.

| **IKE Hash** | **PSK length (chars)** |
| SHA256       | 43                     |
| SHA384       | 64                     |
| SHA512       | 86                     |

#### Cryptographic Suites:

IPSEC Cryptographic Suites are pre-defined settings for all the items of
a configuration; they try to provide a balanced security level and make
setting up VPNs easier.[^rfc6379]

When using any of those suites, make sure to enable “Perfect Forward
Secrecy“ for Phase 2, as this is not specified in the suites. The
equivalents to the recommended ciphers suites in section
\[section:recommendedciphers\] are shown in table below \[tab:IPSEC\_suites\].

IPSEC Cryptographic Suites:
| **Configuration A** | **Configuration B** | **Notes**
| `Suite-B-GCM-256` | `Suite-B-GCM-128` `VPN-B` | All Suite-B variants use NIST elliptic curves |

#### Phase 1:

Alternatively to the pre-defined cipher suites, you can define your own,
as described in this and the next section.

Phase 1 is the mutual authentication and key exchange phase;
the table below shows the parameters.

Use only “main mode“, as “aggressive mode“ has known security
vulnerabilities [^ikecrack].

| | **Configuration A** | **Configuration B** |
| Mode | Main Mode | Main Mode |
| Encryption | AES-256 & AES, CAMELLIA (-256 or -128) |
| Hash | SHA2-* | SHA2-*, SHA1 |
| DH Group | Group 14-18 & Group 14-18 |
| Lifetime | \todo{need recommendations; 1 day seems to be common practice} |

#### Phase 2:

Phase 2 is where the parameters that protect the actual data are
negotiated; recommended parameters are shown in table below:

| | **Configuration A** | **Configuration B** |
| Perfect Forward Secrecy | yes | yes |
| Encryption | `AES-GCM-16`, `AES-CTR`, `AES-CCM-16`, `AES-256` | `AES-GCM-16`, `AES-CTR`, `AES-CCM-16`, `AES-256`, `CAMELLIA-256`, `AES-128`, `CAMELLIA-128` |
| Hash | SHA2-* (or none for AEAD) | SHA2-*, SHA1 (or none for AEAD) |
| DH Group | Same as Phase 1 | Same as Phase 1 |
| Lifetime | \todo{need recommendations; 1-8 hours is common} |

### References

* “A Cryptographic Evaluation of IPsec”, Niels Ferguson and Bruce
Schneier: <https://www.schneier.com/paper-ipsec.pdf>

Check Point FireWall-1
----------------------

% Attention, only example...
%Checkpoint firewall is a \gls{firewall} that ....

### Tested with Versions

* R77 (should work with any currently supported version)

### Settings

Please see section \[section:IPSECgeneral\] for guidance on parameter
choice. In this section, we will configure a strong setup according to
“Configuration A”.

This is based on the concept of a “VPN Community”, which has all the
settings for the gateways that are included in that community.
Communities can be found in the “IPSEC VPN” tab of SmartDashboard.

![VPN Community encryption properties<span
data-label="fig:checkpoint_1"></span>](img/checkpoint_1.png){width="59.20000%"}

Either choose one of the encryption suites in the properties dialog
(figure \[fig:checkpoint\_1\]), or proceed to “Custom Encryption...”,
where you can set encryption and hash for Phase 1 and 2 (figure
\[fig:checkpoint\_2\]).

![Custom Encryption Suite Properties<span
data-label="fig:checkpoint_2"></span>](img/checkpoint_2.png){width="41.10000%"}

The Diffie-Hellman groups and Perfect Forward Secrecy Settings can be
found under “Advanced Settings” / “Advanced VPN Properties” (figure
\[fig:checkpoint\_3\]).

![Advanced VPN Properties<span
data-label="fig:checkpoint_3"></span>](img/checkpoint_3.png){width="58.90000%"}

### Additional settings

For remote Dynamic IP Gateways, the settings are not taken from the
community, but set in the “Global Properties” dialog under “Remote
Access” / “VPN Authentication and Encryption”. Via the “Edit...” button,
you can configure sets of algorithms that all gateways support (figure
\[fig:checkpoint\_4\]).

![Remote Access Encryption Properties<span
data-label="fig:checkpoint_4"></span>](img/checkpoint_4.png){width="47.40000%"}

Please note that these settings restrict the available algorithms for
**all** gateways, and also influence the VPN client connections.

### References

* Check Point [VPN R77 Administration
Guide](https://sc1.checkpoint.com/documents/R77/CP_R77_VPN_AdminGuide/html_frameset.htm)
(may require a UserCenter account to access)

%% cipherstrings current 2013-12-09

OpenVPN
-------

### Tested with Versions

* OpenVPN 2.3.2 from Debian “wheezy-backports” linked against openssl (libssl.so.1.0.0)
* OpenVPN 2.2.1 from Debian Wheezy linked against openssl (libssl.so.1.0.0)
* OpenVPN 2.3.2 for Windows

### Settings

#### General

We describe a configuration with certificate-based authentication; see
below for details on the `easyrsa` tool to help you with that.

OpenVPN uses TLS only for authentication and key exchange. The bulk
traffic is then encrypted and authenticated with the OpenVPN protocol
using those keys.

Note that while the `tls-cipher` option takes a list of ciphers that is
then negotiated as usual with TLS, the `cipher` and `auth` options both
take a single argument that must match on client and server.

OpenVPN duplexes the tunnel into a data and a control channel. The
control channel is a usual TLS connection, the data channel currently
uses encrypt-then-mac CBC, see
<https://github.com/BetterCrypto/Applied-Crypto-Hardening/pull/91#issuecomment-75365286>

#### Server Configuration

% the cipherlist here is config B without the ECDHE strings, because
% it must fit in 256 bytes...
% DO NOT CHANGE TO THE CIPHERSTRING MACRO!
\configfile{server.conf}{248-250}{Cipher configuration for OpenVPN (Server)}

#### Client Configuration

Client and server have to use compatible configurations, otherwise they
can’t communicate. The `cipher` and `auth` directives have to be
identical.

% the cipherlist here is config B without the ECDHE strings, because
% it must fit in 256 bytes...
% DO NOT CHANGE TO THE CIPHERSTRING MACRO!
\configfile{client.conf}{44-45,115-121}{Cipher and TLS configuration for OpenVPN (Server)}

### Justification for special settings

OpenVPN 2.3.1 changed the values that the `tls-cipher` option expects
from OpenSSL to IANA cipher names. That means from that version on you
will get “Deprecated TLS cipher name” warnings for the configurations
above. You cannot use the selection strings from section
\[section:recommendedciphers\] directly from 2.3.1 on, which is why we
give an explicit cipher list here.

In addition, there is a 256 character limit on configuration file line
lengths; that limits the size of cipher suites, so we dropped all ECDHE
suites.

The configuration shown above is compatible with all tested versions.

### References

OpenVPN Documentation: *Security Overview*
<https://openvpn.net/index.php/open-source/documentation/security-overview.html>

### Additional settings

#### Key renegotiation interval

The default for renegotiation of encryption keys is one hour
(`reneg-sec 3600`). If you transfer huge amounts of data over your
tunnel, you might consider configuring a shorter interval, or switch to
a byte- or packet-based interval (`reneg-bytes` or `reneg-pkts`).

#### Fixing “easy-rsa”

When installing an OpenVPN server instance, you are probably using
*easy-rsa* to generate keys and certificates. The file `vars` in the
easyrsa installation directory has a number of settings that should be
changed to secure values:

\configfile{vars}{53-53,56-56,59-59}{Sane default values for OpenVPN (easy-rsa)}

This will enhance the security of the key generation by using RSA keys
with a length of 4096 bits, and set a lifetime of one year for the
server/client certificates and five years for the CA certificate.
**NOTE: 4096 bits is only an example of how to do this with easy-rsa.**
See also section \[section:keylengths\] for a discussion on keylengths.

In addition, edit the `pkitool` script and replace all occurrences of
`sha1` with `sha256`, to sign the certificates with SHA256.

### Limitations

Note that the ciphersuites shown by `openvpn --show-tls` are *known*,
but not necessarily *supported* [^vpn304].

Which cipher suite is actually used can be seen in the logs:

`Control Channel: TLSv1, cipher TLSv1/SSLv3 DHE-RSA-CAMELLIA256-SHA, 2048 bit RSA`

PPTP
----

PPTP is considered insecure, Microsoft recommends to “use a more secure
VPN tunnel”[^ms2743314].

There is a cloud service that cracks the underlying MS-CHAPv2
authentication protocol for the price of USD 200[^msvchap2], and given the
resulting MD4 hash, all PPTP traffic for a user can be decrypted.

Cisco ASA
---------

The following settings reflect our recommendations as best as possible
on the Cisco ASA platform. These are - of course - just settings
regarding SSL/TLS (i.e. Cisco AnyConnect) and IPsec. For further
security settings regarding this platform the appropriate Cisco guides
should be followed.

### Tested with Versions

9.1(3) - X-series model

### Settings

    crypto ipsec ikev2 ipsec-proposal AES-Fallback
     protocol esp encryption aes-256 aes-192 aes
     protocol esp integrity sha-512 sha-384 sha-256
    crypto ipsec ikev2 ipsec-proposal AES-GCM-Fallback
     protocol esp encryption aes-gcm-256 aes-gcm-192 aes-gcm
     protocol esp integrity sha-512 sha-384 sha-256
    crypto ipsec ikev2 ipsec-proposal AES128-GCM
     protocol esp encryption aes-gcm
     protocol esp integrity sha-512
    crypto ipsec ikev2 ipsec-proposal AES192-GCM
     protocol esp encryption aes-gcm-192
     protocol esp integrity sha-512
    crypto ipsec ikev2 ipsec-proposal AES256-GCM
     protocol esp encryption aes-gcm-256
     protocol esp integrity sha-512
    crypto ipsec ikev2 ipsec-proposal AES
     protocol esp encryption aes
     protocol esp integrity sha-1 md5
    crypto ipsec ikev2 ipsec-proposal AES192
     protocol esp encryption aes-192
     protocol esp integrity sha-1 md5
    crypto ipsec ikev2 ipsec-proposal AES256
     protocol esp encryption aes-256
     protocol esp integrity sha-1 md5
    crypto ipsec ikev2 sa-strength-enforcement
    crypto ipsec security-association pmtu-aging infinite
    crypto dynamic-map SYSTEM_DEFAULT_CRYPTO_MAP 65535 set pfs group14
    crypto dynamic-map SYSTEM_DEFAULT_CRYPTO_MAP 65535 set ikev2 ipsec-proposal AES256-GCM AES192-GCM AES128-GCM AES-GCM-Fallback AES-Fallback
    crypto map Outside-DMZ_map 65535 ipsec-isakmp dynamic SYSTEM_DEFAULT_CRYPTO_MAP
    crypto map Outside-DMZ_map interface Outside-DMZ

    crypto ikev2 policy 1
     encryption aes-gcm-256
     integrity null
     group 14
     prf sha512 sha384 sha256 sha
     lifetime seconds 86400
    crypto ikev2 policy 2
     encryption aes-gcm-256 aes-gcm-192 aes-gcm
     integrity null
     group 14
     prf sha512 sha384 sha256 sha
     lifetime seconds 86400
    crypto ikev2 policy 3
     encryption aes-256 aes-192 aes
     integrity sha512 sha384 sha256
     group 14
     prf sha512 sha384 sha256 sha
     lifetime seconds 86400
    crypto ikev2 policy 4
     encryption aes-256 aes-192 aes
     integrity sha512 sha384 sha256 sha
     group 14
     prf sha512 sha384 sha256 sha
     lifetime seconds 86400
    crypto ikev2 enable Outside-DMZ client-services port 443
    crypto ikev2 remote-access trustpoint ASDM_TrustPoint0

    ssl server-version tlsv1-only
    ssl client-version tlsv1-only
    ssl encryption dhe-aes256-sha1 dhe-aes128-sha1 aes256-sha1 aes128-sha1
    ssl trust-point ASDM_TrustPoint0 Outside-DMZ

### Justification for special settings

New IPsec policies have been defined which do not make use of ciphers
that may be cause for concern. Policies have a “Fallback” option to
support legacy devices.

3DES has been completely disabled as such Windows XP AnyConnect Clients
will no longer be able to connect.

The Cisco ASA platform does not currently support RSA Keys above
2048bits.

Legacy ASA models (e.g. 5505, 5510, 5520, 5540, 5550) do not offer the
possibility to configure for SHA256/SHA384/SHA512 nor AES-GCM for IKEv2
proposals.

### References

<http://www.cisco.com/en/US/docs/security/asa/roadmap/asaroadmap.html>

<http://www.cisco.com/web/about/security/intelligence/nextgen_crypto.html>

Openswan
--------

### Tested with Version

* Openswan 2.6.39 (Gentoo)

### Settings

Note: the available algorithms depend on your kernel configuration (when
using protostack=netkey) and/or build-time options.

To list the supported algorithms

    $ ipsec auto --status | less

and look for ’algorithm ESP/IKE’ at the beginning.

    aggrmode=no
    # ike format: cipher-hash;dhgroup
    # recommended ciphers:
    # - aes
    # recommended hashes:
    # - sha2_256 with at least 43 byte PSK
    # - sha2_512 with at least 86 byte PSK
    # recommended dhgroups:
    # - modp2048 = DH14
    # - modp3072 = DH15
    # - modp4096 = DH16
    # - modp6144 = DH17
    # - modp8192 = DH18
    ike=aes-sha2_256;modp2048
    type=tunnel
    phase2=esp
    # esp format: cipher-hash;dhgroup
    # recommended ciphers configuration A:
    # - aes_gcm_c-256 = AES_GCM_16
    # - aes_ctr-256
    # - aes_ccm_c-256 = AES_CCM_16
    # - aes-256 
    # additional ciphers configuration B:
    # - camellia-256
    # - aes-128
    # - camellia-128
    # recommended hashes configuration A:
    # - sha2-256
    # - sha2-384
    # - sha2-512
    # - null (only with GCM/CCM ciphers)
    # additional hashes configuration B:
    # - sha1
    # recommended dhgroups: same as above
    phase2alg=aes_gcm_c-256-sha2_256;modp2048
    salifetime=8h
    pfs=yes
    auto=ignore

### How to test

Start the vpn and using

    $ ipsec auto --status | less

and look for ’IKE algorithms wanted/found’ and ’ESP algorithms
wanted/loaded’.

### References

%\todo{more specific References??}

* <https://www.openswan.org/>

tinc
----

### Tested with Version

tinc 1.0.23 from Gentoo linked against OpenSSL 1.0.1e

tinc 1.0.23 from Sabayon linked against OpenSSL 1.0.1e

#### Defaults

tinc uses 2048 bit RSA keys, Blowfish-CBC, and SHA1 as default settings
and suggests the usage of CBC mode ciphers. Any key length up to 8196 is
supported and it does not need to be a power of two. OpenSSL Ciphers and
Digests are supported by tinc.

#### Settings

Generate keys with

```
tincd -n NETNAME -K8196
```

Old keys will not be deleted (but disabled), you have to delete them
manually. Add the following lines to your tinc.conf on all machines

#### References

-   tincd(8) man page
-   tinc.conf(5) man page
-   [tinc mailinglist:
    http://www.tinc-vpn.org/pipermail/tinc/2014-January/003538.html](http://www.tinc-vpn.org/pipermail/tinc/2014-January/003538.html)

% ---------------------------------------------------------------------- 
%%\subsection{Juniper VPN}
%%\todo{write this subsubsection. AK: ask Hannes}

% ---------------------------------------------------------------------- 
%\subsection{L2TP over IPSec}
%\todo{write this subsubsection}

% ---------------------------------------------------------------------- 
%\subsection{Racoon}
%\todo{write this subsubsection}

[^msg00268]: It is used in a HMAC, see RFC2104 @rfc2104 and the discussion
    starting in <http://www.vpnc.org/ietf-ipsec/02.ipsec/msg00268.html>.

[^6bits]: 64 possible values = 6 bits

[^rfc6379]: RFC6379 @rfc6379, RFC4308 @rfc4308 TODO

[^ikecrack]: <http://ikecrack.sourceforge.net/>

[^vpn304]: <https://community.openvpn.net/openvpn/ticket/304>

[^ms2743314]: <http://technet.microsoft.com/en-us/security/advisory/2743314>

[^msvchap2]: <https://www.cloudcracker.com/blog/2012/07/29/cracking-ms-chap-v2/>
