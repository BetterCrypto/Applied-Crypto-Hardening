A note on SHA-1
===============

In the last years several weaknesses have been shown for SHA-1. In
particular, collisions on SHA-1 can be found using :math:`2^63` operations, and recent results even indicate a lower complexity.
Therefore, ECRYPT II and NIST recommend against using SHA-1 for
generating digital signatures and for other applications that require
collision resistance. The use of SHA-1 in message authentication, e.g.
HMAC, is not immediately threatened.

We recommend using SHA-2 whenever available. Since SHA-2 is not
supported by older versions of TLS, SHA-1 can be used for message
authentication if a higher compatibility with a more diverse set of
clients is needed.

Our configurations A and B reflect this. While configuration A does not
include SHA-1, configuration B does and thus is more compatible with a
wider range of clients.
