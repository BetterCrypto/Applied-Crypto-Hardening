Bug Fixes
=========
Reported by: @Wims80 http://twitter.com/wims80/status/425770704693239808
Section Apache 2.1.1 recommends Rewrite instead of Redirect. Should be 301! (We correctly recommend 301 in the nginx section.)


BIG TOPICS
==========


* be consistent: 2048 RSA < 128 bit symmetric cipher strength. We should aim at 128+ bits symmetric strength. --> fix RSA 2048 in the document. Upgrade to 3072

* clean up 9.5 "chossing your own cipher"

* DDOS possibilities when we increase cyrpto security?? What about that? (--> LATER)

* write a Justification section to every setting, maybe have that later in the document. 

* more focus on these sections:
  - GPG
  - SSH : do we need a client subsection? 

DONE * move the explanations to a later part of the document. Code snippets go *first* . The target group is sysadmins, must be easily copy & paste-able. Or find a different way so that they can easily use/read the document

DONE * Decide/Discuss recommended ciphers:
  - DH parameters: what is our recommendation? >2048? >=2048? leave default (aka 1024)?
  --> answer: we trust IETF/IKE  as described in ECRYPT2

* comments from IAIK integrate (--> Aaron, check again if it was done)
DONE * SHA-1 section: write why it is a problem (--> Florian Mendel)
* PKI section (--> Thomas Schreck)
DONE * include OpenSSL names/IANA names into appendix (--> cm)
* Document RNG problem in Apache (--> Pepi)
DONE * Oracle ?? (--> Berg?? maybe . Or aaron: ask nic.at. Or link to T-Systems paper) --> T-Systems paper
DONE * DB2 (--> Berg. Or ask MLeyrer)
* Add AES128 to cipherStringA ?
* re-work chapter 2 (practical settings). Add lots of references to chapter 3 to get people interested in reading the theory.
* Document : add license

* compare gv.at Richtlinien with our recommendations.

Website
=======
People with outdated browsers (winXP) etc can't see our webpage. --> make a landing page explaining 
how to updated the browser :)

Improve the wording on the cert.at Mailing list website so people don't get confused and know that they ended up on the correct site and list.

LANGUAGES
=========
* translate to french and other european languages

Formatting
==========

* check all http:// URLs that we reference - check if they are also reachable via httpS:// and if so, change our reference
* make style guide
DONE * one-column layout: make page margins smaller
DONE * add large "DRAFT" letters on top of every page.
DONE  make the git version number part of the document
DONE * Layout of sample code (lstisting format) : make it pretty!
Rendering in Firefox (inline) on Windows seems to be really messed up. What happenened?

* make every section like the Apache section (--> Aaron)

* make a HTML Version of the document. It is much easier to copy & paste from than from PDFs.
* Add Timestamp and git shorthash, not only date, to the title page of the document. Easier to check if you version of the document is current!

* \usepackage[utf8]{inputencoding} and all the other \usepackage things in applied-crypto-hardening.tex should be reviewed and we should take a look if it should't all be in common/\*.tex

* check epigraph: why is the "---" gone? Is it gone?


Formats to export
=================
Requested by many people on Twitter
    * Plain TXT version for use on headless servers
    * HTML version for better reading in browsers and always up-to-date
    * EPUB version for comfortable reading on tablets and ebook readers


Workflow
========

* how to keep things up to date?
* how to automatically test  compatibility?
* how to make sure that this document has the latest information on cipher strengths?
* !! GPG sign every PDF !!
* store the keys in DNS: see RFC 4398


Contents
========

* disclaimer.tex:
  add "we don't deal with ICS devices. Nonono"
 
* CipherStringB: 
  src/commons/cipherstringb.tex --> remove the "!SRP"

* Mailserver.tex:
  Add "Dovecot" in front of 2.0.19apple1 
  Postfix section: smtpd_tls_loglevel = 1 instead of = 0

* DBs:
  Postgresql: put in \%*\cipherstringB*) in the config!
  Mysql: put in \%*\cipherstringB*) in the config!
  Oracle: mark this as "we do not test this here, since we only reference other papers for Oracle so far"
  DB2: mark this as "we do not test this here, since we only reference other papers for Oracle so far"
  sed -i /IMB Db2/IBM DB2/g

* theory/PKI.tex line 120: "a previously created certificate" --> "a previously created key"!


* Webservers:
  Header Strict-Transport-Security "... includeSubDomains": we need to meed to mention that this can be a big pitfall.
  Also do some more research on this!
  For example: https://tools.ietf.org/html/draft-ietf-websec-strict-transport-sec#section-6.1
  fix lighttpd HTTP redirection and env vars
  lighthttpd: ssl.ec-curve = "secp384"
    ssl.dh-file = "/etc/lighttpd/dhparams-group16.pem"
	ssl.ec-curve = "secp384r1"

* GPG.tex:
  keep it "Howto" not "How-to"

* IM:
  fix the subsubsection{XMPP/ Jabber} part. There seems to be a mix up here ? Maybe? --> check again

* SSH:
  openssh - remark that ServerKeyBits  might still be useful. Add a note that sometimes old keys are very very old and 1024 bits. 

* Tools: 
  mention that sslscan (the tool) does not understand all cipherstrings! For example SHA2-\* is missing
  --> recommend something better

  - tools -> section SSL \& TLS: "lever your https" --> that's not a sentence. Fix it
  - make this more uniform: the \url in the itemized list should always be either always at the beginnig or always at the end. 

* theory/DH.tex
  check the formatting of \cite[chapter16]{ii2011ecrypt}
  same section: group 19-21 (256--521 bit ECC )... we need to mention it! We can not ignore it!

