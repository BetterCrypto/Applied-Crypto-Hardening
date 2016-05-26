Intercepting proxy solutions and reverse proxies
================================================

Within enterprise networks and corporations with increased levels of
paranoia or at least some defined security requirements it is common
**not** to allow direct connections to the public internet.

For this reason proxy solutions are deployed on corporate networks to
intercept and scan the traffic for potential threats within sessions.

For encrypted traffic there are four options:

Block the connection because it cannot be scanned for threats.

Bypass the threat-mitigation and pass the encrypted session to the
client, which results in a situation where malicious content is
transferred directly to the client without visibility to the security
system.

Intercept (i.e. terminate) the session at the proxy, scan there and
re-encrypt the session towards the client (effectively MITM).

Deploy special Certificate Authorities to enable Deep Packet Inspection
on the wire.

While the latest solution might be the most “up to date”, it arises a
new front in the context of this paper, because the most secure part of
a client’s connection could only be within the corporate network, if the
proxy-server handles the connection to the destination server in an
insecure manner.

Conclusion: Don’t forget to check your proxy solutions SSL-capabilities.
Also do so for your reverse proxies!

%% ---------------------------------------------------------------------- 
% who was the author of this section?
% can we have this either tested or removed?
%\subsection{Squid}
%As of squid-3.2.7 (01 Feb 2013) there is support for the OpenSSL NO\_Compression option within squid config (CRIME attack) and if you combine that in the config file, with an enforcement of the server cipher preferences (BEAST Attack) you are safe.
%
%
%\todo{UNTESTED!}
%\configfile{squid.conf}{1363-1363,1379-1379}{Cipher selection and SSL options in Squid}
%%% http://forum.pfsense.org/index.php?topic=63262.0
%%\todo{UNTESTED!}
%% see squid.conf, repeating the options here does not help.
%\todo{Patch here? Definitely working for 3.2.6!}
%For squid Versions before 3.2.7 use this patch against a vanilla source-tree:
%\begin{lstlisting}
%--- support.cc.ini      2013-01-09 02:41:51.000000000 +0100
%+++ support.cc  2013-01-21 16:13:32.549383848 +0100
%@@ -400,6 +400,11 @@
%         "NO_TLSv1_2", SSL_OP_NO_TLSv1_2
%     },
% #endif
%+#ifdef SSL_OP_NO_COMPRESSION
%+    {
%+        "NO_Compression", SSL_OP_NO_COMPRESSION
%+    },
%+#endif
%     {
%         "", 0
%     },
%\end{lstlisting}

Bluecoat
--------

%% https://kb.bluecoat.com/index?page=content&id=KB5549

### Tested with Versions

* SGOS 6.5.x

BlueCoat Proxy SG Appliances can be used as forward and reverse proxies.
The reverse proxy feature is rather under-developed, and while it is
possible and supported, there only seems to be limited use of this
feature “in the wild” - nonetheless there are a few cipher suites to
choose from, when enabling SSL features.

### Settings

Only allow TLS 1.0,1.1 and 1.2 protocols:

    $conf t
    $(config)ssl
    $(config ssl)edit ssl-device-profile default
    $(config device-profile default)protocol tlsv1 tlsv1.1 tlsv1.2
      ok

Select your accepted cipher-suites:

    $conf t
    Enter configuration commands, one per line.  End with CTRL-Z.
    $(config)proxy-services
    $(config proxy-services)edit ReverseProxyHighCipher
    $(config ReverseProxyHighCipher)attribute cipher-suite
    Cipher#  Use        Description        Strength
    -------  ---  -----------------------  --------
          1  yes            AES128-SHA256      High
          2  yes            AES256-SHA256      High
          3  yes               AES128-SHA    Medium
          4  yes               AES256-SHA      High
          5  yes       DHE-RSA-AES128-SHA      High
          6  yes       DHE-RSA-AES256-SHA      High
                   [...]
         13  yes          EXP-RC2-CBC-MD5    Export

    Select cipher numbers to use, separated by commas: 2,5,6
      ok

