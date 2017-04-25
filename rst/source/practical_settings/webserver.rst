:raw-latex:`\def\configfile#1#2#3{}`

Webservers
==========


Apache
------

Note that any cipher suite starting with EECDH can be omitted, if in
doubt. (Compared to the theory section, EECDH in Apache and ECDHE in
OpenSSL are synonyms  [1]_)

Tested with Versions
~~~~~~~~~~~~~~~~~~~~

 *  Apache 2.2.22, Debian Wheezy with OpenSSL 1.0.1e
 *  Apache 2.4.6, Debian Jessie with OpenSSL 1.0.1e
 *  Apache 2.4.10, Debian Jessie 8.2 with OpenSSL 1.0.1k
 *  Apache 2.4.7, Ubuntu 14.04.2 Trusty with Openssl 1.0.1f
 *  Apache 2.4.6, CentOS Linux 7 (Core) with OpenSSL 1.0.1e

Settings
~~~~~~~~

Enabled modules *SSL* and *Headers* are required.

:raw-latex:`\configfile{default-ssl}{42-43,52-52,62-62,162-177}{SSL configuration for an Apache vhost}`

Additional settings
~~~~~~~~~~~~~~~~~~~

You might want to redirect everything to *https://* if possible. In
Apache you can do this with the following setting inside of a
VirtualHost environment:

:raw-latex:`\configfile{hsts-vhost}{}{https auto-redirect vhost}`

