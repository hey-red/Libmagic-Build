## Linux x64

```bash
docker run --name libmagic-unix vforviolence/libmagic-llvm-unix:linux-x64-clang bash /build/libmagic_unix.sh

// Copy result to host directory
docker cp libmagic-unix:/build/dist /path/to/dist

// Remove container
docker rm -f libmagic-unix
```

## Linux musl x64
```bash
docker run --name libmagic-unix vforviolence/libmagic-llvm-unix:linux-musl-x64 sh /build/libmagic_unix.sh

// Copy result to host directory
docker cp libmagic-unix:/build/dist /path/to/dist

// Remove container
docker rm -f libmagic-unix
```
