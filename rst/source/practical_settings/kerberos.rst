.. role:: raw-latex(raw)
   :format: latex
..

Kerberos
========

This section discusses various implementations of the Kerberos 5
authentication protocol on Unix and Unix-like systems as well as on
Microsoft Windows.

Overview
--------

Kerberos provides mutual authentication of two communicating parties,
e.g. a user using a network service. The authentication process is
mediated by a trusted third party, the Kerberos key distribution centre
(KDC). Kerberos implements secure single-sign-on across a large number
of network protocols and operating systems. Optionally, Kerberos can be
used to create encrypted communications channels between the user and
service.

Recommended reading
^^^^^^^^^^^^^^^^^^^

An understanding of the Kerberos protocol is necessary for properly
implementing a Kerberos setup. Also, in the following section some
knowledge about the inner workings of Kerberos is assumed. Therefore we
strongly recommend reading this excellent introduction first:
http://gost.isi.edu/publications/kerberos-neuman-tso.html. No further
overview over Kerberos terminology and functions will be provided, for a
discussion and a selection of relevant papers refer to
http://web.mit.edu/kerberos/papers.html.

The Kerberos protocol over time has been extended with a variety of
extensions and Kerberos implementations provide additional services in
addition to the aforementioned KDC. All discussed implementations
provide support for trust relations between multiple realms, an
administrative network service (kerberos-adm, kadmind) as well as a
password changing service (kpasswd). Sometimes, alternative database
backends for ticket storage, X.509 and SmartCard authentication are
provided. Of those, only administrative and password changing services
will be discussed.

Only the Kerberos 5 protocol and implementation will be discussed.
Kerberos 4 is obsolete, insecure and its use is strongly discouraged.

Providing a suitable Setup for secure Kerberos Operations
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The aim of Kerberos is to unify authentication across a wide range of
services, for many different users and use cases and on many computer
platforms. The resulting complexity and attack surface make it necessary
to carefully plan and continuously evaluate the security of the overall
ecosystem in which Kerberos is deployed. Several assumptions are made on
which the security of a Kerberos infrastructure relies:

-  Every KDC in a realm needs to be trustworthy. The KDC’s principal
   database must not become known to or changed by an attacker. The
   contents of the principal database enables the attacker to
   impersonate any user or service in the realm.

-  Synchronisation between KDCs must be secure, reliable and frequent.
   An attacker that is able to intercept or influence synchronisation
   messages obtains or influences parts of the principal database,
   enabling impersonation of affected principals. Unreliable or
   infrequent synchronisation enlarges the window of vulnerability after
   disabling principals or changing passwords that have been compromised
   or lost.

-  KDCs must be available. An attacker is able to inhibit authentication
   for services and users by cutting off their access to a KDC.

-  Users’ passwords must be secure. Since Kerberos is a single-sign-on
   mechanism, a single password may enable an attacker to access a large
   number of services.

-  Service keytabs need to be secured against unauthorized access
   similarly to SSL/TLS server certificates. Obtaining a service keytab
   enables an attacker to impersonate a service.

-  DNS infrastructure must be secure and reliable. Hosts that provide
   services need consistent forward and reverse DNS entries. The
   identity of a service is tied to its DNS name, similarly the realm a
   client belongs to as well as the KDC, kpasswd and kerberos-adm
   servers may be specified in DNS TXT and SRV records. Spoofed DNS
   entries will cause denial-of-service situations and might
   endanger:cite:`MITKrbDoc:realm_config,IETF:cat-krb-dns-locate-02`
   the security of a Kerberos realm.

-  Clients and servers in Kerberos realms need to have synchronized
   clocks. Tickets in Kerberos are created with a limited, strictly
   enforced lifetime. This limits an attacker’s window of opportunity
   for various attacks such as the decryption of tickets in sniffed
   network traffic or the use of tickets read from a client computer’s
   memory. Kerberos will refuse tickets with old timestamps or
   timestamps in the future. This would enable an attacker with access
   to a systems clock to deny access to a service or all users logging
   in from a specific host.

Therefore we suggest:

-  Secure all KDCs at least as strongly as the most secure service in
   the realm.

-  Dedicate physical (i.e. non-VM) machines to be KDCs. Do not run any
   services on those machines beyond the necessary KDC, kerberos-adm,
   kpasswd and kprop services.

-  Restrict physical and administrative access to the KDCs as severely
   as possible. E.g. ssh access should be limited to responsible
   adminstrators and trusted networks.

-  Encrypt and secure the KDCs backups.

-  Replicate your primary KDC to at least one secondary KDC.

-  Prefer easy-to-secure replication (propagation in Kerberos terms)
   methods.Especially avoid LDAP replication and database backends. LDAP
   enlarges the attack surface of your KDC and facilitates unauthorized
   access to the principal database e.g. by ACL misconfiguration.

