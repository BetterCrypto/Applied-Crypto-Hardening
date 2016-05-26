Database Systems
================

Oracle
------

### Tested with Versions

We do not test this here, since we only reference other papers for
Oracle so far.

### References

Technical safety requirements by *Deutsche Telekom AG* (German). Please
read section 17.12 or pages 129 and following (Req 396 and Req 397)
about SSL and ciphersuites
<http://www.telekom.com/static/-/155996/7/technische-sicherheitsanforderungen-si>

MySQL
-----

### Tested with Versions

Debian Wheezy and MySQL 5.5

### Settings

### References

MySQL Documentation on SSL Connections.
<https://dev.mysql.com/doc/refman/5.5/en/ssl-connections.html>

### How to test

After restarting the server run the following query to see if the ssl
settings are correct:

    show variables like '%ssl%';

DB2
---

### Tested with Version

We do not test this here, since we only reference other papers for DB2
so far.

### Settings

#### ssl_cipherspecs

In the link above the whole SSL-configuration is described in-depth. The
following command shows only how to set the recommended ciphersuites.

    # recommended and supported ciphersuites 

    db2 update dbm cfg using SSL_CIPHERSPECS 
    TLS_RSA_WITH_AES_256_CBC_SHA256,
    TLS_RSA_WITH_AES_128_GCM_SHA256,
    TLS_RSA_WITH_AES_128_CBC_SHA256,
    TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
    TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
    TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,
    TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,
    TLS_RSA_WITH_AES_256_GCM_SHA384,
    TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,
    TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
    TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,
    TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384,
    TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA,
    TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA,
    TLS_RSA_WITH_AES_256_CBC_SHA,
    TLS_RSA_WITH_AES_128_CBC_SHA,
    TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,
    TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA

### References

IBM Db2 Documentation on *Supported cipher suites*.
<http://pic.dhe.ibm.com/infocenter/db2luw/v9r7/index.jsp?topic=%2Fcom.ibm.db2.luw.admin.sec.doc%2Fdoc%2Fc0053544.html>

PostgreSQL
----------

### Tested with Versions

* Debian Wheezy and PostgreSQL 9.1
* Linux Mint 14 nadia / Ubuntu 12.10 quantal with PostgreSQL 9.1+136 and
  OpenSSL 1.0.1c

### Settings

To start in SSL mode the server.crt and server.key must exist in the
server’s data directory `$PGDATA`.

Starting with version 9.2, you have the possibility to set the path
manually.

### References

It’s recommended to read “Security and Authentication” in the
manual[^postgres].

PostgreSQL Documentation on *Secure TCP/IP Connections with SSL*:
<http://www.postgresql.org/docs/9.1/static/ssl-tcp.html>

PostgreSQL Documentation on *host-based authentication*:
<http://www.postgresql.org/docs/current/static/auth-pg-hba-conf.html>

### How to test

To test your ssl settings, run psql with the sslmode parameter:

    psql "sslmode=require host=postgres-server dbname=database" your-username

[^postgres]: <http://www.postgresql.org/docs/9.1/interactive/runtime-config-connection.html>
