#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
git clone https://github.com/vim/vim.git source
