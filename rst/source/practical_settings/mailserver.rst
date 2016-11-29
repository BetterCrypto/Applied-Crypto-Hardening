Mail Servers
============


This section documents the most common mail (SMTP) and IMAPs/POPs
servers. Another option to secure IMAPs/POPs servers is to place them
behind an stunnel server.

SMTP in general
---------------

SMTP usually makes use of opportunistic TLS. This means that an MTA will
accept TLS connections when asked for it during handshake but will not
require it. One should always support incoming opportunistic TLS and
always try TLS handshake outgoing.

Furthermore a mailserver can operate in three modes:

As MSA (Mail Submission Agent) your mailserver receives mail from your
clients MUAs (Mail User Agent).

As receiving MTA (Mail Transmission Agent, MX)

As sending MTA (SMTP client)

We recommend the following basic setup for all modes:

correctly setup MX, A and PTR RRs without using CNAMEs at all.

enable encryption (opportunistic TLS)

do not use self signed certificates

For SMTP client mode we additionally recommend:

the hostname used as HELO must match the PTR RR

setup a client certificate (most server certificates are client
certificates as well)

either the common name or at least an alternate subject name of your
certificate must match the PTR RR

do not modify the cipher suite for client mode

For MSA operation we recommend:

listen on submission port 587

enforce SMTP AUTH even for local networks

do not allow SMTP AUTH on unencrypted connections

optionally use the recommended cipher suites if (and only if) all your
connecting MUAs support them

We strongly recommend to allow all cipher suites for anything but MSA
mode, because the alternative is plain text transmission.

Dovecot
-------

Tested with Version
~~~~~~~~~~~~~~~~~~~

Dovecot 2.1.7, Debian Wheezy (without “ssl\_prefer\_server\_ciphers”
setting)

Dovecot 2.2.9, Debian Jessie

2.0.19apple1 on OS X Server 10.8.5 (without
“ssl\_prefer\_server\_ciphers” setting)

Settings
~~~~~~~~

Additional info
~~~~~~~~~~~~~~~

Dovecot 2.0, 2.1: Almost as good as dovecot 2.2. Dovecot does not ignore
unknown configuration parameters. Does not support
ssl\_prefer\_server\_ciphers

Limitations
~~~~~~~~~~~

Dovecot currently does not support disabling TLS compression.
Furthermore, DH parameters greater than 1024bit are not supported. The
most recent version 2.2.7 of Dovecot implements configurable DH
parameter length  [1]_.

References
~~~~~~~~~~

http://wiki2.dovecot.org/SSL

How to test
~~~~~~~~~~~

::

    openssl s_client -crlf -connect SERVER.TLD:993

cyrus-imapd
-----------

Tested with Versions
~~~~~~~~~~~~~~~~~~~~

2.4.17

Settings
~~~~~~~~

To activate SSL/TLS configure your certificate with

Do not forget to add necessary intermediate certificates to the .pem
file.

Limiting the ciphers provided may force (especially older) clients to
connect without encryption at all! Sticking to the defaults is
recommended.

If you still want to force strong encryption use

cyrus-imapd loads hardcoded 1024 bit DH parameters using
get\_rfc2409\_prime\_1024() by default. If you want to load your own DH
parameters add them PEM encoded to the certificate file given in
tls\_cert\_file. Do not forget to re-add them after updating your
certificate.

To prevent unencrypted connections on the STARTTLS ports you can set
This way MUAs can only authenticate with plain text authentication
schemes after issuing the STARTTLS command. Providing CRAM-MD5 or
DIGEST-MD5 methods is not recommended.

To support POP3/IMAP on ports 110/143 with STARTTLS and POP3S/IMAPS on
ports 995/993 check the SERVICES section in ``cyrus.conf``

Limitations
~~~~~~~~~~~

cyrus-imapd currently (2.4.17, trunk) does not support elliptic curve
cryptography. Hence, ECDHE will not work even if defined in your cipher
list.

Currently there is no way to prefer server ciphers or to disable
compression.

There is a working patch for all three features:
https://bugzilla.cyrusimap.org/show_bug.cgi?id=3823

How to test
~~~~~~~~~~~

::

    openssl s_client -crlf -connect SERVER.TLD:993

Postfix
-------

Tested with Versions
~~~~~~~~~~~~~~~~~~~~

Postfix 2.9.6, Debian Wheezy

Settings
~~~~~~~~

MX and SMTP client configuration:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

As discussed in section [subsection:smtp:sub:`g`\ eneral], because of
opportunistic encryption we do not restrict the list of ciphers. There
are still some steps needed to enable TLS, all in ``main.cf``:

MSA:
^^^^

For the MSA ``smtpd`` process, we first define the ciphers that are
acceptable for the “mandatory” security level, again in ``main.cf``:

Then, we configure the MSA smtpd in ``master.cf`` with two additional
options that are only used for this instance of smtpd:

For those users who want to use EECDH key exchange, it is possible to
customize this via: The default value since Postfix 2.8 is “strong”.

Limitations
~~~~~~~~~~~

tls\_ssl\_options is supported from Postfix 2.11 onwards. You can leave
the statement in the configuration for older versions, it will be
ignored.

tls\_preempt\_cipherlist is supported from Postfix 2.8 onwards. Again,
you can leave the statement in for older versions.

References
~~~~~~~~~~

Refer to http://www.postfix.org/TLS_README.html for an in-depth
discussion.

Additional settings
~~~~~~~~~~~~~~~~~~~

