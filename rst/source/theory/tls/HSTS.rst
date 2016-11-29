HTTP Strict Transport Security
------------------------------

HTTP Strict Transport Security (HSTS) is a web security policy
mechanism. HSTS is realized through HTTP header by which a web server
declares that complying user agents (web browsers) should interact with
it by using *only* secure HTTPS connections [1]_.

HSTS header is bound to a DNS name or domain by which the server was
accessed. For example if server serves content for two domains and it is
HTTPS enabled only for one domain, the browser won’t enforce HSTS for
the latter.

HSTS reduces the risk of active man-in-the-middle attacks such as SSL
stripping, and impersonation attacks with *untrusted* certificate. HSTS
also helps to avoid unintentional mistakes such as insecure links to a
secure web site (missing HTTPS links [2]_), and mistyped HTTPS URLs.

After the web browser receives a HSTS header in a *correctly*\  [3]_
prepared SSL session it will automatically use secure HTTPS links for
accessing the server. This prevents unencrypted HTTP access (SSL
striping, mistyped HTTPS URLs, etc.) when the server is accessed later
by the client.

When a server (that previously emitted a HSTS header) starts using
untrusted certificate, complying user agent must show an error message
and *block the server connection*. Thus impersonation MITM attack with
*untrusted* certificate cannot occur.

For the initial setup HSTS header needs a trusted secure connection over
HTTPS. This limitation can be addressed by compiling a list of STS
enabled sites directly into a browser [4]_.

HSTS Header Directives
~~~~~~~~~~~~~~~~~~~~~~

HSTS header can be parametrized by two directives:

max-age=<number-of-seconds>

includeSubdomains

*max-age* is a required directive. This directive indicates the number
of seconds during which the user agent should enforce the HSTS policy
(after the reception of the STS header field from a server).

*includeSubdomains* is an optional directive. This directive indicates
that the HSTS Policy applies to this HSTS Host as well as *any
subdomains of the host’s domain name*.

HSTS Client Support
~~~~~~~~~~~~~~~~~~~

HSTS is supported [5]_ by these web browsers:

Firefox version >= v4.0

Chrome version >= 4.0

Android Browser >=4.4

Opera version >= 12.0

Opera mobile >= 16.0

Safari >= 7.0

Microsoft should add HSTS support in Internet Explorer 12 [6]_.

HSTS Considerations
~~~~~~~~~~~~~~~~~~~

Before enabling HSTS it is recommended to consider following:

Is it *required* to serve content or services over HTTP?

Enabling *includeSubdomains* and SSL certificate management.

Proper value of *max-age*.

It is recommended to serve all content using HTTPS, but there are
exceptions to this rule as well. Consider running a private PKI [7]_.
CRLs and OCSP responses are published typically by HTTP protocol. If
HSTS is enabled on the site where OCSP and CRLs are published the
browser might fail fetching CRL or validating OCSP response.

Similar reasoning goes for *includeSubdomains*. One needs to be sure
that HTTPS can be enforced for all subdomains. Moreover the
administrators are advised to watch for expiration of the SSL
certificate and handle the renewal process with caution. If a SSL
certificate is renewed after expiration or misses a (HSTS enabled)
domain name, the connection to site will break (without providing
override mechanism to the end user).

Finally HSTS should be tested with lower *max-age* values and deployed
with higher *max-age* values.

Testing HSTS
~~~~~~~~~~~~

HSTS can be tested either using locally or through the Internet.

For local testing it is possible to utilize Chrome Web browser UI by
typing chrome://net-internals/#hsts\  [8]_ in the address bar.

Testing over the Internet can be conducted by Qualys SSL Labs test
https://www.ssllabs.com/ssltest/. *Strict Transport Security (HSTS)*
information is located in the *Protocol Details* section.

References
~~~~~~~~~~

Websites Must Use HSTS in Order to Be Secure
https://www.eff.org/deeplinks/2014/02/websites-hsts

OWASP: HTTP Strict Transport Security:
https://www.owasp.org/index.php/HTTP_Strict_Transport_Security

HSTS Browser Compatibility List:
http://caniuse.com/stricttransportsecurity

RFC 6797:HTTP Strict Transport Security (HSTS) - Examples:
https://tools.ietf.org/html/rfc6797#section-6.2

.. [1]
   https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security

.. [2]
   Thus, it might be useful for fixing HTTPS mixed-content related
   errors, see
   https://community.qualys.com/blogs/securitylabs/2014/03/19/https-mixed-content-still-the-easiest-way-to-break-ssl.

.. [3]
   Website must load without SSL/TLS browser warnings (certificate is
   issued by a trusted CA, contains correct DNS name, it is time valid,
   etc.)

.. [4]
   List of the preloaded sites can be found at
   http://dev.chromium.org/sts. This list is managed by Google/Chrome
   but it is also used by Firefox
   https://wiki.mozilla.org/Privacy/Features/HSTS_Preload_List

.. [5]
   http://caniuse.com/stricttransportsecurity

.. [6]
   http://status.modern.ie/httpstricttransportsecurityhsts

.. [7]
   see

.. [8]
   see
   http://blog.chromium.org/2011/06/new-chromium-security-features-june.html
