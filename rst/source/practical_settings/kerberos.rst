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
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
   entries will cause denial-of-service situations and might endanger
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
as shown in table [table:Kerberos:sub:`e`\ nctypes], a selection of
available etypes is necessary. However, the negotiation process may be
subject to downgrade attacks and weak hashing algorithms endanger
integrity protection and password security. This means that the
des3-cbc-sha1-kd or rc4-hmac algorithms should not be used, except if
there is a concrete and unavoidable need to do so. Other des3-\*, des-\*
and rc4-hmac-exp algorithms should never be used.

Along the lines of cipher string B, the following etypes are
recommended: aes256-cts-hmac-sha1-96 camellia256-cts-cmac
aes128-cts-hmac-sha1-96 camellia128-cts-cmac.

Existing installations
^^^^^^^^^^^^^^^^^^^^^^

The configuration samples below assume new installations without
preexisting principals.

For existing installations:

-  Be aware that for existing setups, the master\_key\_type can not be
   changed easily since it requires a manual conversion of the database.
   When in doubt, leave it as it is.

-  When changing the list of supported\_enctypes, principals where all
   enctypes are no longer supported will cease to work.

-  Be aware that Kerberos 4 is obsolete and should not be used.

-  Principals with weak enctypes pose an increased risk for password
   bruteforce attacks if an attacker gains access to the database.

To get rid of principals with unsupported or weak enctypes, a password
change is usually the easiest way. Service principals can simply be
recreated.

MIT krb5
~~~~~~~~

KDC configuration
^^^^^^^^^^^^^^^^^

In ``/etc/krb5kdc/kdc.conf`` set the following in your realm’s
configuration: In ``/etc/krb5.conf`` set in the [libdefaults] section:
