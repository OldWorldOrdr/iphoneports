#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.xz https://download.gnome.org/sources/libxml2/2.10/libxml2-2.10.4.tar.xz
printf "Unpacking source...\n"
tar -xf source.tar.xz
rm source.tar.xz
mv libxml2-2.10.4 source
