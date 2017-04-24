.. role:: raw-latex(raw)
   :format: latex
..

A note on `elliptic curve` Cryptography
=====================================

.. epigraph::

   “Everyone knows what a curve is, until he has studied enough mathematics to
   become confused through the countless number of possible
   exceptions.”

   -- Felix Klein

Elliptic Curve Cryptography (simply called ECC from now on) is a branch
of cryptography that emerged in the mid-1980s. The security of the RSA
algorithm is based on the assumption that factoring large numbers is
infeasible. Likewise, the security of ECC, DH and DSA is based on the
discrete logarithm
problem :cite:`Wikipedia:Discrete,McC90,WR13`. Finding the
discrete logarithm of an elliptic curve from its public base point is
thought to be infeasible. This is known as the Elliptic Curve Discrete
Logarithm Problem (ECDLP). ECC and the underlying mathematical
foundation are not easy to understand - luckily, there have been some
great introductions on the topic lately  [1]_  [2]_  [3]_. ECC provides
for much stronger security with less computationally expensive
operations in comparison to traditional asymmetric algorithms (See the
Section :ref:`section-keylengths`). The security of ECC
relies on the elliptic curves and curve points chosen as parameters for
the algorithm in question. Well before the NSA-leak scandal there has
been a lot of discussion regarding these parameters and their potential
subversion. A part of the discussion involved recommended sets of curves
and curve points chosen by different standardization bodies such as the
National Institute of Standards and Technology (NIST)  [4]_ which were
later widely implemented in most common crypto libraries. Those
parameters came under question repeatedly from
cryptographers :cite:`BL13,Sch13b,W13`. At the time of
writing, there is ongoing research as to the security of various ECC
parameters :cite:`DJBSC`. Most software configured to rely
on ECC (be it client or server) is not able to promote or black-list
certain curves. It is the hope of the authors that such functionality
will be deployed widely soon. The authors of this paper include
configurations and recommendations with and without ECC - the reader may
choose to adopt those settings as he finds best suited to his
environment. The authors will not make this decision for the reader.

**A word of warning:** One should get familiar with ECC, different
curves and parameters if one chooses to adopt ECC configurations. Since
there is much discussion on the security of ECC, flawed settings might
very well compromise the security of the entire system!

.. [1]
   http://arstechnica.com/security/2013/10/a-relatively-easy-to-understand-primer-on-elliptic-curve-cryptography

.. [2]
   https://www.imperialviolet.org/2010/12/04/ecc.html

.. [3]
   http://www.isg.rhul.ac.uk/~sdg/ecc.html

.. [4]
   http://www.nist.gov
