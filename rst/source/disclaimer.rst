.. role:: raw-latex(raw)
   :format: latex
..

.. _sec-disclaimer-scope:

Disclaimer and scope
====================

.. epigraph::

   “A chain is no stronger than its weakest link, and life is after all a
   chain”

   -- William James

.. epigraph::

   “Encryption works. Properly implemented strong crypto systems are one of the
   few things that you can rely on. Unfortunately, endpoint security is so
   terrifically weak that NSA can frequently find ways around it.”

   -- Edward Snowden, answering questions live on the Guardian's website \cite{snowdenGuardianGreenwald}


This guide specifically does not address physical security, protecting
software and hardware against exploits, basic IT security housekeeping,
information assurance techniques, traffic analysis attacks, issues with
key-roll over and key management, securing client PCs and mobile devices
(theft, loss), proper Operations Security [1]_, social engineering
attacks, protection against
tempest :cite:`Wikipedia:Tempest` attack techniques,
thwarting different side-channel attacks (timing–, cache timing–,
differential fault analysis, differential power analysis or power
monitoring attacks), downgrade attacks, jamming the encrypted channel or
other similar attacks which are typically employed to circumvent strong
encryption. The authors can not overstate the importance of these other
techniques. Interested readers are advised to read about these attacks
in detail since they give a lot of insight into other parts of
cryptography engineering which need to be dealt with. [2]_

This guide does not talk much about the well-known insecurities of
trusting a public-key infrastructure (PKI) [3]_. Nor does this text
fully explain how to run your own Certificate Authority (CA).

Most of this zoo of information security issues are addressed in the
very comprehensive book “Security Engineering” by Ross
Anderson :cite:`anderson2008security`.

For some experts in cryptography this text might seem too informal.
However, we strive to keep the language as non-technical as possible and
fitting for our target audience: system administrators who can
collectively improve the security level for all of their users.

.. epigraph::

   “Security is a process, not a product.”

   -- Bruce Schneier

This guide can only describe what the authors currently *believe* to be
the best settings based on their personal experience and after intensive
cross checking with literature and experts. For a complete list of
people who reviewed this paper, see the
:raw-latex:`\nameref{section:Reviewers}`. Even though multiple
specialists reviewed the guide, the authors can give *no guarantee
whatsoever* that they made the right recommendations. Keep in mind that
tomorrow there might be new attacks on some ciphers and many of the
recommendations in this guide might turn out to be wrong. Security is a
process.

We therefore recommend that system administrators keep up to date with
recent topics in IT security and cryptography.

In this sense, this guide is very focused on getting the cipher strings
done right even though there is much more to do in order to make a
system more secure. We the authors, need this document as much as the
reader needs it.

Scope
-----

In this guide, we restricted ourselves to:

 * Internet-facing services
 * Commonly used services
 * Devices which are used in business environments (this specifically excludes XBoxes, Playstations and similar consumer devices)
 * OpenSSL 

We explicitly excluded:

 * Specialized systems (such as medical devices, most embedded systems, industrial control systems, etc.)
 * Wireless Access Points
 * Smart-cards/chip cards

.. * Advice on running a PKI or a CA
.. * Services which should be run only in an internal network and never face the Internet.


..
   %% * whatsapp --> man kann nichts machen, out of scope
   %* Lync: == SIP von M$.
   %* Skype: man kann ncihts machen, out of scope.
   %* Wi-Fi APs, 802.1X, ... ???? --> out of scope
   %* Tomcats/...????
   %* SIP   -> Klaus???
   %* SRTP  -> Klaus???
   %* DNSSec ?? Verweis auf BCPxxx  --> out of scope
   %   - DANE
   %What happens at the IETF at the moment?
   %* TOR?? --> out of scope
   %* S/Mime --> nachsehen, gibt es BCPs? (--> Ramin)
   %* TrueCrypt, LUKS, FileVault, etc ---> out of scope
   %* AFS -> out of scope
   %* Kerberos --> out of scope
   %* NNTP -> out of scope
   %* NTPs tlsdate -> out of scope
   %* BGP / OSPF --> out of scope
   %* irc,silc --> out of scope
   %* LDAP -> out of scope
   %* Moxa , APC, und co... ICS . Ethernet to serial --> out of scope
   %* telnet -> DON't!!!
   %* rsyslog --> out of scope
   %* ARP bei v6 spoofing -> out of scope
   %* tinc?? -> out of scope
   %* rsync -> nur ueber ssh fahren ausser public web mirrors
   %* telnets -> out of scope
   %* ftps -> out of scope
   %seclayer-tcp    3495/udp    # securitylayer over tcp
   %seclayer-tcp    3495/tcp    # securitylayer over tcp
   %* webmin -> maybe
   %* plesk -> out of scope
   %* phpmyadmin --> haengt am apache, out of scope
   %* DSL modems -> out of scope
   %* UPnP, natPmp --> out of scope 

   
.. [1]
   https://en.wikipedia.org/wiki/Operations_security

.. [2]
   An easy to read yet very insightful recent example is the
   “FLUSH+RELOAD” technique :cite:`yarom2013flush+` for
   leaking cryptographic keys from one virtual machine to another via L3
   cache timing attacks.

.. [3]
   Interested readers are referred to
   https://bugzilla.mozilla.org/show_bug.cgi?id=647959 or
   http://www.h-online.com/security/news/item/Honest-Achmed-asks-for-trust-1231314.html
   which brings the problem of trusting PKIs right to the point
