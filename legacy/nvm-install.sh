#!/bin/bash 

source "$HOME/.nvm/nvm.sh"
nvm install node
$(nvm which node) '/install.js'