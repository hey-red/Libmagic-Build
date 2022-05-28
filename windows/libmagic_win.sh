#!/bin/bash
set -e

while [[ "$#" -gt 0 ]]; do case $1 in
  -r|--rid) 
  if [[ "$2" != "win-x64" && "$2" != "win-x86" && "$2" != "win-arm64" ]]; then
    echo "Invalid rid \"$2\". Available options: win-x64, win-x86, win-arm64";
    exit 1;
  fi
  rid="$2"
  ;;
  esac
  shift
done

echo "Build for RID: $rid";

if [[ $rid == "win-x64" ]]; then
  target="x86_64-w64-mingw32"
elif [[ $rid == "win-x86" ]]; then
  target="i686-w64-mingw32"
elif [[ $rid == "win-arm64" ]]; then
  target="aarch64-w64-mingw32"
else
  echo "RID $rid is not a supported";
  exit 1
fi

echo "Target $target"

cpu_count="$(grep -c processor /proc/cpuinfo 2>/dev/null)"
if [ -z "$cpu_count" ]; then
  echo "Unable to determine cpu count, set default 1"
  cpu_count=1
fi

echo $"CPU count: $cpu_count"

dest_dir="/build/dist"
bin_dir="/build/bin"
gnurx_lib="libgnurx-0.dll"
libmagic_lib="libmagic-1.dll"

mkdir -p "$dest_dir"
mkdir -p "$bin_dir"

# Build libgnurx
cd libgnurx-2.5
make "-j${cpu_count}" target=${target}-
cp $gnurx_lib $dest_dir

export LDFLAGS="-L${PWD}"
export CFLAGS="-I${PWD}"
cd ..

git clone https://github.com/file/file || exit 1
cd file

git checkout "03aa64c216828bbc844ae5a6b75c450b0e2f01d3"

# Apply patches
patch -p1 < /build/fcntl.patch

autoreconf -f -i

# Build libmagic twice
./configure --disable-silent-rules --prefix=$bin_dir
make install "-j${cpu_count}"
cp "magic/magic.mgc" $dest_dir
make clean

./configure --host=$target --disable-silent-rules --disable-zlib --disable-xzlib --disable-bzlib
make "-j${cpu_count}" FILE_COMPILE=$bin_dir/bin/file
cp "src/.libs/$libmagic_lib" $dest_dir

cd $dest_dir
ls -lh *.dll