-  Use DNSSEC. If that is not possible, at least ensure that all servers
   and clients in a realm use a trustworthy DNS server contacted via
   secure network links.

-  Use NTP on a trustworthy server via secure network links.

-  Avoid services that require the user to enter a password which is
   then checked against Kerberos. Prefer services that are able to use
   authentication via service tickets, usually not requiring the user to
   enter a password except for the initial computer login to obtain a
   ticket-granting-ticket (TGT). This limits the ability of attackers to
   spy out passwords through compromised services.

Implementations
---------------

Cryptographic Algorithms in Kerberos Implementations
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The encryption algorithms (commonly abbreviated ’etypes’ or ’enctypes’)
in Kerberos exchanges are subject to negotiation between both sides of
an exchange. Similarly, a ticket granting ticket (TGT), which is usually
obtained on initial login, can only be issued if the principal contains
a version of the password encrypted with an etype that is available both
on the KDC and on the client where the login happens. Therefore, to
ensure interoperability among components using different implementations
as shown in table :ref:`table-Kerberos_enctypes`, a
selection of available etypes is necessary. However, the negotiation
process may be subject to downgrade
attacks:cite:`AttKerbDepl` and weak hashing algorithms
endanger integrity protection and password security. This means that the
des3-cbc-sha1-kd or rc4-hmac algorithms should not be used, except if
there is a concrete and unavoidable need to do so. Other des3-\*, des-\*
and rc4-hmac-exp algorithms should never be used.

Along the lines of cipher string B, the following etypes are
recommended: aes256-cts-hmac-sha1-96 camellia256-cts-cmac
aes128-cts-hmac-sha1-96 camellia128-cts-cmac.

