#!/bin/sh -e
(
cd src || exit 1
"$_TARGET-c++" -Os -flto ldid.cpp -o ldid -lplist-2.0 -lcrypto -DLDID_VERSION='"2.1.5-procursus7"'
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp ldid "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
ln -s ldid ldid2
"$_TARGET-strip" ldid 2>/dev/null || true
ldid -S"$_ENT" ldid
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "ldid-$_DPKGARCH.deb"
