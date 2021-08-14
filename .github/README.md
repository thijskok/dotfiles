# My dotfiles

## Introduction

This repository serves as a place for storing and maintaining my personal preferences, represented by my very own [Dotfiles](https://wiki.archlinux.org/title/Dotfiles). 
When I set up a new Mac or obtain a new server account, installing these files will make me feel right at home again. 

Feel free to explore and copy parts for your own dotfiles. Enjoy!

## Installation

These dotfiles are managed through [Yadm](https://yadm.io/). Make sure to install it first before proceeding.

### MacOS

On MacOS, you can install Yadm through Brew. If Brew hasn't been installed yet, now is the time:

```
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Once installed, proceed with installing Yadm and cloning this repo. Yadm will automatically bootstrap the
installation procedure for any packages, plugins, and other stuff included in these dotfiles:

```
$ brew install yadm && yadm clone https://github.com/thijskok/dotfiles.git
```

### Ubuntu

On Ubuntu, you can use the built-in package manager to install Yadm and clone the repo:

```
$ sudo apt-get install -y yadm && yadm clone https://github.com/thijskok/dotfiles.git
```
