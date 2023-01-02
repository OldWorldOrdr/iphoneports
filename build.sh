#!/bin/sh
appsdir="${0%/*}/apps"
appsdir="$(cd "$appsdir" && pwd)"

applypatches() {
    if [ -d patches ]; then
        for patch in patches/*.patch; do
            echo "Applying patch $patch"
            patch -p1 < "$patch"
        done
    fi
}

includedeps() {
    if [ -f dependencies.txt ]; then
        while read -r dep; do
            if [ -d "$appsdir/$dep" ]; then
                printf "Including dependency %s\n" "$dep"
                export CFLAGS="$CFLAGS -I$appsdir/$dep/package/usr/include"
                export LDFLAGS="$LDFLAGS -L$appsdir/$dep/package/usr/lib"
            fi
        done < dependencies.txt
    fi
}

build() {
    (
    printf "Building %s...\n" "$1"
    cd "$1" || exit 1
    ./fetch.sh
    applypatches
    includedeps
    ./build.sh
    )
}

if command -v arm-apple-darwin9-clang > /dev/null; then
    _CC=arm-apple-darwin9-clang
elif command -v arm-apple-darwin9-gcc > /dev/null; then
    _CC=arm-apple-darwin9-gcc
elif command -v arm-apple-darwin9-cc > /dev/null; then
    _CC=arm-apple-darwin9-cc
else
    printf "ERROR: No valid C compiler found!\n"
    exit 1
fi

if command -v arm-apple-darwin9-clang++ > /dev/null; then
    _CXX=arm-apple-darwin9-clang++
elif command -v arm-apple-darwin9-g++ > /dev/null; then
    _CXX=arm-apple-darwin9-g++
elif command -v arm-apple-darwin9-c++ > /dev/null; then
    _CXX=arm-apple-darwin9-c++
else
    printf "ERROR: No valid C++ compiler found!\n"
    exit 1
fi

if command -v arm-apple-darwin9-strip > /dev/null; then
    if arm-apple-darwin9-strip --version 2> /dev/null | grep -q "GNU"; then
        printf "ERROR: GNU/LLVM strip is not supported!\n"
        exit 1
    fi
else
    printf "ERROR: No valid strip command found!\n"
    exit 1
fi

if ! command -v ldid > /dev/null; then
    printf "ERROR: ldid not found!\n"
fi

if ! command -v dpkg-deb > /dev/null; then
    printf "ERROR: dpkg-deb not found!\n"
fi

export _CC _CXX

if [ -z "$1" ]; then
    printf "Usage: %s <package>\n" "${0##*/}"
    exit 1
fi

cd "$appsdir" || exit 1

if [ "$1" = "all" ]; then
    for i in *; do
        build "$i"
    done
fi

[ -d "$1" ] && build "$1"
