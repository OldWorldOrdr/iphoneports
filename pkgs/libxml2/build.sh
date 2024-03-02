#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --without-python --with-zlib --with-lzma PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share/doc share/gtk-doc share/man
ln -s libxml2/libxml include/libxml
llvm-strip bin/xmlcatalog bin/xmllint lib/libxml2.2.dylib
ldid -S"$_ENT" bin/xmlcatalog bin/xmllint lib/libxml2.2.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libxml2.deb
