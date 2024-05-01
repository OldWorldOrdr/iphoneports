#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share/info share/man share/doc
llvm-strip bin/nano
ldid -S"$_ENT" bin/nano
)

mkdir -p pkg/var/usr/etc
cp src/doc/sample.nanorc pkg/var/usr/etc/nanorc
sed -i 's|# include "/var/usr/share/nano/\*\.nanorc"|include "/var/usr/share/nano/*.nanorc"|' pkg/var/usr/etc/nanorc

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg nano.deb
