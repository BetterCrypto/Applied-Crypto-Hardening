First off: you are welcome to help us! Every reviewer, committer and person interested in discussing our document and changes is a valuable addition to the project. Everybody is invited to work on this document and share their experience and expertise with us or ask questions if something isn't clear to them. Please read [CONTRIBUTING](CONTRIBUTING.md) document for more information.

# HOW TO USE THIS

## git.bettercrypto.org
Anonymous (read-only) git cloning:

`  $ git clone  https://git.bettercrypto.org/ach-master.git`


As a registered user:

  `$ git clone  https://<myuser>@git.bettercrypto.org/ach-master.git`

Where `<myuser>` is your username on the server. Ask for write permissions if you need them.


Committing changes you made (from within repo-directory):


```
$ git commit -a
$ git push origin master
```


Receive latest updates for a previously cloned repository (from within repo-directory):

  `$ git pull`

## GitHub
Fork and issue pull requests. Those will be reviewed and if accepted pushed to the main repository hosted on git.bettercrypto.org.

## MacTeX
MacTeX misses `mweights.sty` and may cause a compile error.

```bash
sudo tlmgr install mweights
```

## IRC
channel: #bettercrypto
network: freenode

# IMPORTANT

 * If you reviewed the document and/or made some changes, please add your name to `src/acknowledgements.tex` (the list of names is sorted alphabetically by last name).
 * Send many smaller commits (pull requests) and not one big one! Big ones tend to be delayed. It's hard to process a huge commit. We need to review everything, please remember.
 * Please also read the [FAQ](FAQ.md)!!