.. _tab-Kerberos_enctypes:
.. tabularcolumns:: rl|llll
.. table:: Commonly supported Kerberos encryption types by implementation.
           Algorithm names according to :rfc:`3961`, except where aliases can be
           used or the algorithm is named differently altogether as
           stated~\cite{,krb519,JavaJGSS,ShishiEnctypes}.
           See also :rfc:`3962`, :rfc:`6803`, :rfc:`3961`, :rfc:`4120`, :rfc:`4120`.
   :align: center

   ==  =======================  =======  ========  ==========  ==================
   ID  Algorithm                MIT      Heimdal   GNU Shishi  MS ActiveDirectory
   ==  =======================  =======  ========  ==========  ==================
    1  des-cbc-crc              ✓        ✓         ✓           ✓
    2  des-cbc-md4              ✓        ✓         ✓           ✗
    3  des-cbc-md5              ✓        ✓         ✓           ✓
    6  des3-cbc-none            ✗        ✓         ✓           ✗
    7  des3-cbc-sha1            ✗        ✓ [#a]_   ✗           ✗
   16  des3-cbc-sha1-kd         ✓ [#b]_  ✓ [#c]_   ✓           ✗
   17  aes128-cts-hmac-sha1-96  ✓        ✓         ✓           ✓ [#d]_
   18  aes256-cts-hmac-sha1-96  ✓        ✓         ✓           ✓ [#e]_       
   23  rc4-hmac                 ✓        ✓         ✓           ✓
   24  rc4-hmac-exp             ✓        ✗         ✓           ✓
   25  camellia128-cts-cmac     ✓ [#f]_  ✗         ✗           ✗
   26  camellia256-cts-cmac     ✓ [#f]_  ✗         ✗           ✗
   ==  =======================  =======  ========  ==========  ==================

.. [#a] named old-des3-cbc-sha1.
.. [#b] alias des3-cbc-sha1, des3-hmac-sha1.
.. [#c] named des3-cbc-sha1.
.. [#d] since Vista, Server 2008.
.. [#e] since 7, Server 2008R2.
.. [#f] since 1.9.

Existing installations
^^^^^^^^^^^^^^^^^^^^^^

The configuration samples below assume new installations without
preexisting principals.

For existing installations:

-  Existing setups should be migrated to a new master key if the current
   master key is using a weak enctype.

-  When changing the list of supported\_enctypes, principals where all
   enctypes are no longer supported will cease to work.

-  Be aware that Kerberos 4 is obsolete and should not be used.

-  Principals with weak enctypes pose an increased risk for password
   bruteforce attacks if an attacker gains access to the database.

To get rid of principals with unsupported or weak enctypes, a password
change is usually the easiest way. Service principals can simply be
recreated.

..
   % XXX ask the author XXX
   %\todo{force password change for old enctypes howto?}

MIT krb5
~~~~~~~~

KDC configuration
^^^^^^^^^^^^^^^^^

In ``/etc/krb5kdc/kdc.conf`` set the following in your realm’s
configuration:
:raw-latex:`\configfile{kdc.conf}{14-15}{Encryption flags for MIT krb5 KDC}`

..   % XXX ask the author XXX
.. todo{TODO: recommendations for lifetime, proxiable, forwardable}


In ``/etc/krb5.conf`` set in the [libdefaults] section:

:raw-latex:`\configfile{krb5.conf}{1-1,22-25}{Encryption flags for MIT krb5 client}`

..
   XXX ask the author XXX
    \todo{verify MIT client config}

   Heimdal Kerberos 5
   ``````````````````

    XXX ask the author XXX
   \todo{research and write Heimdal Kerberos section}

    In \verb#/etc/krb5.conf# set in the \[libdefaults\] section:
    \begin{lstlisting}[breaklines]
   [libdefaults] 
           default\_etypes= aes256-cts-hmac-sha1-96 camellia256-cts-cmac aes128-cts-hmac-sha1-96 camellia128-cts-cmac
           default\_as\_etypes= aes256-cts-hmac-sha1-96 camellia256-cts-cmac aes128-cts-hmac-sha1-96 camellia128-cts-cmac
           default\_tgs\_etypes= aes256-cts-hmac-sha1-96 camellia256-cts-cmac aes128-cts-hmac-sha1-96 camellia128-cts-cmac
    \end{lstlisting}

   GNU Shishi
   ````````````````````````````````````````````
   \todo{research and write GNU Shishi section}

   Microsoft ActiveDirectory
   ``````````````````````````
   \todo{research and write MS AD section}

    encryption type setting for a user account: http://blogs.msdn.com/b/openspecification/archive/2011/05/31/windows-configurations-for-kerberos-supported-encryption-type.aspx
    hunting down DES: http://blogs.technet.com/b/askds/archive/2010/10/19/hunting-down-des-in-order-to-securely-deploy-kerberos.aspx
    supported subset of encryption types, extension documentation: http://msdn.microsoft.com/en-us/library/cc233855.aspx

Upgrading a MIT krb5 database to a new enctype
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To check if an upgrade is necessary, execute the following on the KDC in
question:

::

    root@kdc.example.com:~# kdb5_util list_mkeys
    Master keys for Principal: K/M@EXAMPLE.COM
    KVNO: 1, Enctype: des-cbc-crc, Active on: Thu Jan 01 00:00:00 UTC 1970 *

In this case, an old unsafe enctype is in use as indicated by the star
following the key line. To upgrade, proceed as follows. First create a
new master key for the database with the appropriate enctype. You will
be prompted for a master password that can later be used to decrypt the
database. A stash-file containing this encryption key will also be
written.

::

    root@kdc.example.com:~# kdb5_util add_mkey -s -e aes256-cts-hmac-sha1-96
    Creating new master key for master key principal 'K/M@EXAMPLE.COM'
    You will be prompted for a new database Master Password.
    It is important that you NOT FORGET this password.
    Enter KDC database master key:
    Re-enter KDC database master key to verify:

Verify that the new master key has been successfully created. Note the
key version number (KVNO) of the new master key, in this case ``2``.

::

    root@kdc.example.com:~# kdb5_util list_mkeys
    Master keys for Principal: K/M@EXAMPLE.COM
    KVNO: 2, Enctype: aes256-cts-hmac-sha1-96, No activate time set
    KVNO: 1, Enctype: des-cbc-crc, Active on: Thu Jan 01 00:00:00 UTC 1970 *

Set the new master key as the active master key by giving its KVNO. The
active master key will be indicated by an asterisk in the master key
list.

::

    root@kdc.example.com:~# kdb5_util use_mkey 2
    root@kdc.example.com:~# kdb5_util list_mkeys
    Master keys for Principal: K/M@EXAMPLE.COM
    KVNO: 2, Enctype: aes256-cts-hmac-sha1-96, Active on: Wed May 13 14:14:18 UTC 2015 *
    KVNO: 1, Enctype: des-cbc-crc, Active on: Thu Jan 01 00:00:00 UTC 1970

Reencrypt all principals to the new master key.

::

    root@kdc.example.com:~# kdb5_util update_princ_encryption
    Re-encrypt all keys not using master key vno 2?
    (type 'yes' to confirm)? yes
    504 principals processed: 504 updated, 0 already current

After verifying that everything still works as desired it is possible to
remove unused master keys.

::

    root@kdc.example.com:~# kdb5_util purge_mkeys
    Will purge all unused master keys stored in the 'K/M@EXAMPLE.COM' principal, are you sure?
    (type 'yes' to confirm)? yes
    OK, purging unused master keys from 'K/M@EXAMPLE.COM'...
    Purging the following master key(s) from K/M@EXAMPLE.COM:
    KVNO: 1
    1 key(s) purged.
