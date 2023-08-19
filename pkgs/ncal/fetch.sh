#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
for src in ncal.c calendar.c calendar.h easter.c; do
    curl -L -# -o "src/$src" "https://raw.githubusercontent.com/apple-oss-distributions/misc_cmds/misc_cmds-37/ncal/$src"
done
