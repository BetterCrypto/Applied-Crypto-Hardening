A short helper on how to use _acronyms_, _glossary entries_, and the _index_.

## Acronyms ##

### How to Use ###

To `common/names.tex` add

```
\newacronym{ABC}{abc}{%
  a Better Crypto}
```

In text use `\ac{ABC}`. The first time, this expands to “a Better Crypto (ᴀʙᴄ)”, subsequently, to “ᴀʙᴄ”.

See below for more commands.

### When to Use ###

Do use for

 * typically abbreviated phrases 
 * that occur frequently
 * and do not need further explanation (eg, HTTP)
 * or are explained in text (eg, ECDH).
 
Do _not_ use for

 * phrases / words that are no acronyms
 * or acronyms that need further explanation (which is _not_ given in text).

## Glossary ##
### How to Use ###

To `common/names.tex` add

```
\newglossaryentry{firewall}{%
  name=firewall,
  description={technological barrier designed to prevent unauthorized or
    unwanted communications between computer networks or hosts}
}
```

In text use `\gls{firewall}`. This produces a _link_ with the text “firewall” to the glossary and the description there.

See below for more commands.

### When to Use ###

Do use for 
 
 * phrases / words that are no acronyms and need explanation (which is _not_ given in text)
 * or acronyms that need further explanation (which is _not_ given in text).

Do _not_ for

 * typically abbreviated phrases 
 * that occur frequently
 * and do not need further explanation (eg, HTTP)
 * or are explained in text (eg, ECDH).

## Index ##
> Every good book needs an index 
>
> — anonymous
### How to Use ###

To `common/names.tex` add

```
\doindex{Diffie--Hellman}
```

If you want to index acronyms or glossary entries, do so in their definition:

```
\newacronym{DH}{dh\alsoidx{Diffie--Hellman}}{%
  Diffie--Hellman key exchange}
```

In text use `|Diffie--Hellman|` or `\idx{Diffie--Hellman}`. To get a literal “|“, use `\textbar` or `||`.

See below for more commands.

### When to Use ###

Do use for 
 
 * important terms, definitions, concepts etc.,
 * proper names,
 * or product names.

Do _not_ for

 * everyday words like “computer”
 * or colloquial words like “crypto”.

---

## Other Commands ##

### For Acronyms ###

Refer to “Acronyms” in [the glossaries documentation][glossaries].

If possible, use

* `\ac` — on first usage, same as `\acf`, else, same as `\acs`* `\Ac` — on first usage, same as `\Acf`, else, same as `\Acs`* `\acp` — on first usage, same as `\acfp`, else, same as `\acsp`* `\Acp` — on first usage, same as `\Acfp`, else, same as `\Acsp`

and only seldomly

* `\acs` — acronym short form “ᴀʙᴄ”* `\Acs` — capitalized acronym short form “Aʙᴄ”* `\acsp` — plural acronym short form “ᴀʙᴄs”* `\Acsp` — capitalized plural acronym short form “Aʙᴄs”* `\acl` — acronym long form “a Better Crypto”* `\Acl` — capitalized acronym long form “A Better Crypto”* `\aclp` — plural acronym long form “a Better Crypto” (_does not fit example_)* `\Aclp` — capitalized plural acronym long form “A Better Crypto” (_does not fit example_)* `\acf` — acronym full form “a Better Crypto (ᴀʙᴄ)”* `\Acf` — capitalized acronym full form “A Better Crypto (ᴀʙᴄ)”* `\acfp` — plural acronym full form “a Better Cryptos (ᴀʙᴄs)” (_does not fit example_)* `\Acfp` — capitalized plural acronym full form “A Better Crypto (ᴀʙᴄs)” (_does not fit example_)
### For Glossary Entries ###

Refer to “Links to glossary entries” in [the glossaries documentation][glossaries].

A selection:

* `\gls` — glossary entry as defined “firewall”
* `\Gls` — capitalized glossary entry “Firewall”
* `\GLS` — all-caps glossary entry “FIREWALL”
* `\glspl` — plural glossary entry as defined “firewalls”
* `\Glspl` — plural capitalized glossary entry “Firewalls”
* `\GLSpl` — plural all-caps glossary entry “FIREWALLS”

### For Index ###

Internally, `\idx` uses `\gls` (see above) with special treating, so we provide the following mapping:

* `\idx` → `\gls`
* `\Idx` → `\Gls`
* `\IDX` → `\GLS`
* `\idxpl` → `\glspl`
* `\Idxpl` → `\Glspl`
* `\IDXpl` → `\GLSpl`

The form `|indexword|` is a shortcut for `\idx{indexword}` and behaves the same.
To pass optional arguments to `idx` (and hence `\gls`), use the form

```
|[format=emph]Diffie--Hellman| is the same as \idx[format=emph]{Diffie--Helmann}
```


[glossaries]: http://mirrors.ctan.org/macros/latex/contrib/glossaries/glossaries-user.pdf


