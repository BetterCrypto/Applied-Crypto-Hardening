.. role:: raw-latex(raw)
   :format: latex
..

How to read this guide
======================

This guide tries to accommodate two needs: first of all, having a handy
reference on how to configure the most common services’ crypto settings
and second of all, explain a bit of background on cryptography. This
background is essential if the reader wants to chose his or her own
background is essential if the reader wants to choose his or her own
cipher string settings.

System administrators who want to copy & paste recommendations quickly
without spending a lot of time on background reading on cryptography or
cryptanalysis can do so, by simply searching for the corresponding
section in chapter :ref:`chapter-PracticalSettings`
(“Practical recommendations”).

It is important to know that in this guide the authors arrived at two
recommendations: *Cipher string A* and *Cipher string B*. While the
former is a hardened recommendation the latter is a weaker one but
provides wider compatibility. *Cipher strings A and B* are described in
:ref:`section-recommendedciphers`.

However, for the quick copy & paste approach it is important to know
that this guide assumes users are happy with *Cipher string B*.
 
While chapter :ref:`chapter-PracticalSettings` is intended
to serve as a copy & paste reference, chapter
:ref:`chapter-Theory` (“Theory”) explains the reasoning
behind *cipher string B*. In particular, section
:ref:`section-CipherSuites` explains how to choose
individual cipher strings. We advise the reader to actually read this
section and challenge our reasoning in choosing *Cipher string B* and to
come up with a better or localized solution.

.. :raw-latex:`\tikzstyle{terminator} = [ellipse, draw, minimum height=2em, text width=4.5em, text badly centered, inner sep=0pt]`
.. :raw-latex:`\tikzstyle{decision} = [diamond, draw,aspect=2, text width=10em, text badly centered, node distance=8em, inner sep=0pt]`
.. :raw-latex:`\tikzstyle{block} = [rectangle, draw,inner sep=0pt, text width=17em, text centered, rounded corners, minimum height=4em]`
.. :raw-latex:`\tikzstyle{line} = [draw, very thick, -latex']`
.. :raw-latex:`\tikzstyle{decision answer} = [near start,color=black]`
.. :raw-latex:`\providecommand*\nameref[1]{?? #1 ??}`
.. :raw-latex:`\providecommand*\hyperref[2]{?? #1 -> #2 ??}`

.. tikz:: [scale=1, node distance = 6em, auto]
    \providecommand*\nameref[1]{?? #1 ??}
    \providecommand*\hyperref[2]{?? #1 -> #2 ??}
    \tikzstyle{terminator} = [ellipse, draw,  minimum height=2em,
        text width=4.5em, text badly centered, inner sep=0pt]
    \tikzstyle{decision} = [diamond, draw,aspect=2,
         text width=10em, text badly centered, node distance=8em, inner sep=0pt]
    \tikzstyle{block} = [rectangle, draw,inner sep=0pt,
         text width=17em, text centered, rounded corners, minimum height=4em]
    \tikzstyle{line} = [draw, very thick, -latex']
    \tikzstyle{decision answer}=[near start,color=black]
    % Place nodes
    \node [terminator] (start) {Start};
    \node [block, right of=start, text width=7em, node distance=8em] (intro) {%
      \nameref{chapter:Intro}};
    \node [decision, below of=intro] (evaluate) {%
      No time, I just want to copy \& paste};
    \node [block, right of=evaluate, node distance=20em] (practical1) {%
      read \nameref{chapter:PracticalSettings}};
    \node [block, below of=evaluate,node distance=8em ] (theory) {%
      To understand why we chose certain settings, read
      \nameref{chapter:Theory} first};
    \node [block, right of=theory, node distance=20em] (practical2) {%
      re-read \nameref{chapter:PracticalSettings}};
    \node [block, below of =practical2] (appendix) {%
      \hyperref[appendix]{Appendix}: references, links};
    % Draw edges
    \path [line] (start) -- (intro);
    \path [line] (intro) -- (evaluate);
    \path [line] (evaluate) -- node [decision answer]  {yes} (practical1);
    \path [line] (evaluate) -- node [decision answer]  {no} (theory);
    \path [line] (practical1) -- (theory);
    \path [line] (theory) -- (practical2);
    \path [line] (practical2) -- (appendix);
