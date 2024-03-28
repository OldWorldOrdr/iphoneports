#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --without-cython --disable-static CC="$_TARGET-cc"
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
rm -rf share
llvm-strip bin/plistutil lib/libplist-2.0.4.dylib lib/libplist++-2.0.4.dylib
ldid -S"$_ENT" bin/plistutil lib/libplist-2.0.4.dylib lib/libplist++-2.0.4.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libplist.deb
