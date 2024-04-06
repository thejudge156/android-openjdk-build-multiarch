#!/bin/bash
set -e
. setdevkitpath.sh

if [ "$BUILD_IOS" != "1" ]; then

unset AR AS CC CXX LD OBJCOPY RANLIB STRIP CPPFLAGS LDFLAGS
git clone --depth 1 -b 'v2.2.0' https://github.com/termux/termux-elf-cleaner || true
cd termux-elf-cleaner
autoreconf --install
bash configure
make CFLAGS=-D__ANDROID_API__=32
cd ..

findexec() { find $1 -type f -name "*" -not -name "*.o" -exec sh -c '
    case "$(head -n 1 "$1")" in
      ?ELF*) exit 0;;
      MZ*) exit 0;;
      #!*/ocamlrun*)exit0;;
    esac
exit 1
' sh {} \; -print
}

fi

cp -rv jre_override/lib/* jreout/lib/ || true

cd jreout
tar cJf ../jre21-${TARGET_SHORT}-`date +%Y%m%d`-${JDK_DEBUG_LEVEL}.tar.xz .

cd ../jdkout
tar cJf ../jdk21-${TARGET_SHORT}-`date +%Y%m%d`-${JDK_DEBUG_LEVEL}.tar.xz .