* cipher\_suites/architecture.tex:
   IANA nomencalture part: make a reference to the appendix here

* .gitignore: add title.log


* epigraph balance between freedom and security is a delicate one --> remove this epigraph. It's not so fitting.


* re-write PKI section: make it *much* shorter. Reference: https://www.cs.auckland.ac.nz/~pgut001/pubs/pkitutorial.pdf and 
  https://en.wikipedia.org/wiki/X.509#Problems_with_certificate_authorities.

* scan our local region of the internet for https/smtp/imaps/pop3s

* Common Pitfalls: 
  - key generation
  - key management , key life cycle
  - cloning of VMs
  - common / default passphrases
* DH parameter?
* Further research
 - mysql, SMB, 
* Wish List for software vendors?
* sweet spot, wo koennen wir was sinnvoll machen, was waere zu viel (8192 bit keys...)


1. document the abstract needs that we have for the cipher settings (HSTS etc)
   Then find the best cipher setting strings per se
   Only then put it to all servers and keep it rather uniformely (as much as possible)

2. Test all settings 

* Test especially with non-Debian-OS!

* Test with more clients and other OSes than OSX / iPhone!!
--> clients? 
  - thunderbird
  - Apple Mail?
  - Outlook *
  - Playstation und XBox? --> LATER!
  - Lotus Notes
  - Blackberry\*
  - Windows Phone 7 ???
  How to Test?
  - chapter owner makes a test setup
  - tested by: XXX , on: $date. Screenshot of SSLlabs/ $testtool. (checktls.com)

* document (cite) EVERYTHING! Why we chose certain values. References, references, references. Otherwise it does not count!
  Srsly!!
DONE * .bib file is completely wrong. Make good citations/references. Add books: Schneier, ...
* !! important: add the version string to everything that we tested!!

* two target groups:
  - security specialists / freaks who want the very best settings
  - should as many clients work with the settings as possible
* look at TLS1.2 specs and really check if we want all of these settings


Practical settings section
----------
Definitely still missing these subsubsections:
* Exchange Server ??  (--> bei M$ angefragt, Evtl. Beitrag von A-Trust)
  - SMTP, POP, IMAP
DONE * Exim4 (-> Adi & Wolfgang Breya)
DONE * Checkpoint (-> cm)
* Asa / Palo Alto (-> Azet)
* Terminal Server (VNC ), ??
DONE * Squid
DONE * XMPP
  --> verweise auf die xmpp community bzw. auf xmpp.net verweisen.
  Empfehlung: unbedingt ejabberd updaten!!  


----- snip ---- all protocols that we looked at --- snip ----
* whatsapp --> man kann nichts machen, out of scope
* Lync: == SIP von M$. 
* Skype: man kann ncihts machen, out of scope.
* Wi-Fi APs, 802.1X, ... ???? --> out of scope
* Tomcats/...????
* VPNs		???
  * PPTP
  * Cisco IPSec
  * Juniper VPN
  * L2TP over IPSec -> egal
* SIP   -> Klaus
* SRTP  -> Klaus???
* DNSSec ??	Verweis auf BCPxxx	--> out of scope
   - DANE
What happens at the IETF at the moment?
* TOR?? --> out of scope
* S/Mime --> nachsehen, gibt es BCPs? (--> Ramin)
* TrueCrypt, LUKS, FileVault, etc ---> out of scope
* AFS -> out of scope
* Kerberos --> out of scope
* NNTP -> out of scope
* NTPs tlsdate -> out of scope
* BGP / OSPF --> out of scope
* irc,silc --> out of scope
!! * IPMI/ILO/RAC: Java --> important. Empfehlung: nie ins Internet, nur in ein eigenes mgmt VLAN, das via VPN erreichbar ist!!
* LDAP -> out of scope
* RADIUS? -> maybe later...
* Moxa , APC, und co... ICS . Ethernet to serial --> out of scope
* telnet -> DON't!!! 
* rsyslog --> out of scope
* ARP bei v6 spoofing -> out of scope
* tinc?? -> out of scope
* rsync -> nur ueber ssh fahren ausser public web mirrors
* telnets -> out of scope
* ftps -> out of scope
!! * seclayer-tcp --> review von Posch & co.
seclayer-tcp    3495/udp    # securitylayer over tcp
seclayer-tcp    3495/tcp    # securitylayer over tcp
* webmin -> maybe
* plesk -> out of scope
* phpmyadmin --> haengt am apache, out of scope
* DSL modems -> out of scope
* UPnP, natPmp --> out of scope
* SAML federated auth providers (e.g., all the REFEDS folks (https://refeds.org/)), including InCommon (http://www.incommon.org/federation/metadata.html)
  https://wiki.shibboleth.net/confluence/display/SHIB2/TrustManagement (idea by Joe St. Sauver)
* 
----- snip ---- all protocols that we looked at --- snip ----






RNG section
------------
DONE - add two, three sentences
DONE - mention HaveGED 
DONE - embedded devices are a problem



Contacting / who?
=================
* Juniper
* Cisco

LATER / further 
================
* OpenLDAP (-> Adi)
* Radius
* Windows Active Directory
DONE * SRP: not part of this document. But we did not exclude it in our cipher string :)
DONE * \cipherA , \cipherB setting ---> does not work in our \begin{listing} environment --> maybe there is a different listing environment or use awk/sed/make/perl/python
* What about 3270 terminal emulation? How to do crypto there? Can we? ( --> IBM sec. Stammtisch. Aaron)


* client/users-guide:
  * PGP 
  * ssh client settings
  * OTR ?
  * public key infrastructure
  * certificate handling

