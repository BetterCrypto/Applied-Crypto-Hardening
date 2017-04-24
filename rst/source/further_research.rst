Further research
================

The following is a list of services, software packages, hardware devices
or protocols that we considered documenting but either did not manage to
document yet or might be able to document later. We encourage input from
the Internet community.


.. hlist::
    :columns: 3

    *  Lync
    *  Wi-Fi APs, 802.1X
    *  Tomcat
    *  SIP
    *  SRTP
    *  DNSSec (mention BCPs)
    *  DANE
    *  TOR
    *  S/Mime (check are there any BCPs? )
    *  TrueCrypt, LUKS, FileVault
    *  AFS
    *  Kerberos
    *  NNTP
    *  NTPs tlsdate
    *  BGP / OSPF
    *  LDAP
    *  seclayer-tcp
    *  Commerical network equipment vendors
    *  RADIUS
    *  Moxa , APC, und co... ICS . Ethernet to serial
    *  rsyslog
    *  v6 spoofing (look at work by Ferndo Gont, Marc Heuse, et. al.)
    *  tinc
    *  racoon
    *  l2tp
    *  telnets
    *  ftps
    *  DSL modems (where to start?)
    *  UPnP, natPmp
    *  SAML federated auth providers \footnote{e.g., all the REFEDS folks (\url{https://refeds.org/}), including InCommon (\url{http://www.incommon.org/federation/metadata.html} \url{https://wiki.shibboleth.net/confluence/display/SHIB2/TrustManagement})}
    *  Microsoft SQL Server
    *  Microsoft Exchange
    *  HAProxy\footnote{\url{https://lists.cert.at/pipermail/ach/2014-November/001601.html}}
    *  HTTP Key Pinning (HTKP)
    *  IBM HTTP Server
    *  Elastic Load Balancing (ELB)\footnote{\url{https://lists.cert.at/pipermail/ach/2014-May/001422.html}}

Software not covered by this guide
----------------------------------

 * telnet: Usage of telnet for anything other than fun projects is highly discouraged
 * Simple Network Management Protocol (SNMP): Remote Management Software should not be available from a routed network. There is an inestimable number of problems with these implementations. Popular vendors regularly have exploits or DDoS problems with their embedded remote management and are suffering from SNMP stacks.\footnote{\url{https://lists.cert.at/pipermail/ach/2014-May/001389.html}} Tunneling these services over SSH or stunnel with proper authentication can be used if needed.
 * Puppet DB: A Proxy or a tunnel is recommended if it needs to be facing public network interfaces.\footnote{\url{https://lists.cert.at/pipermail/ach/2014-November/001626.html}}
 * rsync: Best use it only via SSH for an optimum of security and easiest to maintain.
