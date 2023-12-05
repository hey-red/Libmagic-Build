dir=llvm-project

git clone --depth 1 --branch release/17.x https://github.com/llvm/llvm-project.git $dir || exit 1

cd $dir
mkdir build
cd build

# Build and install LLVM:
cmake ../llvm \
    -G "Unix Makefiles" -DLLVM_TARGETS_TO_BUILD="X86" \
    -DLLVM_ENABLE_PROJECTS="clang;lld" \
    -DCMAKE_BUILD_TYPE=MinSizeRel \
    || { echo 'Error running CMake for LLVM' ; exit 1; }
make -j$(nproc) || { echo 'Error building LLVM' ; exit 1; }
make install || { echo 'Error installing LLVM' ; exit 1; }
cd ../..
rm -rf $dir
