#!/bin/sh -e
mkdir -p src/build src/tmpbin

cpu="${_TARGET%%-*}"

case $cpu in
    arm64|arm64e|aarch64)
        cpu_family=aarch64
        asm=true
    ;;

    armv7*)
        cpu_family=arm
        asm=true
    ;;

    arm*)
        cpu_family=arm
        asm=false
    ;;

    x86_64|x86_64h)
        cpu_family=x86_64
        asm=true
    ;;

    i386)
        cpu_family=x86
        asm=true
    ;;

    *)
        echo "UNSUPPORTED ARCHITECTURE"
        exit 1
    ;;
esac

subsystem= # shut up shellcheck
eval "$("$_TARGET-cc" -E -xc files/subsystem.sh)"

sed -e "s|@CC@|$_TARGET-cc|g" \
    -e "s|@CXX@|$_TARGET-c++|g" \
    -e "s|@AR@|$_TARGET-ar|g" \
    -e "s|@RANLIB@|$_TARGET-ranlib|g" \
    -e "s|@SDK@|$_SDK|g" \
    -e "s|@CPU@|$cpu|g" \
    -e "s|@CPU_FAMILY@|$cpu_family|g" \
    -e "s|@SUBSYSTEM@|$subsystem|g" \
    files/iphoneports.meson > src/iphoneports.meson

[ "$_INSTALLNAMETOOL" != "install_name_tool" ] && printf '%s' "\
#!/bin/sh -e
exec \"$(command -v "$_INSTALLNAMETOOL")\" \"\$@\"
" > src/tmpbin/install_name_tool && chmod +x src/tmpbin/install_name_tool

[ "$_OTOOL" != "otool" ] && printf '%s' "\
#!/bin/sh -e
exec \"$(command -v "$_OTOOL")\" \"\$@\"
" > src/tmpbin/otool && chmod +x src/tmpbin/otool

export PATH="$_PKGROOT/src/tmpbin:$PATH"

(
cd src/build || exit 1
meson setup .. --cross-file="$_PKGROOT/src/iphoneports.meson" --prefix=/var/usr -Denable_asm="$asm" -Denable_tests=false
DESTDIR="$_PKGROOT/pkg" ninja install -j"$_JOBS"
)

(
cd pkg/var/usr || exit 1
"$_TARGET-strip" bin/dav1d lib/libdav1d.7.dylib 2>/dev/null || true
ldid -S"$_ENT" bin/dav1d lib/libdav1d.7.dylib
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "dav1d-$_DPKGARCH.deb"