Postfix has two sets of built-in DH parameters that can be overridden
with the ``smtpd_tls_dh512_param_file`` and
``smtpd_tls_dh1024_param_file`` options. The “dh512” parameters are used
for export ciphers, while the “dh1024” ones are used for all other
ciphers.

The “bit length” in those parameter names is just a name, so one could
use stronger parameter sets; it should be possible to e.g. use the IKE
Group14 parameters (see section [section:DH]) without much
interoperability risk, but we have not tested this yet.

How to test
~~~~~~~~~~~

You can check the effect of the settings with the following command:

::

    $ zegrep "TLS connection established from.*with cipher" /var/log/mail.log | awk '{printf("%s %s %s %s\n", $12, $13, $14, $15)}' | sort | uniq -c | sort -n
          1 SSLv3 with cipher DHE-RSA-AES256-SHA
         23 TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384
         60 TLSv1 with cipher ECDHE-RSA-AES256-SHA
        270 TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384
        335 TLSv1 with cipher DHE-RSA-AES256-SHA

::

    openssl s_client -starttls smtp -crlf -connect SERVER.TLD:25

Exim
----

Tested with Versions
~~~~~~~~~~~~~~~~~~~~

Exim 4.82, Debian Jessie

It is highly recommended to read
http://exim.org/exim-html-current/doc/html/spec_html/ch-encrypted_smtp_connections_using_tlsssl.html
first.

MSA mode (submission):
^^^^^^^^^^^^^^^^^^^^^^

In the main config section of Exim add: Don’t forget to add intermediate
certificates to the .pem file if needed.

Tell Exim to advertise STARTTLS in the EHLO answer to everyone:

If you want to support legacy SMTPS on port 465, and STARTTLS on
smtp(25)/submission(587) ports set

It is highly recommended to limit SMTP AUTH to SSL connections only. To
do so add to every authenticator defined.

Add the following rules on top of your acl\_smtp\_mail: This switches
Exim to submission mode and allows addition of missing “Message-ID” and
“Date” headers.

It is not advisable to restrict the default cipher list for MSA mode if
you don’t know all connecting MUAs. If you still want to define one
please consult the Exim documentation or ask on the exim-users
mailinglist. The cipher used is written to the logfiles by default. You
may want to add

::

    log_selector = <whatever your log_selector already contains> +tls_certificate_verified +tls_peerdn +tls_sni

to get even more TLS information logged.

Server mode (incoming):
^^^^^^^^^^^^^^^^^^^^^^^

In the main config section of Exim add: don’t forget to add intermediate
certificates to the .pem file if needed.

Tell Exim to advertise STARTTLS in the EHLO answer to everyone:

Listen on smtp(25) port only

It is not advisable to restrict the default cipher list for
opportunistic encryption as used by SMTP. Do not use cipher lists
recommended for HTTPS! If you still want to define one please consult
the Exim documentation or ask on the exim-users mailinglist. If you want
to request and verify client certificates from sending hosts set

tls\_try\_verify\_hosts only reports the result to your logfile. If you
want to disconnect such clients you have to use

::

    tls_verify_hosts = *

The cipher used is written to the logfiles by default. You may want to
add

::

    log_selector = <whatever your log_selector already contains> +tls_certificate_verified +tls_peerdn +tls_sni

to get even more TLS information logged.

Client mode (outgoing):
^^^^^^^^^^^^^^^^^^^^^^^

Exim uses opportunistic encryption in the SMTP transport by default.

Client mode settings have to be done in the configuration section of the
smtp transport (driver = smtp).

If you want to use a client certificate (most server certificates can be
used as client certificate, too) set This is recommended for MTA-MTA
traffic.

Do not limit ciphers without a very good reason. In the worst case you
end up without encryption at all instead of some weak encryption. Please
consult the Exim documentation if you really need to define ciphers.

OpenSSL:
^^^^^^^^

Exim already disables SSLv2 by default. We recommend to add

::

    openssl_options = +all +no_sslv2 +no_compression +cipher_server_preference

to the main configuration.

Note: +all is misleading here since OpenSSL only activates the most
common workarounds. But that’s how SSL\_OP\_ALL is defined.

You do not need to set dh\_parameters. Exim with OpenSSL by default uses
parameter initialization with the “2048-bit MODP Group with 224-bit
Prime Order Subgroup” defined in section 2.2 of RFC 5114  (ike23). If
you want to set your own DH parameters please read the TLS documentation
of exim.

GnuTLS:
^^^^^^^

GnuTLS is different in only some respects to OpenSSL:

tls\_require\_ciphers needs a GnuTLS priority string instead of a cipher
list. It is recommended to use the defaults by not defining this option.
It highly depends on the version of GnuTLS used. Therefore it is not
advisable to change the defaults.

There is no option like openssl\_options

Exim string expansion:
^^^^^^^^^^^^^^^^^^^^^^

Note that most of the options accept expansion strings. This way you can
e.g. set cipher lists or STARTTLS advertisement conditionally. Please
follow the link to the official Exim documentation to get more
information.

Limitations:
^^^^^^^^^^^^

Exim currently (4.82) does not support elliptic curves with OpenSSL.
This means that ECDHE is not used even if defined in your cipher list.
There already is a working patch to provide support:
http://bugs.exim.org/show_bug.cgi?id=1397

How to test
~~~~~~~~~~~

::

    openssl s_client -starttls smtp -crlf -connect SERVER.TLD:25

.. [1]
   http://hg.dovecot.org/dovecot-2.2/rev/43ab5abeb8f0
