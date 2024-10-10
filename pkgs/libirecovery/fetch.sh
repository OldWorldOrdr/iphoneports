#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.bz2 https://github.com/libimobiledevice/libirecovery/releases/download/1.2.1/libirecovery-1.2.1.tar.bz2
printf "Unpacking source...\n"
tar -xf src.tar.bz2
rm src.tar.bz2
mv libirecovery-* src
