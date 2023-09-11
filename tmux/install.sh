#!/bin/bash

THIS_DIR=$(dirname $(readlink -f $0))

ln -s $THIS_DIR/.tmux.conf $HOME
ln -s $THIS_DIR/.tmux.conf.local $HOME
