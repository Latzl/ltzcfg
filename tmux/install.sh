#!/bin/bash

THIS_DIR=$(dirname $(readlink -f $0))

ln -sfv $THIS_DIR/.tmux.conf $HOME
# ln -sfv $THIS_DIR/.tmux.conf.local $HOME
