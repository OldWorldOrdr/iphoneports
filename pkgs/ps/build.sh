#!/bin/sh -e
(
cd src || exit 1
for src in ps.c print.c nlist.c tasks.c keyword.c; do
  "$_TARGET-cc" -Os -flto -c "$src" -D'__FBSDID(x)=' -Wno-deprecated-non-prototype -Wno-#warnings &
done
wait
"$_TARGET-cc" -o ps -Os -flto ./*.o
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp ps "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" ps 2>/dev/null || true
ldid -S"$_PKGROOT/files/ent.xml" ps
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "ps-$_DPKGARCH.deb"
