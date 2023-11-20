#!/bin/sh
(
cd src || exit 1
for patch in stdin_pipe filetype_shebang arrowkeys_normal arrowkeys_insert; do
    patch -p1 < "$patch.patch"
done
sed -i -e 's/int xtabspc = 8;/int xtabspc = 4;/g' ex.c
"$_TARGET-cc" -std=c99 -O2 -D_POSIX_C_SOURCE=200809L -D_DARWIN_C_SOURCE vi.c -o vi
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp vi "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr || exit 1
"$_TARGET-strip" bin/vi > /dev/null 2>&1
ldid -S"$_ENT" bin/vi
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg nextvi.deb