References
~~~~~~~~~~

 *  Apache2 Docs on SSL and TLS: \url{https://httpd.apache.org/docs/2.4/ssl/}

How to test
~~~~~~~~~~~

See appendix :ref:`cha-tools`

lighttpd
--------

Tested with Versions
~~~~~~~~~~~~~~~~~~~~

 *  lighttpd/1.4.31-4 with OpenSSL 1.0.1e on Debian Wheezy
 *  lighttpd/1.4.33 with OpenSSL 0.9.8o on Debian Squeeze (note that TLSv1.2 does not work in openssl 0.9.8 thus not all ciphers actually work)
 *  lighttpd/1.4.28-2 with OpenSSL 0.9.8o on Debian Squeeze (note that TLSv1.2 does not work in openssl 0.9.8 thus not all ciphers actually work)
 *  lighttpd/1.4.31, Ubuntu 14.04.2 Trusty with Openssl 1.0.1f

Settings
~~~~~~~~

:raw-latex:`\configfile{10-ssl.conf}{3-15}{SSL configuration for lighttpd}`

Starting with lighttpd version 1.4.29 Diffie-Hellman and Elliptic-Curve
Diffie-Hellman key agreement protocols are supported. By default,
elliptic curve “prime256v1” (also “secp256r1”) will be used, if no other
is given. To select special curves, it is possible to set them using the
configuration options ``ssl.dh-file`` and ``ssl.ec-curve``.

:raw-latex:`\configfile{10-ssl-dh.conf}{11-13}{SSL EC/DH configuration for lighttpd}`

Please read section :ref:`section-DH` for more information
on Diffie Hellman key exchange and elliptic curves.

Additional settings
~~~~~~~~~~~~~~~~~~~

As for any other webserver, you might want to automatically redirect
*http://* traffic toward *https://*. It is also recommended to set the
environment variable *HTTPS*, so the PHP applications run by the
webserver can easily detect that HTTPS is in use.

:raw-latex:`\configfile{11-hsts.conf}{}{https auto-redirect configuration}`

Additional information
~~~~~~~~~~~~~~~~~~~~~~

The config option *honor-cipher-order* is available since 1.4.30, the
supported ciphers depend on the used OpenSSL-version (at runtime). ECDHE
has to be available in OpenSSL at compile-time, which should be default.
SSL compression should by deactivated by default at compile-time (if
not, it’s active).

Support for other SSL-libraries like GnuTLS will be available in the
upcoming 2.x branch, which is currently under development.

References
~~~~~~~~~~

 *  HTTPS redirection: \url{http://redmine.lighttpd.net/projects/1/wiki/HowToRedirectHttpToHttps}
 *  Lighttpd Docs SSL: \url{http://redmine.lighttpd.net/projects/lighttpd/wiki/Docs\_SSL}
 *  Release 1.4.30 (How to mitigate BEAST attack) \url{http://redmine.lighttpd.net/projects/lighttpd/wiki/Release-1\_4\_30}
 *  SSL Compression disabled by default: \url{http://redmine.lighttpd.net/issues/2445}

How to test
~~~~~~~~~~~

See appendix :ref:`cha-tools`

nginx
-----

Tested with Version
~~~~~~~~~~~~~~~~~~~

 *  1.4.4 with OpenSSL 1.0.1e on OS X Server 10.8.5
 *  1.2.1-2.2+wheezy2 with OpenSSL 1.0.1e on Debian Wheezy
 *  1.4.4 with OpenSSL 1.0.1e on Debian Wheezy
 *  1.2.1-2.2~bpo60+2 with OpenSSL 0.9.8o on Debian Squeeze (note that TLSv1.2 does not work in openssl 0.9.8 thus not all ciphers actually work)
 *  1.4.6 with OpenSSL 1.0.1f on Ubuntu 14.04.2 LTS

Settings
~~~~~~~~

:raw-latex:`\configfile{default}{113-118}{SSL settings for nginx}` If
you absolutely want to specify your own DH parameters, you can specify
them via

::

    ssl_dhparam file;

However, we advise you to read section :ref:`section-DH` and
stay with the standard IKE/IETF parameters (as long as they are >1024
bits).

Additional settings
~~~~~~~~~~~~~~~~~~~

If you decide to trust NIST’s ECC curve recommendation, you can add the
following line to nginx’s configuration file to select special curves:

:raw-latex:`\configfile{default-ec}{119-119}{SSL EC/DH settings for nginx}`

You might want to redirect everything to *https://* if possible. In
Nginx you can do this with the following setting:

:raw-latex:`\configfile{default-hsts}{29-29}{https auto-redirect in nginx}`

The variable *$server\_name* refers to the first *server\_name* entry in
your config file. If you specify more than one *server\_name* only the
first will be taken. Please be sure to not use the *$host* variable here
because it contains data controlled by the user.

References
~~~~~~~~~~

 *  http://nginx.org/en/docs/http/ngx_http_ssl_module.html
 *  http://wiki.nginx.org/HttpSslModule

How to test
~~~~~~~~~~~

See appendix :ref:`cha-tools`

Cherokee
--------

Tested with Version
~~~~~~~~~~~~~~~~~~~

   *  Cherokee/1.2.104 on Debian Wheezy with OpenSSL 1.0.1e 11 Feb 2013

Settings
~~~~~~~~

The configuration of the cherokee webserver is performed by an admin
interface available via the web. It then writes the configuration to
``/etc/cherokee/cherokee.conf``, the important lines of such a
configuration file can be found at the end of this section.

- General Settings

  - Network

      :SSL/TLS back-end: OpenSSL/libssl

  - Ports to listen

      :Port: 443
      :TLS: TLS/SSL port

- Virtual Servers, For each vServer on tab *Security*:

  - *Required SSL/TLS Values*: Fill in the correct paths for *Certificate* and *Certificate key*

  - Advanced Options

    :Ciphers:
       ``|cipherStringB|``
    :Server Preference: Prefer
    :Compression: Disabled

- Advanced: TLS

  :SSL version 2 and SSL version 3: No
  :TLS version 1, TLS version 1.1 and TLS version 1.2: Yes
    
Additional settings
~~~~~~~~~~~~~~~~~~~

For each vServer on the Security tab it is possible to set the Diffie
Hellman length to up to 4096 bits. We recommend to use >1024 bits. More
information about Diffie-Hellman and which curves are recommended can be
found in section :ref:`section-DH`.

In Advanced: TLS it is possible to set the path to a Diffie Hellman
parameters file for 512, 1024, 2048 and 4096 bits.

HSTS can be configured on host-basis in section *vServers* / *Security*
/ *HTTP Strict Transport Security (HSTS)*:

:Enable HSTS: Accept
:HSTS Max-Age: 15768000
:Include Subdomains: *depends on your setup*

To redirect HTTP to HTTPS, configure a new rule per Virtual Server in
the *Behavior* tab. The rule is *SSL/TLS* combined with a *NOT*
operator. As *Handler* define *Redirection* and use ``/(.*)$`` as
*Regular Expression* and *https://${host}/$1* as *Substitution*.

:raw-latex:`\configfile{cherokee.conf}{3-4,12-12,17-19,26-32,52-57}{SSL configuration for cherokee}`

References
~~~~~~~~~~

 *  Cookbook: SSL, TLS and certificates: \url{http://cherokee-project.com/doc/cookbook_ssl.html}
 *  Cookbook: Redirecting all traffic from HTTP to HTTPS: \url{http://cherokee-project.com/doc/cookbook_http_to_https.html}

How to test
~~~~~~~~~~~

See appendix :ref:`cha-tools`

MS IIS
------

To configure SSL/TLS on Windows Server IIS Crypto can be used.  [2]_
Simply start the Programm, no installation required. The tool changes
the registry keys described below. A restart is required for the changes
to take effect.

.. figure:: ../img/IISCryptoConfig.png
   :width: 41.1%
   :align: center

   IIS Crypto Tool

Instead of using the IIS Crypto Tool the configuration can be set using
the Windows Registry. The following Registry keys apply to the newer
Versions of Windows (Windows 7, Windows Server 2008, Windows Server 2008
R2, Windows Server 2012 and Windows Server 2012 R2). For detailed
information about the older versions see the Microsoft knowledgebase
article.  [3]_

::

      [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\Schannel]
      [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\Schannel\Ciphers]
      [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\Schannel\CipherSuites]
      [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\Schannel\Hashes]
      [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\Schannel\KeyExchangeAlgorithms]
      [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\Schannel\Protocols]

Tested with Version
~~~~~~~~~~~~~~~~~~~

 *  Windows Server 2008
 *  Windows Server 2008 R2
 *  Windows Server 2012
 *  Windows Server 2012 R2

\

 *  Windows Vista and Internet Explorer 7 and upwards
 *  Windows 7 and Internet Explorer 8 and upwards
 *  Windows 8 and Internet Explorer 10 and upwards
 *  Windows 8.1 and Internet Explorer 11

Settings
~~~~~~~~

When trying to avoid RC4 (RC4 biases) as well as CBC (BEAST-Attack) by
using GCM and to support perfect forward secrecy, Microsoft SChannel
(SSL/TLS, Auth,.. Stack) supports ECDSA but lacks support for RSA
signatures (see ECC suite B doubts [4]_).

Since one is stuck with ECDSA, an elliptic curve certificate needs to be
used.

The configuration of cipher suites MS IIS will use, can be configured in
one of the following ways:

#. Group Policy  [5]_

#. Registry  [6]_

#. IIS Crypto  [7]_

#. Powershell

Table :ref:`tab-MS_IIS_Client_Support` shows the process of
turning on one algorithm after another and the effect on the supported
clients tested using https://www.ssllabs.com.

``SSL 3.0``, ``SSL 2.0`` and ``MD5`` are turned off. ``TLS 1.0`` and
``TLS 1.2`` are turned on.

.. tabularcolumns:: ll
.. _tab-MS_IIS_Client_Support:
.. table:: Client support
   :align: center

   ===========================================  =================================
   Cipher Suite                                 Client
   ===========================================  =================================
   ``TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256``  only IE 10,11, OpenSSL 1.0.1e
   ``TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256``  Chrome 30, Opera 17, Safari 6+
   ``TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA``     FF 10-24, IE 8+, Safari 5, Java 7
   ===========================================  =================================

Table :ref:`tab-MS_IIS_Client_Support` shows the algorithms
from strongest to weakest and why they need to be added in this order.
For example insisting on SHA-2 algorithms (only first two lines) would
eliminate all versions of Firefox, so the last line is needed to support
this browser, but should be placed at the bottom, so capable browsers
will choose the stronger SHA-2 algorithms.

``TLS_RSA_WITH_RC4_128_SHA`` or equivalent should also be added if MS
Terminal Server Connection is used (make sure to use this only in a
trusted environment). This suite will not be used for SSL, since we do
not use a RSA Key.

Clients not supported:

#. Java 6

#. WinXP

#. Bing

Additional settings
~~~~~~~~~~~~~~~~~~~

It’s recommended to use Strict-Transport-Security: max-age=15768000 for
detailed information visit the  [8]_ Microsoft knowledgebase.

You might want to redirect everything to http\ **s**:// if possible. In
IIS you can do this with the following setting by Powershell:

::

    Set-WebConfiguration -Location "$WebSiteName/$WebApplicationName" `
        -Filter 'system.webserver/security/access' `
        -Value "SslRequireCert"

Justification for special settings (if needed)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

References
~~~~~~~~~~

 * http://support.microsoft.com/kb/245030/en-us
 * http://support.microsoft.com/kb/187498/en-us

How to test
~~~~~~~~~~~

See appendix :ref:`cha-tools`

.. [1]
   https://www.mail-archive.com/openssl-dev@openssl.org/msg33405.html

.. [2]
   https://www.nartac.com/Products/IISCrypto/

.. [3]
   http://support.microsoft.com/kb/245030/en-us

.. [4]
   http://safecurves.cr.yp.to/rigid.html

.. [5]
   http://msdn.microsoft.com/en-us/library/windows/desktop/bb870930(v=vs.85).aspx

.. [6]
   http://support.microsoft.com/kb/245030

.. [7]
   https://www.nartac.com/Products/IISCrypto/

.. [8]
   http://www.iis.net/configreference/system.webserver/httpprotocol/customheaders
