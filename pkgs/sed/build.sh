#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr
"$_MAKE" -j8
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
"$_CP" sed/sed "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" sed > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" sed
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg sed.deb
