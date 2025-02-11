#!/bin/sh -e
(
cd src || exit 1
./configure --prefix=/var/usr CXX="$_TARGET-c++"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install -j"$_JOBS"
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/lzip 2>/dev/null || true
ldid -S"$_ENT" bin/lzip
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "lzip-$_DPKGARCH.deb"
