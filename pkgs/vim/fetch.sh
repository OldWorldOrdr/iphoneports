#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone --depth 1 https://github.com/vim/vim.git src
