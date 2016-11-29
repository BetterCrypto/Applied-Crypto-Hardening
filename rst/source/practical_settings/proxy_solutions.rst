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

Bluecoat
--------

Tested with Versions
~~~~~~~~~~~~~~~~~~~~

SGOS 6.5.x

BlueCoat Proxy SG Appliances can be used as forward and reverse proxies.
The reverse proxy feature is rather under-developed, and while it is
possible and supported, there only seems to be limited use of this
feature “in the wild” - nonetheless there are a few cipher suites to
choose from, when enabling SSL features.

Only allow TLS 1.0,1.1 and 1.2 protocols:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

 

::

    $conf t
    $(config)ssl
    $(config ssl)edit ssl-device-profile default
    $(config device-profile default)protocol tlsv1 tlsv1.1 tlsv1.2
      ok

Select your accepted cipher-suites:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

 

::

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

::

    <ssl>
        DENY server.connection.negotiated_ssl_version=(SSLV2, SSLV3)

Disabling protocols and ciphers in a forward proxy environment could
lead to unexpected results on certain (misconfigured?) webservers (i.e.
ones accepting only SSLv2/3 protocol connections)

Pound
-----

Tested with Versions
~~~~~~~~~~~~~~~~~~~~

Pound 2.6

Settings
~~~~~~~~
