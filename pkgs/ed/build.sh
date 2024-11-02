#!/bin/sh
(
cd src || exit 1
for src in main.c io.c buf.c re.c glbl.c undo.c sub.c; do
  "$_TARGET-cc" -c -O3 -flto "$src" -D'__FBSDID(x)=' &
done
wait
"$_TARGET-cc" -o ed -O3 -flto ./*.o
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp ed "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" ed 2>/dev/null
ldid -S"$_ENT" ed
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ed.deb
