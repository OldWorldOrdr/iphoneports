#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/xz > /dev/null 2>&1
"$_TARGET-strip" bin/xzdec > /dev/null 2>&1
"$_TARGET-strip" lib/liblzma.5.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/xz
ldid -S"$_BSROOT/ent.xml" bin/xzdec
ldid -S"$_BSROOT/ent.xml" lib/liblzma.5.dylib
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg xz.deb
