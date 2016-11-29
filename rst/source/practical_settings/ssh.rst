SSH
===

OpenSSH
-------

Tested with Version
~~~~~~~~~~~~~~~~~~~

OpenSSH 6.6p1 (Gentoo)

Settings
~~~~~~~~

**Note:** OpenSSH 6.6p1 now supports Curve25519

Tested with Version
~~~~~~~~~~~~~~~~~~~

OpenSSH 6.5 (Debian Jessie)

Settings
~~~~~~~~

Tested with Version
~~~~~~~~~~~~~~~~~~~

OpenSSH 6.0p1 (Debian wheezy)

Settings
~~~~~~~~

**Note:** Older \|Linux\| systems won’t support SHA2. PuTTY (Windows)
does not support RIPE-MD160. Curve25519, AES-GCM and UMAC are only
available upstream (OpenSSH 6.6p1). DSA host keys have been removed on
purpose, the DSS standard does not support for DSA keys stronger than
1024bit  [1]_ which is far below current standards (see section
[section:keylengths]). Legacy systems can use this configuration and
simply omit unsupported ciphers, key exchange algorithms and MACs.

References
~~~~~~~~~~

The OpenSSH sshd\_config man page is the best reference:
http://www.openssh.org/cgi-bin/man.cgi?query=sshd_config

How to test
~~~~~~~~~~~

Connect a client with verbose logging enabled to the SSH server

::

    $ ssh -vvv myserver.com

and observe the key exchange in the output.

Cisco ASA
---------

Tested with Versions
~~~~~~~~~~~~~~~~~~~~

9.1(3)

Settings
~~~~~~~~

::

    crypto key generate rsa modulus 2048
    ssh version 2
    ssh key-exchange group dh-group14-sha1

Note: When the ASA is configured for SSH, by default both SSH versions 1
and 2 are allowed. In addition to that, only a group1 DH-key-exchange is
used. This should be changed to allow only SSH version 2 and to use a
key-exchange with group14. The generated RSA key should be 2048 bit (the
actual supported maximum). A non-cryptographic best practice is to
reconfigure the lines to only allow SSH-logins.

References
~~~~~~~~~~

`http://www.cisco.com/en/US/docs/security/asa/asa91/configuration/general/admin\_management.html  <http://www.cisco.com/en/US/docs/security/asa/asa91/configuration/general/admin_management.html >`__

How to test
~~~~~~~~~~~

Connect a client with verbose logging enabled to the SSH server

::

    $ ssh -vvv myserver.com

and observe the key exchange in the output.

Cisco IOS
---------

Tested with Versions
~~~~~~~~~~~~~~~~~~~~

15.0, 15.1, 15.2

Settings
~~~~~~~~

::

    crypto key generate rsa modulus 4096 label SSH-KEYS
    ip ssh rsa keypair-name SSH-KEYS
    ip ssh version 2
    ip ssh dh min size 2048

    line vty 0 15
    transport input ssh

Note: Same as with the ASA, also on IOS by default both SSH versions 1
and 2 are allowed and the DH-key-exchange only use a DH-group of 768
Bit. In IOS, a dedicated Key-pair can be bound to SSH to reduce the
usage of individual keys-pairs. From IOS Version 15.0 onwards, 4096 Bit
rsa keys are supported and should be used according to the paradigm “use
longest supported key”. Also, do not forget to disable telnet vty
access.

References
~~~~~~~~~~

http://www.cisco.com/en/US/docs/ios/sec_user_services/configuration/guide/sec_cfg_secure_shell.html

How to test
~~~~~~~~~~~

Connect a client with verbose logging enabled to the SSH server

::

    $ ssh -vvv myserver.com

and observe the key exchange in the output.

.. [1]
   https://bugzilla.mindrot.org/show_bug.cgi?id=1647
