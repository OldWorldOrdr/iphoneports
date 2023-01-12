#!/bin/sh
(
cd source || exit 1
"$_MAKE" PLAT=macosx INSTALL_TOP=/usr CC=arm-apple-darwin9-clang RANLIB=arm-apple-darwin9-ranlib
"$_MAKE" PLAT=macosx INSTALL_TOP="$_PKGROOT/package/usr" CC=arm-apple-darwin9-clang RANLIB=arm-apple-darwin9-ranlib install
)

(
cd package || exit 1
rm -rf usr/man
"$_TARGET-strip" -x usr/bin/lua
"$_TARGET-strip" -x usr/bin/luac
"$_TARGET-strip" -x usr/lib/liblua.a
ldid -S"$_BSROOT/entitlements.plist" usr/bin/lua
ldid -S"$_BSROOT/entitlements.plist" usr/bin/luac
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package lua-5.4.4.deb
