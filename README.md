The Nitro Dotfiles!
===================

Introduction
------------
Many out there using symbolic links to setup dotfiles but using git we can have
our repository in a folder and set our working tree to another one. I use the
latter approach to maintain my dotfiles and configured installations to set it
up this way.

Installation
------------
If you want to try it out please first be cautious of any unwanted configuration
you may encounter; Then:

To clone the repo and set it up, Run:
```bash
curl -Lks https://git.io/vXmwx | $(which bash)
```
and to install dependencies:
```bash
cd; sh install
```
Done. everything is up and running!

Maintainance
------------
Because of the repository's neat setup technique, we use `nit`( pronounced like `git`
and not neat, for nitro you know ;) ) for **configuration versioning** like:
```bash
nit status
nit add .vimrc
nit commit -m "Add vimrc"
...
```
**NOTE** that we only use `nit` for configuration files. Of course for other repos we
should use normal `git` command.

More on this technique:
  - [What do you use to manage dotfiles?](https://news.ycombinator.com/item?id=11071754)
  - [The best way to store your dotfiles](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/)

License & Copyright
-------------------
License: [MIT](./LICENSE)

© 2016 by Ali Zarifkar. All Rights Reserved.
