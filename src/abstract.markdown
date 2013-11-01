Abstract
=========

This whitepaper arose out of the need to have an updated, solid, well researched and thought-through guide for configuring SSL, PGP, SSH and other cryptographic tools in the post-PRISM age.
Since the NSA leaks in the summer of 2013, many system administrators and IT security officers felt the need to update their encryption settings as quickly as possible.

However, as [Schneier][SchneiderNSAbreaksEncryption] noted, it seems that intelligence agencies and adversaries on the Internet are not breaking so much the mathematics of encryption per se, but rather use weaknesses and sloppy settings in encryption frameworks to break the codes, next to using other means such as "kinetic-decryption" (breaking in, stealing keys) or planting backdoors, etc.


This following whitepaper can only address one aspect of securing our information systems: getting the crypto settings right. Other attacks, as the above mentioned kinetic cryptanalysis, require different protection schemes which are not covered in this whitepaper.


[SchneiderNSAbreaksEncryption]: https://www.schneier.com/blog/archives/2013/09/the_nsa_is_brea.html	"The NSA Is Breaking Most Encryption on the Internet"
