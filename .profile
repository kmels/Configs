# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi


if [ -d "$HOME/Binarios" ] ; then PATH="$HOME/Binarios:$PATH" 
fi

# set PATH so it includes cabal's bin
if [ -d "$HOME/.cabal/bin" ] ; then
    PATH="$HOME/.cabal/bin:$PATH"
fi

export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/
export JDK_HOME=/usr/lib/jvm/java-7-openjdk-amd64/

# fix ghc-7.8.2
export LANG=C.UTF-8

# fix java <+> xmonad
export _JAVA_AWT_WM_NONREPARENTING=1

# xmonad please play well with java
export _JAVA_AWT_WM_NONREPARENTING=1

# sbt size
export SBT_OPTS="-Xmx6036M -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=3556m -Xss2M  -Duser.timezone=America/Guatemala"



