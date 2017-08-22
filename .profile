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

# set PATH so it includes spark bin if it exists
if [ -d "$HOME/bin/spark/bin" ] ; then
    PATH="$HOME/bin/spark/bin:$PATH"
fi

# set PATH so it includes spark sbin if it exists
if [ -d "$HOME/bin/spark/sbin" ] ; then
    PATH="$HOME/bin/spark/sbin:$PATH"
fi

if [ -d "$HOME/Binarios" ] ; then PATH="$HOME/Binarios:$PATH" 
fi

# set PATH so it includes cabal's bin
if [ -d "$HOME/.cabal/bin" ] ; then
    PATH="$HOME/.cabal/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# set PATH to export programs installed with stack
if [ -d "$HOME/.stack/programs/x86_64-linux/ghc-7.8.4/bin" ] ; then
    PATH="$HOME/.stack/programs/x86_64-linux/ghc-7.8.4/bin:$PATH"
fi

# Kafka
if [ -d "$HOME/bin/kafka_2.10-0.8.2.1/bin" ] ; then
    PATH="$HOME/bin/kafka_2.10-0.8.2.1/bin:$PATH"
fi

# Spark
if [ -d "$HOME/spark/1.4.1-hadoop2.4/bin" ] ; then
    PATH="$HOME/spark/1.4.1-hadoop2.4/bin:$PATH"
fi

#export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/
export JAVA_HOME=/usr/lib/jvm/java-8-oracle/
#export JDK_HOME=/usr/lib/jvm/java-7-openjdk-amd64/

# fix ghc-7.8.2
export LANG=C.UTF-8

# fix java <+> xmonad
export _JAVA_AWT_WM_NONREPARENTING=1

# xmonad please play well with java
export _JAVA_AWT_WM_NONREPARENTING=1

# sbt size
export SBT_OPTS="-Xmx6036M -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -Xss2M  -Duser.timezone=America/Guatemala"

# Find binary folders, update PATH
for folder in $(/usr/bin/find $HOME/bin -name bin -type d); do    
    if [ -d "$folder" ] ; then export PATH="$folder:$PATH"
    fi
done

# haskell platform 2014
export PATH="$PATH:/usr/local/haskell/ghc-7.8.3-x86_64/bin/"
export _JAVA_AWT_WM_NONREPARENTING=1 

#alias update-java-version="sudo update-alternatives --config javac && sudo update-alternatives --config java"

#alias free-idea=ibus-daemon -rd

export SBT_OPTS="-Xmx3536M -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=2G -Xss4M  -Duser.timezone=GMT"

