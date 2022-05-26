#!/bin/bash
set -e

os=$(uname -s)

if [[ $os == "Linux" ]]; then
    cpu_count="$(grep -c processor /proc/cpuinfo 2>/dev/null)"
    libmagic_lib="libmagic.so.1"
    strip="strip"
elif [[ $os == "Darwin" ]]; then
    cpu_count=$(sysctl -n hw.logicalcpu)
    libmagic_lib="libmagic.dylib"
    strip="strip -x"
else
    echo "$os is not a supported";
    exit 1
fi

if [ -z "$cpu_count" ]; then
  echo "Unable to determine cpu count, set default 1"
  cpu_count=1
fi

echo $"CPU count: $cpu_count";

dest_dir="/build/dist"

mkdir -p "$dest_dir"

export LDFLAGS="-L${PWD}"
export CFLAGS="-I${PWD}"
export CC="clang-14"

git clone --depth 1 https://github.com/file/file || exit 1
cd file

autoreconf -f -i

./configure --disable-silent-rules --disable-zlib --disable-xzlib --disable-bzlib
make "-j${cpu_count}"

ls src/.libs/

cp "magic/magic.mgc" $dest_dir
cp "src/.libs/$libmagic_lib" $dest_dir

cd $dest_dir
$strip $libmagic_lib

ls -lh *.*