The same protocols are available for forward proxy settings and should
be adjusted accordingly: In your local policy file add the following
section:

    <ssl>
        DENY server.connection.negotiated_ssl_version=(SSLV2, SSLV3)

Disabling protocols and ciphers in a forward proxy environment could
lead to unexpected results on certain (misconfigured?) webservers (i.e.
ones accepting only SSLv2/3 protocol connections)

HAProxy
-------

% See http://www.haproxy.org/
% See https://timtaubert.de/blog/2014/11/the-sad-state-of-server-side-tls-session-resumption-implementations/
% See http://cbonte.github.io/haproxy-dconv/configuration-1.5.html#5.1-npn
% See http://cbonte.github.io/haproxy-dconv/configuration-1.5.html#3.2-tune.ssl.cachesize
% See https://kura.io/2014/07/02/haproxy-ocsp-stapling/
% See https://kura.io/2015/01/27/hpkp-http-public-key-pinning-with-haproxy/

HAProxy can be used as loadbalancer and proxy for TCP and HTTP-based
applications. Since version 1.5 it supports SSL and IPv6.

### Tested with Versions

HAProxy 1.5.11 with OpenSSL 1.0.1e on Debian Wheezy

### Settings

\configfile{haproxy.cfg}{1-4}{global configuration}
\configfile{haproxy.cfg}{21-25}{frontend configuration}
\configfile{haproxy.cfg}{27-33}{backend configuration}

### Additional Settings

Enable NPN Support:

        bind *:443 ssl crt server.pem npn "http/1.1,http/1.0"

Append the npn command in the frontend configuration of HAProxy.

Enable OCSP stapling:

HAProxy supports since version 1.5.0 OCSP stapling. To enable it you
have to generate the OCSP singing file in the same folder, with the same
name as your certificate file plus the extension .ocsp. (e.g. your
certificate file is named `server.crt` then the OCSP file have to be named
`server.crt.oscp`)
To generate the OCSP file use these commands:

    openssl x509 -in your.certificate.crt -noout -ocsp_uri # <- get your ocsp uri
    openssl ocsp -noverify -issuer ca.root.cert.crt -cert your.certificate.crt -url "YOUR OCSP URI" -respout your.certificate.crt.ocsp

Reload HAProxy and now OCSP stapling should be enabled.\
Note: This OCSP signature file is only valid for a limited time. The
simplest way of updating this file is by using cron.daily or something
similar.

Enable HPKP:

Get certificate informations:

    openssl x509 -in server.crt -pubkey -noout | openssl rsa -pubin -outform der | openssl dgst -sha256 -binary | base64

Then you append the returned string in the HAProxy configuration. Add
the following line to the backend configuration:

    rspadd Public-Key-Pins:\ pin-sha256="YOUR_KEY";\ max-age=15768000;\ includeSubDomains

Reload HAProxy and HPKP should now be enabled.

Note: Keep in mind to generate a backup key in case of problems with
your primary key file.

### How to test

See appendix \[cha:tools\]

Pound
-----

% See http://www.apsis.ch/pound
% See https://help.ubuntu.com/community/Pound

### Tested with Versions

* Pound 2.6

### Settings
\configfile{pound.cfg}{31}{HTTPS Listener in Pound}

stunnel
-------

### Tested with Versions

* stunnel 4.53-1.1ubuntu1 on Ubuntu 14.04 Trusty with OpenSSL 1.0.1f,
  without disabling Secure Client-Initiated Renegotiation
* stunnel 5.02-1 on Ubuntu 14.04 Trusty with OpenSSL 1.0.1f
* stunnel 4.53-1.1 on Debian Wheezy with OpenSSL 1.0.1e, without disabling
  Secure Client-Initiated Renegotiation

### Settings
\configfile{stunnel.conf}{48-55}{HTTPS Listener in Pound}

### Additional information

Secure Client-Initiated Renegotiation can only be disabled for stunnel
versions >= 4.54, when the renegotiation parameter has been added
(See changelog).

### References

* stunnel documentation: <https://www.stunnel.org/static/stunnel.html>
* stunnel changelog: <https://www.stunnel.org/sdf_ChangeLog.html>

### How to test

See appendix \[cha:tools\] TODO
