#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -# -o source.tar.gz https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-9.1p1.tar.gz
printf "Unpacking source...\n"
tar -xf source.tar.gz
rm source.tar.gz
mv openssh-9.1p1 source
