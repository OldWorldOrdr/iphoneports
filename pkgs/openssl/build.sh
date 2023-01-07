#!/bin/sh
(
cd source || exit 1
./Configure ios-cross --prefix=/usr --openssldir=/usr/lib/ssl CROSS_COMPILE="$_TARGET"-
make CNF_CFLAGS=-fno-common -j4
make DESTDIR=../package install_sw install_ssldirs
)

(
cd package || exit 1
rm -rf usr/share
"$_STRIP" -x usr/bin/openssl
ldid -S usr/bin/openssl
for i in usr/lib/*.dylib; do
    if [ -f "$i" ]; then
        "$_STRIP" -x "$i"
    fi
done
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package openssl-1.1.1s.deb

echo "Done" >> /tmp/lmao
