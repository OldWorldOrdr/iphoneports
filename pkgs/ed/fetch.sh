#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://ftp.gnu.org/gnu/ed/ed-1.19.tar.lz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv ed-1.19 src
